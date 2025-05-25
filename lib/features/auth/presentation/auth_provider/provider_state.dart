abstract class AuthProviderState {}

class InitialState extends AuthProviderState {}

class LogingInState extends AuthProviderState {}

class LoggedInState extends AuthProviderState {}

class LoggingOutState extends AuthProviderState {}

class LoggedOutState extends AuthProviderState {}

class SigningUpState extends AuthProviderState {}

class SignedUpState extends AuthProviderState {}

class UserProfileFatchingState extends AuthProviderState {}

class UserProfileFatchedState extends AuthProviderState {}

class UserUpdatingState extends AuthProviderState{}

class UserUpdatedState extends AuthProviderState{}

class UserDetailUploadingState extends AuthProviderState {}

class UserDetailUpleadedState extends AuthProviderState {}

class AuthFailureState extends AuthProviderState {
  String message;
  AuthFailureState({required this.message});
}
