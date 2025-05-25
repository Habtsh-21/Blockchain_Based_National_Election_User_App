import 'package:equatable/equatable.dart';

class StateEntity extends Equatable {
  final String stateName;
  final int stateId;

  const StateEntity({required this.stateName, required this.stateId});
  
  @override
  List<Object?> get props => [stateName,stateId];
}
