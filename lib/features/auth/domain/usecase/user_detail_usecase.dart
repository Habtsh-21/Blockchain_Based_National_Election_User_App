import 'package:blockchain_based_national_election_user_app/core/resource/type.dart';
import 'package:blockchain_based_national_election_user_app/features/auth/data/auth_model/profileModel.dart';
import 'package:blockchain_based_national_election_user_app/features/auth/domain/repository/auth_repo.dart';

class UserDetailUsecase {
  AuthRepository authRepository;

  UserDetailUsecase({required this.authRepository});

  UserUnit call(String userId, String firstName,String lastName, int faydaNo, int stateId) {
    return authRepository.userDetail(ProfileModel(
      userId: userId,
      firstName: firstName,
      lastName:lastName,
      faydaNo: faydaNo,
      stateId: stateId,
    ));
  }
}
