

import 'package:blockchain_based_national_election_user_app/core/failure/failure.dart';
import 'package:dartz/dartz.dart';

typedef UserData = Future<Either<Failure, Map<dynamic,dynamic>>>;
typedef UserUnit = Future<Either<Failure, Unit>>;
// typedef ContractData = Future<Either<Failure, String>>;
// typedef ContractPartyList = Future<Either<Failure, List<PartyModel>>>;
// typedef ContractStateList = Future<Either<Failure, List<StateModel>>>;
// typedef ContractAllDta = Future<Either<Failure, AllDataModel>>;
