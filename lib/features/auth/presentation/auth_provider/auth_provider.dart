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
import 'package:blockchain_based_national_election_user_app/features/auth/domain/usecase/update_usecase.dart';
import 'package:blockchain_based_national_election_user_app/features/auth/domain/usecase/user_detail_usecase.dart';
import 'package:blockchain_based_national_election_user_app/features/auth/presentation/auth_provider/provider_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

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
final userUpdateProvider = Provider<UpdateUsecase>(
  (ref) {
    final authRepository = ref.watch(authRepoProvider);
    return UpdateUsecase(authRepository: authRepository);
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

AuthProviderState stateChecker(Either either, AuthProviderState pState) {
  return either.fold(
      (failure) => AuthFailureState(message: _mapFailureToMessage(failure)),
      (r) => pState);
}

class AuthNotifier extends StateNotifier<AuthProviderState> {
  final LoginUsecase logInUsecase;
  final SignupUsecase signUpUsecase;
  final UserDetailUsecase userDetailUsecase;
  final UpdateUsecase updateUsecase;
  final FatchUserProfileUsercase fatchUserProfileUsercase;
  final LogoutUsecase logOutUsecase;
  AuthNotifier(
      {required this.logInUsecase,
      required this.signUpUsecase,
      required this.userDetailUsecase,
      required this.updateUsecase,
      required this.fatchUserProfileUsercase,
      required this.logOutUsecase})
      : super(InitialState());
  Map<String, dynamic>? userProfile;

  Future<void> login(String email, String password) async {
    state = LogingInState();

    final result = await logInUsecase(email, password);
    state = stateChecker(result, LoggedInState());
  }

  Future<void> signUp(String email, String password) async {
    state = SigningUpState();

    final result = await signUpUsecase(email, password);
    state = stateChecker(result, SignedUpState());
  }

  Future<void> userDetail(String userId, String firstName, String lastName,
      int faydaNo, int stateId) async {
    state = UserDetailUploadingState();

    final result =
        await userDetailUsecase(userId, firstName, lastName, faydaNo, stateId);
    state = stateChecker(result, UserDetailUpleadedState());
  }
    Future<void> updateUser(String userId,Map<String,dynamic> userData) async {
    state = UserUpdatingState();

    final result =
        await updateUsecase(userId, userData);
    state = stateChecker(result, UserUpdatedState());
  }
  
  
  Future<void> fatchUserProfile(String userId) async {
    state = UserProfileFatchingState();

    final result = await fatchUserProfileUsercase(userId);

    state = result.fold(
      (l) => AuthFailureState(message: _mapFailureToMessage(l)),
      (r) {
        userProfile = r;
        return UserProfileFatchedState();
      },
    );
  }

  Map<String, dynamic>? getUserDetail() {
    return userProfile;
  }

  Future<void> logout() async {
    state = LoggingOutState();
    final result = await logOutUsecase();
    state = stateChecker(result, LoggedOutState());
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
      updateUsecase: ref.watch(userUpdateProvider),
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
