
import 'package:blockchain_based_national_election_user_app/core/resource/type.dart';
import 'package:blockchain_based_national_election_user_app/features/smartContract/domain/repository/contract_repository.dart';

class GetPartyUsecase {
  final ContractRepository contractRepository;

  const GetPartyUsecase({required this.contractRepository});

  ContractPartyList call() {
    return contractRepository.getParty();
  }
}
