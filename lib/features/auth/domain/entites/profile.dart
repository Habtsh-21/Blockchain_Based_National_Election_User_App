import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  final String userId;
  final String firstName;
  final String lastName;
  final int faydaNo;

  final int stateId;

  Profile({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.faydaNo,
    required this.stateId,
  });

  @override
  List<Object?> get props => [userId, faydaNo];
}
