import 'package:blockchain_based_national_election_user_app/core/resource/type.dart';
import 'package:blockchain_based_national_election_user_app/features/auth/domain/repository/auth_repo.dart';

class LoginUsecase {
  AuthRepository authRepository;

  LoginUsecase({required this.authRepository});

  UserData call(String email, int password) {
    return authRepository.logIn(email,password);
  }
}
