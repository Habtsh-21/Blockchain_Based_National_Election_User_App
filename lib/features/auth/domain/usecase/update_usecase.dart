import 'package:blockchain_based_national_election_user_app/core/resource/type.dart';
import 'package:blockchain_based_national_election_user_app/features/auth/domain/repository/auth_repo.dart';

class UpdateUsecase {
  AuthRepository authRepository;

  UpdateUsecase({required this.authRepository});

  UserUnit call(String userId, Map<String, dynamic> userDetail) {
    return authRepository.updateUserDetail(userId, userDetail);
  }
}
