import 'package:blockchain_based_national_election_user_app/core/resource/type.dart';
import 'package:blockchain_based_national_election_user_app/features/auth/domain/repository/auth_repo.dart';

class SignUpUsecase {
  AuthRepository authRepository;

  SignUpUsecase({required this.authRepository});

  UserData call(String firstName, String middleName, String lastName,
      int faydaNo, String email, int password) {
    return authRepository.signUp(
        firstName, middleName, lastName, faydaNo, email, password);
  }
}
