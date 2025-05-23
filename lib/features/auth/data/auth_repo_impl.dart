import 'package:blockchain_based_national_election_user_app/core/exception/exception.dart';
import 'package:blockchain_based_national_election_user_app/core/failure/failure.dart';
import 'package:blockchain_based_national_election_user_app/core/network/network.dart';
import 'package:blockchain_based_national_election_user_app/core/resource/type.dart';
import 'package:blockchain_based_national_election_user_app/features/auth/data/auth_model/login_model.dart';
import 'package:blockchain_based_national_election_user_app/features/auth/data/auth_model/sign_up_model.dart';
import 'package:blockchain_based_national_election_user_app/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:blockchain_based_national_election_user_app/features/auth/domain/repository/auth_repo.dart';
import 'package:dartz/dartz.dart';

class AuthRepoImpl extends AuthRepository {
  NetworkInfo networkInfo;
  AuthRemoteDataSource authRemoteDataSource;

  AuthRepoImpl({required this.networkInfo, required this.authRemoteDataSource});

  @override
  UserData signUp(String firstName, String middleName, String lastName,
      int faydaNo, String email, int password) async {
    if (await networkInfo.isConnected) {
      try {
        SignUpModel signUpModel = SignUpModel(
          firstName: firstName,
          middleName: middleName,
          lastName: lastName,
          faydaNo: faydaNo,
          email: email,
          password: password,
        );
        final profileDetail = await authRemoteDataSource.signUp(signUpModel);
        return Right(profileDetail);
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
  UserData logIn(String email, int passowrd) async {
    if (await networkInfo.isConnected) {
      try {
        LoginModel loginModel = LoginModel(
          email: email,
          password: passowrd,
        );
        final profileDetail = await authRemoteDataSource.login(loginModel);
        return Right(profileDetail);
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
}
