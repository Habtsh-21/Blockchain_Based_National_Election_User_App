import 'package:blockchain_based_national_election_user_app/core/resource/type.dart';
import 'package:blockchain_based_national_election_user_app/features/auth/data/auth_model/profileModel.dart';

abstract class AuthRepository {
  UserUnit userDetail(ProfileModel signUpModel);
  UserUnit logIn(String email, String passowrd);
  UserUnit signUp(String email, String password);
  UserData fatchUserProfile(String userId);
  UserUnit logout();
}
