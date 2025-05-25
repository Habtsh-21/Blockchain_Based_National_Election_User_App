import 'package:equatable/equatable.dart';

class PartyEntity extends Equatable {
  final String partyName;
  final String partySymbol;
  final int partyId;
  final int votes;
  final Map<int, int> stateVotes;
  const PartyEntity({
    required this.partyName,
    required this.partySymbol,
    required this.partyId,
    this.votes = 0,
    this.stateVotes = const {},
  });

  @override
  List<Object?> get props => [partyName, partyId];
}
