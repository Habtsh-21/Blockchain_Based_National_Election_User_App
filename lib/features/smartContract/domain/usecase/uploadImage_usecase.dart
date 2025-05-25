import 'dart:io';

import 'package:blockchain_based_national_election_user_app/core/resource/type.dart';
import 'package:blockchain_based_national_election_user_app/features/smartContract/domain/repository/contract_repository.dart';

class UploadimageUsecase {
  final ContractRepository contractRepository;

  const UploadimageUsecase({required this.contractRepository});

  ContractData call(File pickedFile, String fileName) {
    return contractRepository.uploadImage(pickedFile, fileName);
  }
}
