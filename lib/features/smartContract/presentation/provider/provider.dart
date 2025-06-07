import 'package:blockchain_based_national_election_user_app/core/failure/failure.dart';
import 'package:blockchain_based_national_election_user_app/core/network/network.dart';
import 'package:blockchain_based_national_election_user_app/core/string/string.dart';
import 'package:blockchain_based_national_election_user_app/features/smartContract/data/data_source/remote_contract_data_source.dart';
import 'package:blockchain_based_national_election_user_app/features/smartContract/data/model/all_data_model.dart';
import 'package:blockchain_based_national_election_user_app/features/smartContract/data/model/party_model.dart';
import 'package:blockchain_based_national_election_user_app/features/smartContract/data/model/state_model.dart';
import 'package:blockchain_based_national_election_user_app/features/smartContract/data/repo_impl/contract_repo_impl.dart';
import 'package:blockchain_based_national_election_user_app/features/smartContract/domain/repository/contract_repository.dart';
import 'package:blockchain_based_national_election_user_app/features/smartContract/domain/usecase/get_all_data_usecase.dart';
import 'package:blockchain_based_national_election_user_app/features/smartContract/domain/usecase/get_party_usecase.dart';
import 'package:blockchain_based_national_election_user_app/features/smartContract/domain/usecase/get_state_usecase.dart';
import 'package:blockchain_based_national_election_user_app/features/smartContract/domain/usecase/vote_usecase.dart';
import 'package:blockchain_based_national_election_user_app/features/smartContract/presentation/provider/provider_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

final connectionProvider = Provider<InternetConnection>(
  (ref) => InternetConnection(),
);
final networkInfoProvider = Provider<NetworkInfo>((ref) {
  final connectionChecker = ref.watch(connectionProvider);
  return NetworkInfoImpl(connectionChecker);
});

final remoteContractDataSourceProvider = Provider<RemoteContractDataSource>(
  (ref) => RemoteContractDataSourceImpl(),
);

final contractRepoProvider = Provider<ContractRepository>((ref) {
  final networkInfo = ref.watch(networkInfoProvider);
  final remoteContract = ref.watch(remoteContractDataSourceProvider);
  return ContractRepoImpl(
      networkInfo: networkInfo, remoteContractDataSource: remoteContract);
});

final voteProvider = Provider<VoteUsecase>(
  (ref) {
    final contractRepo = ref.watch(contractRepoProvider);
    return VoteUsecase(contractRepository: contractRepo);
  },
);

final getPartyProvider = Provider<GetPartyUsecase>(
  (ref) {
    final contractRepo = ref.watch(contractRepoProvider);
    return GetPartyUsecase(contractRepository: contractRepo);
  },
);
final getStateProvider = Provider<GetStateUsecase>(
  (ref) {
    final contractRepo = ref.watch(contractRepoProvider);
    return GetStateUsecase(contractRepository: contractRepo);
  },
);
final getAllDataProver = Provider<GetAllDataUsecase>(
  (ref) {
    final contractRepo = ref.watch(contractRepoProvider);
    return GetAllDataUsecase(contractRepository: contractRepo);
  },
);

class ContractNotifier extends StateNotifier<ContractProviderState> {
  final GetPartyUsecase getPartyUsecase;
  final GetStateUsecase getStateUsecase;
  final VoteUsecase voteUsecase;
  final GetAllDataUsecase getAllDataUsecase;

  ContractNotifier({
    required this.voteUsecase,
    required this.getPartyUsecase,
    required this.getStateUsecase,
    required this.getAllDataUsecase,
  }) : super(ContractInitialState());

  List<PartyModel>? partyList;
  List<StateModel>? stateList;
  int _totalVote = 0;
  bool _isVotingActive = false;
  bool _isVotingPaused = false;
  bool _hasUserVoted = false;
  int _totalNoOfParties = 0;
  int _totalNoOfStates = 0;
  DateTime? _startTime;
  DateTime? _endTime;

  // int counter = 0;

  Future<List<PartyModel>?> vote(
      String faydaNo, int votedPartyId, int stateId) async {
    state = VotingState();
    final result = await voteUsecase(faydaNo, votedPartyId, stateId);
    state = result.fold((l) {
      return VoteFailureState(message: _mapFailureToMessage(l));
    }, (r) {
      return VotedState(message: r);
    });

    Future.delayed(const Duration(seconds: 3), () => resetState());
    return partyList;
  }

  Future<List<PartyModel>?> fatchParties() async {
    state = PartyFetchingState();
    final result = await getPartyUsecase();
    state = result.fold((l) {
      return PartyFetchFailureState(message: _mapFailureToMessage(l));
    }, (r) {
      partyList = r;
      return PartyFetchedState(message: r);
    });

    Future.delayed(const Duration(seconds: 3), () => resetState());
    return partyList;
  }

  Future<List<StateModel>?> fatchStates() async {
    state = StateFetchingState();

    final result = await getStateUsecase();
    state = result.fold(
        (l) => StateFetchFailureState(message: _mapFailureToMessage(l)), (r) {
      stateList = r;
      return StateFetchedState(message: r);
    });
    Future.delayed(const Duration(seconds: 3), () => resetState());
    return stateList;
  }

  Future<AllDataModel?> fatchAllData(String faydaNo) async {
    AllDataModel? allDataModel;
    state = ContractAllDataFetchingState();
    final result = await getAllDataUsecase(faydaNo);
    state = result.fold(
        (l) => ContractAllDataFailureState(message: _mapFailureToMessage(l)),
        (r) {
      allDataModel = r;
      partyList = r.parties;
      stateList = r.states;
      _totalVote = r.totalVotes;
      _totalNoOfParties = partyList != null ? partyList!.length : 0;
      _totalNoOfStates = stateList != null ? stateList!.length : 0;
      _isVotingActive = r.isVotringActive;
      _isVotingPaused = r.votingPaused;
      _hasUserVoted = r.hasUserVoted;
      _startTime = r.votingStateTime;
      _endTime = r.votingEndTime;
      return ContractAllDataFetchedState(message: '');
    });
    return allDataModel;
  }

  List<PartyModel>? getParties() {
    return partyList;
  }

  List<StateModel>? getStates() {
    return stateList;
  }

  int getTotalNoOfParties() {
    return _totalNoOfParties;
  }

  int getTotalNoOfStates() {
    return _totalNoOfStates;
  }

  int getTotalVote() {
    return _totalVote;
  }

  bool isVotingActive() {
    return _isVotingActive;
  }

  bool isVotingPaused() {
    return _isVotingPaused;
  }

  bool hasUserVoted() {
    return _hasUserVoted;
  }

  DateTime? startTime() {
    return _startTime;
  }

  DateTime? endTime() {
    return _endTime;
  }

  void resetState() {
    state = ContractInitialState();
  }

  void setFailure(ContractProviderState contractState) {
    state = contractState;
  }
}

final contractProvider =
    StateNotifierProvider<ContractNotifier, ContractProviderState>(
  (ref) {
    final getPartyUsecase = ref.watch(getPartyProvider);
    final getStateUsecase = ref.watch(getStateProvider);
    final getAllDataUsecase = ref.watch(getAllDataProver);
    final voteUsecase = ref.watch(voteProvider);

    return ContractNotifier(
      voteUsecase: voteUsecase,
      getPartyUsecase: getPartyUsecase,
      getStateUsecase: getStateUsecase,
      getAllDataUsecase: getAllDataUsecase,
    );
  },
);

String _mapFailureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case const (OfflineFailure):
      return OFFLINE_FAILURE_MESSAGE;
    case const (PartyAlreadyExistFailure):
      return PARTY_ALREADY_EXIST;
    case const (StateAlreadyExistFailure):
      return STATE_ALREADY_EXIST;
    case const (RepAlreadyExistFailure):
      return REP_ALREADY_EXIST;
    case const (TransactionFailedFailure):
      return (failure as TransactionFailedFailure).message;
    case const (SocketFailure):
      return SOCKET_FAILED;
    case const (StorageFailure):
      return STORAGE_MESSAGE;
    case const (ClientFailure):
      return CLIENT_FAILED;
    case const (NullValueFailure):
      return NULL_VALUE;
    case const (UnkownFailure):
      return UNKOWN_PROBLEM;
    default:
      return "Unexpected Error , Please try again later .";
  }
}
