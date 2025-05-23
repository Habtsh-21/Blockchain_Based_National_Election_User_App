import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object?> get props => [];
}

class OfflineFailure extends Failure {}

class ServerFailure extends Failure {}

class WrongPasswordFailure extends Failure {}

class TooManyRequestsFailure extends Failure {}

class UserNotFoundFailure extends Failure {}

class InvalidEmailFailure extends Failure {}

class UserDisabledFailure extends Failure {}

class EmailAlreadyInUseFailure extends Failure {}

class OperationNotAllowedFailure extends Failure {}

class PartyAlreadyExistFailure extends Failure {}

class StateAlreadyExistFailure extends Failure {}

class RepAlreadyExistFailure extends Failure {}

class TransactionFailedFailure extends Failure {
  final String message;
  TransactionFailedFailure({required this.message});
}

class StorageFailure extends Failure {}

class SocketFailure extends Failure {}

class ClientFailure extends Failure {}

class NullValueFailure extends Failure {}

class UnkownFailure extends Failure {}
