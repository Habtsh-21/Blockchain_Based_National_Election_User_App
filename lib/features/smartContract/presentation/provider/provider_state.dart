
import 'package:blockchain_based_national_election_user_app/features/smartContract/data/model/party_model.dart';
import 'package:blockchain_based_national_election_user_app/features/smartContract/data/model/state_model.dart';
import 'package:equatable/equatable.dart';

abstract class ContractProviderState extends Equatable {
  @override
  List<Object?> get props => [];
}

// === Base Success & Failure States ===

abstract class SuccessState<T> extends ContractProviderState {
  final T message;
  SuccessState({required this.message});

  @override
  List<Object?> get props => [message];
}

abstract class FailureState<T> extends ContractProviderState {
  final T message;
  FailureState({required this.message});

  @override
  List<Object?> get props => [message];
}

// === Initial State ===

class ContractInitialState extends ContractProviderState {}

// === All Data States ===

class ContractAllDataFetchingState extends ContractProviderState {}

class ContractAllDataFetchedState extends SuccessState<String> {
  ContractAllDataFetchedState({required super.message});
}

class ContractAllDataFailureState extends FailureState<String> {
  ContractAllDataFailureState({required super.message});
}



class PartyFetchingState extends ContractProviderState {}

class PartyFetchedState extends SuccessState<List<PartyModel>> {
  PartyFetchedState({required super.message});
}

class PartyFetchFailureState extends FailureState<String> {
  PartyFetchFailureState({required super.message});
}

class StateFetchingState extends ContractProviderState {}

class StateFetchedState extends SuccessState<List<StateModel>> {
  StateFetchedState({required super.message});
}

class StateFetchFailureState extends FailureState<String> {
  StateFetchFailureState({required super.message});
}

class VotingState extends ContractProviderState{}

class VotedState extends  SuccessState<String>{
  VotedState({required super.message});
}

class VoteFailureState extends FailureState<String>{
  VoteFailureState({required super.message});
  
}




// === Generic Fallback States

// class ContractSuccessState extends SuccessState<String> {
//   ContractSuccessState({required super.message});
// }

// class ContractFailureState extends FailureState<String> {
//   ContractFailureState({required super.message});
// }
