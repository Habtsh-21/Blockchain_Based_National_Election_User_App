import 'package:blockchain_based_national_election_user_app/features/auth/domain/entites/profile.dart';

class ProfileModel extends Profile {
  ProfileModel(
      {required super.userId,
      required super.firstName,
      required super.lastName,
      required super.faydaNo,
      required super.stateId});
}
