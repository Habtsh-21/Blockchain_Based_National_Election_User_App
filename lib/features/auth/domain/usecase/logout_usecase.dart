import 'package:blockchain_based_national_election_user_app/core/resource/type.dart';
import 'package:blockchain_based_national_election_user_app/features/auth/domain/repository/auth_repo.dart';

class LogoutUsecase {
  AuthRepository authRepository;

  LogoutUsecase({required this.authRepository});

  UserUnit call() {
    return authRepository.logout();
  }
}
