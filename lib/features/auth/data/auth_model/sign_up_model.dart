import 'package:blockchain_based_national_election_user_app/features/auth/domain/entites/profile.dart';

class SignUpModel extends Profile {
  SignUpModel({
    required super.firstName,
    required super.middleName,
    required super.lastName,
    required super.faydaNo,
    required super.email,
    required super.password,
  });
}
