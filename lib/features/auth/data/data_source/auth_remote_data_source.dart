import 'package:blockchain_based_national_election_user_app/core/exception/exception.dart';
import 'package:blockchain_based_national_election_user_app/features/auth/data/auth_model/profileModel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRemoteDataSource {
  Future<void> signUp(String email, String password);
  Future<void> login(String email, String password);
  Future<void> userDatail(ProfileModel signUpModel);
  Future<void> updateUserDetail(String userId, Map<String, dynamic> userDetail);
  Future<Map<String, dynamic>?> fetchUserProfile(String userId);
  Future<void> logout();
}

class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  final supabase = Supabase.instance.client;

  @override
  Future<void> login(String email, String password) async {
    print('Trying login with: $email/$password');

    try {
      final response = await supabase.auth
          .signInWithPassword(email: email, password: password);
      if (response.user == null) {
        throw ServerException();
      }
      User? user = response.user;

      if (user == null) {
        throw UserNotFoundException();
      }
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
  Future<void> signUp(String email, String password) async {
    print('Trying signup with: $email/$password');

    try {
      final response =
          await supabase.auth.signUp(email: email, password: password);
      if (response.user == null) {
        throw ServerException();
      }

      final userId = response.user?.id;
      if (userId == null) {
        throw Exception('User ID is null. Signup might have failed.');
      }

      print('User and profile created.');
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
      print('Other error: $e');
      throw ServerException();
    }
  }

  @override
  Future<void> userDatail(ProfileModel signUpModel) async {
    try {
      await supabase.from('profiles').insert({
        'id': signUpModel.userId,
        'first_name': signUpModel.firstName,
        'last_name': signUpModel.lastName,
        'fayda_no': signUpModel.faydaNo,
        'state_Id': signUpModel.stateId,
      });
      print('profile created.');
    } on AuthException catch (e) {
      print('Auth exception: code=${e.code}, message=${e.message}');
      final message = e.message.toLowerCase();
      if (message.contains('too many requests')) {
        throw TooManyRequestsException();
      } else {
        throw TransactionFailedException(message: e.message);
      }
    } catch (e) {
      print('Other error: $e');
      throw TransactionFailedException(message: e.toString());
    }
  }

  @override
  Future<void> updateUserDetail(
      String userId, Map<String, dynamic> userDetail) async {
    try {
      print(
          '----------------------------------------updating---------------------------------------------');
      print(userId);
      print(userDetail);
      final response = await Supabase.instance.client
          .from('profiles')
          .update(userDetail)
          .eq('id', userId);

      if (response.error != null) {
        print(response.error!.message);
        TransactionFailedException(message: response.error!.message);
      } else {
        print(' updated successfully');
      }
    } catch (e) {
      print('Other error: $e');
      throw TransactionFailedException(message: e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>?> fetchUserProfile(String userId) async {
  
    try {
      final response = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();

      return response;
    } on AuthException catch (e) {
      print('Auth exception: code=${e.code}, message=${e.message}');
      final message = e.message.toLowerCase();

      if (message.contains('too many requests')) {
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
  Future<void> logout() async {
    try {
      await Supabase.instance.client.auth.signOut();
      print('Logout successful');
    } catch (e) {
      print('Logout failed: $e');
      throw ServerException();
    }
  }
}
