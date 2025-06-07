import 'package:blockchain_based_national_election_user_app/features/smartContract/data/model/party_model.dart';
import 'package:blockchain_based_national_election_user_app/features/smartContract/data/model/state_model.dart';

class AllDataModel {
  List<PartyModel> parties;
  List<StateModel> states;
  int totalVotes;
  bool votingPaused;
  bool isVotringActive;
  bool hasUserVoted;
  DateTime? votingStateTime;
  DateTime? votingEndTime;

  AllDataModel(
      {required this.parties,
      required this.states,
      required this.totalVotes,
      required this.votingPaused,
      required this.isVotringActive,
      required this.hasUserVoted,
      required this.votingStateTime,
      required this.votingEndTime});
}
