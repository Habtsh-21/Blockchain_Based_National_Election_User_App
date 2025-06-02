import 'package:blockchain_based_national_election_user_app/core/exception/exception.dart';
import 'package:blockchain_based_national_election_user_app/core/failure/failure.dart';
import 'package:blockchain_based_national_election_user_app/core/network/network.dart';
import 'package:blockchain_based_national_election_user_app/core/resource/type.dart';
import 'package:blockchain_based_national_election_user_app/features/auth/data/auth_model/profileModel.dart';
import 'package:blockchain_based_national_election_user_app/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:blockchain_based_national_election_user_app/features/auth/domain/repository/auth_repo.dart';
import 'package:dartz/dartz.dart';

class AuthRepoImpl extends AuthRepository {
  NetworkInfo networkInfo;
  AuthRemoteDataSource authRemoteDataSource;

  AuthRepoImpl({required this.networkInfo, required this.authRemoteDataSource});

  @override
  UserUnit userDetail(ProfileModel signUpModel) async {
    if (await networkInfo.isConnected) {
      try {
        await authRemoteDataSource.userDatail(signUpModel);
        return const Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      } on UserNotFoundException {
        return Left(UserNotFoundFailure());
      } on InvalidEmailException {
        return Left(InvalidEmailFailure());
      } on UserDisableException {
        return Left(UserDisabledFailure());
      } on EmailAlreadyInUseException {
        return Left(EmailAlreadyInUseFailure());
      } on OperationNotAllowedException {
        return Left(OperationNotAllowedFailure());
      } on TooManyRequestsException {
        return Left(TooManyRequestsFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  UserUnit logIn(String email, String passowrd) async {
    if (await networkInfo.isConnected) {
      try {
        await authRemoteDataSource.login(email, passowrd);
        return const Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      } on EmailNotVerifiedException {
        return Left(EmailNotVerifiedFailure());
      } on UserNotFoundException {
        return Left(UserNotFoundFailure());
      } on WrongPasswordException {
        return Left(WrongPasswordFailure());
      } on InvalidEmailException {
        return Left(InvalidEmailFailure());
      } on UserDisableException {
        return Left(UserDisabledFailure());
      } on EmailAlreadyInUseException {
        return Left(EmailAlreadyInUseFailure());
      } on OperationNotAllowedException {
        return Left(OperationNotAllowedFailure());
      } on TooManyRequestsException {
        return Left(TooManyRequestsFailure());
      } catch (e) {
        if (e is TransactionFailedException) {
          return Left(TransactionFailedFailure(message: e.message));
        } else {
          return Left(ServerFailure());
        }
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  UserUnit signUp(String email, String password) async {
    if (await networkInfo.isConnected) {
      try {
        await authRemoteDataSource.signUp(email, password);
        return const Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      } on UserNotFoundException {
        return Left(UserNotFoundFailure());
      } on WrongPasswordException {
        return Left(WrongPasswordFailure());
      } on InvalidEmailException {
        return Left(InvalidEmailFailure());
      } on UserDisableException {
        return Left(UserDisabledFailure());
      } on EmailAlreadyInUseException {
        return Left(EmailAlreadyInUseFailure());
      } on OperationNotAllowedException {
        return Left(OperationNotAllowedFailure());
      } on TooManyRequestsException {
        return Left(TooManyRequestsFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  UserUnit logout() async {
    try {
      await authRemoteDataSource.logout();
      return const Right(unit);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  UserData fatchUserProfile(String userId, {attempt = 1}) async {
    int maxAttempts = 10;
    if (await networkInfo.isConnected) {
      try {
        final userProfile = await authRemoteDataSource.fetchUserProfile(userId);
        return Right(userProfile);
      } on ServerException {
        return Left(ServerFailure());
      } on UserNotFoundException {
        return Left(UserNotFoundFailure());
      } on WrongPasswordException {
        return Left(WrongPasswordFailure());
      } on InvalidEmailException {
        return Left(InvalidEmailFailure());
      } on UserDisableException {
        return Left(UserDisabledFailure());
      } on EmailAlreadyInUseException {
        return Left(EmailAlreadyInUseFailure());
      } on OperationNotAllowedException {
        return Left(OperationNotAllowedFailure());
      } on TooManyRequestsException {
        return Left(TooManyRequestsFailure());
      }
    } else {
      if (attempt < maxAttempts) {
        await Future.delayed(const Duration(seconds: 3));
        return await fatchUserProfile(userId, attempt: attempt + 1);
      } else {
        return Left(OfflineFailure());
      }
    }
  }
}
