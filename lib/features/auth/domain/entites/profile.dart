import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  final String firstName;
  final String middleName;
  final String lastName;
  String? idPhoto;
  final int faydaNo;
  final String email;
  int? phoneNo;
  final int password;
  bool? isVerifid;
  bool? isActive;

  Profile({
    required this.firstName,
    required this.middleName,
    required this.lastName,
    this.idPhoto,
    required this.faydaNo,
    required this.email,
    this.phoneNo,
    required this.password,
    this.isVerifid,
    this.isActive,
  });

  @override
  List<Object?> get props =>
      [firstName, middleName, lastName, faydaNo, email, password];
}
