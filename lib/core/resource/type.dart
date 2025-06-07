import 'package:blockchain_based_national_election_user_app/core/failure/failure.dart';
import 'package:blockchain_based_national_election_user_app/features/auth/data/auth_model/data.dart';
import 'package:blockchain_based_national_election_user_app/features/smartContract/data/model/all_data_model.dart';
import 'package:blockchain_based_national_election_user_app/features/smartContract/data/model/party_model.dart';
import 'package:blockchain_based_national_election_user_app/features/smartContract/data/model/state_model.dart';
import 'package:dartz/dartz.dart';

typedef UserData = Future<Either<Failure, Data>>;
typedef UserUnit = Future<Either<Failure, Unit>>;
typedef ContractData = Future<Either<Failure, String>>;
typedef ContractPartyList = Future<Either<Failure, List<PartyModel>>>;
typedef ContractStateList = Future<Either<Failure, List<StateModel>>>;
typedef ContractAllData = Future<Either<Failure, AllDataModel>>;
