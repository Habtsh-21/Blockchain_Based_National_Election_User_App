import 'package:blockchain_based_national_election_user_app/core/failure/failure.dart';
import 'package:blockchain_based_national_election_user_app/core/network/network.dart';
import 'package:blockchain_based_national_election_user_app/core/string/string.dart';
import 'package:blockchain_based_national_election_user_app/features/auth/data/auth_repo_impl.dart';
import 'package:blockchain_based_national_election_user_app/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:blockchain_based_national_election_user_app/features/auth/domain/repository/auth_repo.dart';
import 'package:blockchain_based_national_election_user_app/features/auth/domain/usecase/fatch_user_profile_usercase.dart';
import 'package:blockchain_based_national_election_user_app/features/auth/domain/usecase/login_usecase.dart';
import 'package:blockchain_based_national_election_user_app/features/auth/domain/usecase/logout_usecase.dart';
import 'package:blockchain_based_national_election_user_app/features/auth/domain/usecase/signup_usecase.dart';
import 'package:blockchain_based_national_election_user_app/features/auth/domain/usecase/user_detail_usecase.dart';
import 'package:blockchain_based_national_election_user_app/features/auth/presentation/auth_provider/provider_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:web3dart/crypto.dart';

final connectionProvider = Provider<InternetConnection>(
  (ref) => InternetConnection(),
);
final authRemoteSourceRepoProvider = Provider<AuthRemoteDataSource>(
  (ref) => AuthRemoteDataSourceImpl(),
);
final networkInfoProvider = Provider<NetworkInfo>((ref) {
  final connectionChecker = ref.watch(connectionProvider);
  return NetworkInfoImpl(connectionChecker);
});

final authRepoProvider = Provider<AuthRepository>(
  (ref) {
    final remoteDataSource = ref.watch(authRemoteSourceRepoProvider);
    final networkInfo = ref.watch(networkInfoProvider);
    return AuthRepoImpl(
        networkInfo: networkInfo, authRemoteDataSource: remoteDataSource);
  },
);

final logInUsecaseProvider = Provider<LoginUsecase>(
  (ref) {
    final authRepository = ref.watch(authRepoProvider);
    return LoginUsecase(authRepository: authRepository);
  },
);

final signUpProvider = Provider<SignupUsecase>(
  (ref) {
    final authRepository = ref.watch(authRepoProvider);
    return SignupUsecase(authRepository: authRepository);
  },
);
final userDetailProvider = Provider<UserDetailUsecase>(
  (ref) {
    final authRepository = ref.watch(authRepoProvider);
    return UserDetailUsecase(authRepository: authRepository);
  },
);

final fatchUserProfileProvider = Provider<FatchUserProfileUsercase>(
  (ref) {
    final authRepository = ref.watch(authRepoProvider);
    return FatchUserProfileUsercase(authRepository: authRepository);
  },
);

final logOutUsercaseProvider = Provider<LogoutUsecase>(
  (ref) {
    final authRepository = ref.watch(authRepoProvider);
    return LogoutUsecase(authRepository: authRepository);
  },
);

String hashFaydaNo(String faydaNo) {
  final hashBytes = keccakUtf8(faydaNo); // Ethereum-style keccak256 hash
  return '0x${bytesToHex(hashBytes)}';
}

class AuthNotifier extends StateNotifier<AuthProviderState> {
  final LoginUsecase logInUsecase;
  final SignupUsecase signUpUsecase;
  final UserDetailUsecase userDetailUsecase;
  final FatchUserProfileUsercase fatchUserProfileUsercase;
  final LogoutUsecase logOutUsecase;
  AuthNotifier(
      {required this.logInUsecase,
      required this.signUpUsecase,
      required this.userDetailUsecase,
      required this.fatchUserProfileUsercase,
      required this.logOutUsecase})
      : super(InitialState());
  Map<String, dynamic>? userProfile;
  int totalUser = 0;

  Future<void> login(String email, String password) async {
    state = LoggingInState();

    final result = await logInUsecase(email, password);
    state = result.fold((l) {
      return LoginFailureState(message: _mapFailureToMessage(l));
    }, (r) {
      return LoggedInState();
    });

    Future.delayed(const Duration(seconds: 3), () => resetState());
  }

  Future<void> signUp(String email, String password) async {
    state = SigningUpState();

    final result = await signUpUsecase(email, password);
    state = result.fold((l) {
      return SignupFailureState(message: _mapFailureToMessage(l));
    }, (r) {
      return SignedUpState();
    });

    Future.delayed(const Duration(seconds: 3), () => resetState());
  }

  Future<void> userDetail(String userId, String firstName, String lastName,
      int faydaNo, int stateId) async {
    state = UserDetailUploadingState();

    final result =
        await userDetailUsecase(userId, firstName, lastName, faydaNo, stateId);
    state = result.fold((l) {
      return UserDetailUploadFailureState(message: _mapFailureToMessage(l));
    }, (r) {
      return UserDetailUploadedState();
    });

    Future.delayed(const Duration(seconds: 3), () => resetState());
  }

  Future<void> fatchUserProfile(String userId) async {
    state = UserProfileFetchingState();

    final result = await fatchUserProfileUsercase(userId);

    state = result.fold(
      (l) => UserProfileFetchFailureState(message: _mapFailureToMessage(l)),
      (r) {
        if (r.userProfile != null) {
          int faydaNo = r.userProfile!['fayda_no'];
          r.userProfile!['fayda_no'] = hashFaydaNo(faydaNo.toString());
        }
        userProfile = r.userProfile;
        totalUser = r.vefiedUserCount;
        return UserProfileFetchedState();
      },
    );
    Future.delayed(const Duration(seconds: 3), () => resetState());
  }

  int getTotalVoter() {
    return totalUser;
  }

  Map<String, dynamic>? getUserDetail() {
    if (userProfile == null) {
      return null;
    }
    return userProfile;
  }

  String hashedFaydaNo() {
    if (userProfile == null) {
      return '0x0000000000000000000';
    }
    return userProfile!['fayda_no'];
  }

  Future<void> logout() async {
    state = LoggingOutState();
    final result = await logOutUsecase();
    state = result.fold(
      (l) => LoginFailureState(message: _mapFailureToMessage(l)),
      (r) {
        return LoggedOutState();
      },
    );
    Future.delayed(const Duration(seconds: 3), () => resetState());
  }

  void resetState() {
    state = InitialState();
  }
}

final authStateProvider =
    StateNotifierProvider<AuthNotifier, AuthProviderState>((ref) {
  return AuthNotifier(
    logInUsecase: ref.watch(logInUsecaseProvider),
    logOutUsecase: ref.watch(logOutUsercaseProvider),
    fatchUserProfileUsercase: ref.watch(fatchUserProfileProvider),
    signUpUsecase: ref.watch(signUpProvider),
    userDetailUsecase: ref.watch(userDetailProvider),
  );
});

String _mapFailureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case const (InvalidEmailFailure):
      return INVALID_EMAIL;
    case const (UserDisabledFailure):
      return USER_DISABLED;
    case const (EmailAlreadyInUseFailure):
      return ALREADY_LOGGED_IN;
    case const (OperationNotAllowedFailure):
      return OPERATION_IS_NOT_ALLOWED;
    case const (ServerFailure):
      return SERVER_FAILURE_MESSAGE;
    case const (TransactionFailedFailure):
      return (failure as TransactionFailedFailure).message;
    case const (EmailNotVerifiedFailure):
      return EMAIL_NOT_VERIFIED;
    case const (OfflineFailure):
      return OFFLINE_FAILURE_MESSAGE;
    case const (UserNotFoundFailure):
      return NO_USER_FAILURE_MESSAGE;
    case const (TooManyRequestsFailure):
      return TOO_MANY_REQUESTS_FAILURE_MESSAGE;
    case const (WrongPasswordFailure):
      return WRONG_PASSWORD_FAILURE_MESSAGE;
    default:
      return "Unexpected Error , Please try again later .";
  }
}
