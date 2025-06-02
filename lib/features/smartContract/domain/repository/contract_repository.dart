import 'dart:io';

import 'package:blockchain_based_national_election_user_app/core/resource/type.dart';

abstract class ContractRepository {
  ContractPartyList getParty();
  ContractStateList getState();
  ContractData vote(String faydaNo, int votedPartyId, int stateId);
  ContractAllDta getAllData(String faydaNo);
  ContractData uploadImage(File pickedFile, String fileName);
}
