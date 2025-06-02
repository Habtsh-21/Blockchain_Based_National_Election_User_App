
import 'package:blockchain_based_national_election_user_app/core/resource/type.dart';
import 'package:blockchain_based_national_election_user_app/features/smartContract/domain/repository/contract_repository.dart';

class GetAllDataUsecase {
  final ContractRepository contractRepository;

  const GetAllDataUsecase({required this.contractRepository});

  ContractAllDta call(String faydaNo) {
    return contractRepository.getAllData(faydaNo);
  }
}
