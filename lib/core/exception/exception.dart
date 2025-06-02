class ServerException implements Exception {}

class OfflineException implements Exception {}

class NoUserException implements Exception {}

class WrongPasswordException implements Exception {}

class TooManyRequestsException implements Exception {}

class UserAlreadyExistsException implements Exception{}
class PermissionDenidException implements Exception {}

class InvalidEmailException implements Exception {}

class UserDisableException implements Exception {}

class UserNotFoundException implements Exception {}

class EmailAlreadyInUseException implements Exception {}

class OperationNotAllowedException implements Exception {}

class PartyAlreadyExistException implements Exception {}

class StateAlreadyExistException implements Exception {}

class RepAlreadyExistException implements Exception {}

class EmailNotVerifiedException implements Exception{}
class TransactionFailedException implements Exception {
  final String message;
  TransactionFailedException({required this.message});
}

class NullPublicUrlException implements Exception {}

class UnknownException implements Exception {}
