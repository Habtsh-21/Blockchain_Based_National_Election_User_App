
import 'package:blockchain_based_national_election_user_app/features/smartContract/domain/entities/party_entity.dart';

class PartyModel extends PartyEntity {
  const PartyModel({
    required super.partyName,
    required super.partySymbol,
    required super.partyId,
    super.votes,
   super.stateVotes,
  });

  List<dynamic> toList() {
    return [partyName, partySymbol, BigInt.from(partyId)];
  }

  PartyModel fromList(List<dynamic> list) {
    return PartyModel(
        partyName: list[0],
        partySymbol: list[1],
        partyId: list[2],
        votes: list[3],
        stateVotes: list[4]);
  }
}
