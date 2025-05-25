
import 'package:blockchain_based_national_election_user_app/features/smartContract/domain/entities/state_entity.dart';

class StateModel extends StateEntity {
  const StateModel({required super.stateName, required super.stateId});
  List<dynamic> toList() {
    return [stateName, BigInt.from(stateId)];
  }

  StateModel fromList(List<dynamic> list) {
    return StateModel(stateName: list[0], stateId: list[1]);
  }
}
