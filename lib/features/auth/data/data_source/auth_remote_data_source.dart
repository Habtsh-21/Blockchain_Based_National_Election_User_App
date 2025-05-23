import 'package:blockchain_based_national_election_user_app/core/exception/exception.dart';
import 'package:blockchain_based_national_election_user_app/features/auth/data/auth_model/login_model.dart';
import 'package:blockchain_based_national_election_user_app/features/auth/data/auth_model/sign_up_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRemoteDataSource {
  Future<Map<dynamic, dynamic>> signUp(SignUpModel signUpModel);
  Future<Map<dynamic, dynamic>> login(LoginModel loginModel);
}

class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  final supabase = Supabase.instance.client;

  @override
  Future<Map<dynamic, dynamic>> login(LoginModel loginModel) async {
    print('Trying login with: ${loginModel.email}/${loginModel.password}');

    try {
      final response = await supabase.auth.signInWithPassword(
          email: loginModel.email, password: loginModel.password.toString());
      if (response.user == null) {
        throw ServerException();
      }
      User? user = response.user;

      if (user == null) {
        throw UserNotFoundException();
      }
      final profile =
          await supabase.from('profiles').select().eq('id', user.id).single();
      return profile;
    } on AuthException catch (e) {
      print('auth exception: code=${e.code}, message=${e.message}');
      final message = e.message.toLowerCase();
      if (message.contains('invalid login credentials')) {
        throw WrongPasswordException();
      } else if (message.contains('invalid email')) {
        throw InvalidEmailException();
      } else if (message.contains('user not found')) {
        throw UserNotFoundException();
      } else if (message.contains('signups not allowed')) {
        throw OperationNotAllowedException();
      } else if (message.contains('too many requests')) {
        throw TooManyRequestsException();
      } else {
        throw ServerException();
      }
    } catch (e) {
      print('Other error: $e');
      throw ServerException();
    }
  }

  @override
  Future<Map<dynamic, dynamic>> signUp(SignUpModel signUpModel) async {
    print('Trying login with: ${signUpModel.email}/${signUpModel.password}');

    try {
      final response = await supabase.auth.signUp(
          email: signUpModel.email, password: signUpModel.password.toString());
      if (response.user == null) {
        throw ServerException();
      }

      final userId = response.user?.id;
      if (userId == null) {
        throw Exception('User ID is null. Signup might have failed.');
      }

      await supabase.from('profile').insert({
        'id': userId,
        'first_name': signUpModel.firstName,
        'middle_name': signUpModel.middleName,
        'last_name': signUpModel.lastName,
        'fayda_no': signUpModel.faydaNo,
      });

      print('User and profile created.');
      final profile =
          await supabase.from('profiles').select().eq('id', userId).single();
      return profile;
    } on AuthException catch (e) {
      print('Auth exception: code=${e.code}, message=${e.message}');
      final message = e.message.toLowerCase();

      if (message.contains('invalid email')) {
        throw InvalidEmailException();
      } else if (message.contains('user already registered') ||
          message.contains('user already exists')) {
        throw UserAlreadyExistsException();
      } else if (message.contains('signups not allowed')) {
        throw OperationNotAllowedException();
      } else if (message.contains('too many requests')) {
        throw TooManyRequestsException();
      } else {
        throw ServerException();
      }
    } catch (e) {
      print('❌ Other error: $e');
      throw ServerException();
    }
  }
}
