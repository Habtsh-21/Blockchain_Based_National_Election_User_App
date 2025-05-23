


import 'package:blockchain_based_national_election_user_app/core/resource/type.dart';

abstract class AuthRepository { 
    UserData signUp(String firstName,String middleName,String lastName,int faydaNo,String email,int password);
    UserData logIn(String email,int passowrd);
}




