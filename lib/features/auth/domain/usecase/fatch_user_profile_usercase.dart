import 'package:blockchain_based_national_election_user_app/core/resource/type.dart';
import 'package:blockchain_based_national_election_user_app/features/auth/domain/repository/auth_repo.dart';

class FatchUserProfileUsercase {
  AuthRepository authRepository;

  FatchUserProfileUsercase({required this.authRepository});

  UserData call(String userId) {
    return authRepository.fatchUserProfile(userId);
  }
}
