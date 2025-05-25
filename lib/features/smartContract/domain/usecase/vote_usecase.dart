import 'package:blockchain_based_national_election_user_app/core/resource/type.dart';
import 'package:blockchain_based_national_election_user_app/features/smartContract/domain/repository/contract_repository.dart';

class VoteUsecase {
  ContractRepository contractRepository;

  VoteUsecase({required this.contractRepository});

  ContractData call(int faydaNo, int votedPartyId, int stateId) {
    return contractRepository.vote(faydaNo, votedPartyId, stateId);
  }
}
