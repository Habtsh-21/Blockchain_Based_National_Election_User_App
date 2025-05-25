import 'dart:io';

import 'package:blockchain_based_national_election_user_app/core/resource/type.dart';

abstract class ContractRepository {
  ContractPartyList getParty();
  ContractStateList getState();
  ContractData vote(int faydaNo, int votedPartyId, int stateId);
  ContractAllDta getAllData(int faydaNo);
  ContractData uploadImage(File pickedFile, String fileName);
}
