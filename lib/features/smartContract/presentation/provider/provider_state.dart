import 'package:blockchain_based_national_election_user_app/features/smartContract/data/model/party_model.dart';
import 'package:blockchain_based_national_election_user_app/features/smartContract/data/model/state_model.dart';
import 'package:equatable/equatable.dart';

abstract class ContractProviderState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ContractInitialState extends ContractProviderState {}

class VotingState extends ContractProviderState {}

class VotedState extends ContractProviderState {
  final String txHash;
  VotedState({ required this.txHash});
}

class ContractAllDataFatchingState extends ContractProviderState {}

class ContractAllDataFatchedState extends ContractProviderState {}

class PartyFetchingState extends ContractProviderState {}

class PartyFetchedState extends ContractProviderState {
  final List<PartyModel> partiesList;
  PartyFetchedState({required this.partiesList});
}

class StateFetchingState extends ContractProviderState {}

class StateFetchedState extends ContractProviderState {
  final List<StateModel> stateList;
  StateFetchedState({required this.stateList});
}

class FileUpoadingState extends ContractProviderState {}

class FileUpoadedState extends ContractProviderState {}

class ContractSuccessState extends ContractProviderState {}

class ContractFailureState extends ContractProviderState {
  final String message;
  ContractFailureState({required this.message});
}
