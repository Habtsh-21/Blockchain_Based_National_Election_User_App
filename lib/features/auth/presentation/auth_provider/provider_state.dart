abstract class AuthProviderState {}

class InitialState extends AuthProviderState {}

class LoggingInState extends AuthProviderState {}
class LoggedInState extends AuthProviderState {}
class LoginFailureState extends AuthProviderState {
  final String message;
  LoginFailureState({required this.message});
}


class LoggingOutState extends AuthProviderState {}
class LoggedOutState extends AuthProviderState {}
class LogoutFailureState extends AuthProviderState {
  final String message;
  LogoutFailureState({required this.message});
}


class SigningUpState extends AuthProviderState {}
class SignedUpState extends AuthProviderState {}
class SignupFailureState extends AuthProviderState {
  final String message;
  SignupFailureState({required this.message});
}


class UserProfileFetchingState extends AuthProviderState {}
class UserProfileFetchedState extends AuthProviderState {}
class UserProfileFetchFailureState extends AuthProviderState {
  final String message;
  UserProfileFetchFailureState({required this.message});
}

class UserUpdatingState extends AuthProviderState {}
class UserUpdatedState extends AuthProviderState {}
class UserUpdateFailureState extends AuthProviderState {
  final String message;
  UserUpdateFailureState({required this.message});
}

class UserDetailUploadingState extends AuthProviderState {}
class UserDetailUploadedState extends AuthProviderState {}
class UserDetailUploadFailureState extends AuthProviderState {
  final String message;
  UserDetailUploadFailureState({required this.message});
}
