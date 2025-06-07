import 'dart:io';
import 'package:blockchain_based_national_election_user_app/core/exception/exception.dart';
import 'package:blockchain_based_national_election_user_app/core/failure/failure.dart';
import 'package:blockchain_based_national_election_user_app/core/network/network.dart';
import 'package:blockchain_based_national_election_user_app/core/resource/type.dart';
import 'package:blockchain_based_national_election_user_app/features/smartContract/data/data_source/remote_contract_data_source.dart';
import 'package:blockchain_based_national_election_user_app/features/smartContract/domain/repository/contract_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ContractRepoImpl extends ContractRepository {
  final NetworkInfo networkInfo;
  final RemoteContractDataSource remoteContractDataSource;

  ContractRepoImpl(
      {required this.networkInfo, required this.remoteContractDataSource});
  @override
  ContractData vote(String faydaNo, int votedPartyId, int stateId) async {
    if (await networkInfo.isConnected) {
      try {
        final txHash =
            await remoteContractDataSource.vote(faydaNo, votedPartyId, stateId);
        return Right(txHash);
      } catch (e) {
        if (e is TransactionFailedException) {
          return Left(TransactionFailedFailure(message: e.message));
        } else {
          return Left(UnkownFailure());
        }
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  ContractPartyList getParty() async {
    if (await networkInfo.isConnected) {
      try {
        final list = await remoteContractDataSource.getParties();
        return Right(list);
      } catch (e) {
        if (e is TransactionFailedException) {
          return Left(TransactionFailedFailure(message: e.message));
        } else {
          return Left(UnkownFailure());
        }
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  ContractStateList getState() async {
    if (await networkInfo.isConnected) {
      try {
        final list = await remoteContractDataSource.getState();
        return Right(list);
      } catch (e) {
        if (e is TransactionFailedException) {
          return Left(TransactionFailedFailure(message: e.message));
        } else {
          return Left(UnkownFailure());
        }
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  ContractAllData getAllData(String faydaNo,
      {int attempt = 1, int atm = 1}) async {
    const maxAttempts = 10;

    if (await networkInfo.isConnected) {
      try {
        final data = await remoteContractDataSource.getAllData(faydaNo);
        return Right(data);
      } catch (e) {
        if (e is TransactionFailedException) {
          if (atm < 3) {
            await Future.delayed(const Duration(seconds: 3));
            return await getAllData(faydaNo,
                attempt: attempt + 1, atm: atm + 1);
          } else {
            return Left(TransactionFailedFailure(message: e.message));
          }
        } else {
          if (atm < 3) {
            await Future.delayed(const Duration(seconds: 3));
            return await getAllData(faydaNo,
                attempt: attempt + 1, atm: atm + 1);
          } else {
            return Left(UnkownFailure());
          }
        }
      }
    } else {
      if (attempt < maxAttempts) {
        await Future.delayed(const Duration(seconds: 3));
        return await getAllData(faydaNo, attempt: attempt + 1, atm: atm + 1);
      } else {
        return Left(OfflineFailure());
      }
    }
  }

  @override
  ContractData uploadImage(File pickedFile, String fileName) async {
    if (await networkInfo.isConnected) {
      try {
        final fileUrl =
            await remoteContractDataSource.uploadImage(pickedFile, fileName);
        return Right(fileUrl);
      } on StorageException {
        return Left(StorageFailure());
      } on SocketException {
        return Left(SocketFailure());
      } on ClientException {
        return Left(ClientFailure());
      } on NullPublicUrlException {
        return Left(NullValueFailure());
      } on UnknownException {
        return Left(UnkownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
