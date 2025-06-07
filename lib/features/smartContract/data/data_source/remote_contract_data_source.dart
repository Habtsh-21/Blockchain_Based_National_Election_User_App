import 'dart:convert';
import 'dart:io';

import 'package:blockchain_based_national_election_user_app/core/exception/exception.dart';
import 'package:blockchain_based_national_election_user_app/features/smartContract/data/model/all_data_model.dart';
import 'package:blockchain_based_national_election_user_app/features/smartContract/data/model/party_model.dart';
import 'package:blockchain_based_national_election_user_app/features/smartContract/data/model/state_model.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

const String _rpcUrl =
    'https://eth-sepolia.g.alchemy.com/v2/-ojPUotrULaRUfZmH3MRZTFQ7OH1wB22';
const String _wsUrl =
    'ws://eth-sepolia.g.alchemy.com/v2/-ojPUotrULaRUfZmH3MRZTFQ7OH1wB22';
const String contractAddress = "0x5bF77EcF1559b7b0A3b0E5B8Fbb900D336526010";
const String PRIVATE_KEY =
    "4398d3ac1be44cbc929ee7bf64d203d9f4f2e3f6763911ee8d58fdbddca02883";

abstract class RemoteContractDataSource {
  Future<String> vote(String faydaNo, int votedPartyId, int stateId);
  Future<List<PartyModel>> getParties();
  Future<List<StateModel>> getState();
  Future<String> uploadImage(File pickedFile, String fileName);
  Future<AllDataModel> getAllData(String faydaNo);
}

class RemoteContractDataSourceImpl extends RemoteContractDataSource {
  final supabase = Supabase.instance.client;
  final user = Supabase.instance.client.auth.currentUser;

  late Web3Client _client;
  late DeployedContract _contract;
  late ContractFunction _getParties;
  late ContractFunction _getStates;
  late ContractFunction _vote;
  late ContractFunction _getAllData;
  late EthereumAddress _contractAddress;
  late ContractAbi _contractAbi;
  late Credentials _credentials;

  Future<void> init() async {
    _client = Web3Client(
      _rpcUrl,
      Client(),
      socketConnector: () {
        return IOWebSocketChannel.connect(_wsUrl).cast<String>();
      },
    );

    _credentials = EthPrivateKey.fromHex(PRIVATE_KEY);
    String abiString = await rootBundle.loadString('assets/file/json/abi.json');
    Map<String, dynamic> jsondecoded = jsonDecode(abiString);

    final abiJson = jsondecoded['abi'] as List<dynamic>;

    _contractAbi = ContractAbi.fromJson(jsonEncode(abiJson), 'Voting');

    _contractAddress = EthereumAddress.fromHex(contractAddress);

    _contract = DeployedContract(
      _contractAbi,
      _contractAddress,
    );
  }

  @override
  Future<String> vote(String faydaNo, int votedPartyId, int stateId) async {
    try {
      print(faydaNo);
      print(votedPartyId);
      print(stateId);
      await init();

      _vote = _contract.function('vote');
      final transactionHash = await _client.sendTransaction(
          _credentials,
          Transaction.callContract(
            contract: _contract,
            function: _vote,
            parameters: [
              faydaNo,
              BigInt.from(stateId),
              BigInt.from(votedPartyId),
            ],
          ),
          chainId: 11155111);
      print(3);
      print('transaction hash --- $transactionHash');
      return transactionHash;
    } catch (e) {
      print(e.toString());
      throw TransactionFailedException(message: e.toString());
    }
  }

  @override
  Future<List<PartyModel>> getParties() async {
    try {
      print(1);
      await init();
      print(2);
      _getParties = _contract.function('getAllParties');
      final result = await _client.call(
        contract: _contract,
        function: _getParties,
        params: [],
      );

      final rawList = result[0] as List;
      Map<int, int> stateVotes = {};
      final partyList = rawList.map((party) {
        List<List<int>> stateVoteList = (party[4] as List)
            .map(
              (e) => [
                int.parse(e[0].toString()),
                int.parse(e[1].toString()),
              ],
            )
            .toList();
        for (List<int> state in stateVoteList) {
          stateVotes[state[0]] = state[1];
        }
        return PartyModel(
          partyName: party[0] as String,
          partySymbol: party[1] as String,
          partyId: int.parse(party[2].toString()),
          votes: int.parse(party[3].toString()),
          stateVotes: stateVotes,
        );
      }).toList();
      return partyList;
    } catch (e) {
      print('party error:   ${e.toString()}');
      throw TransactionFailedException(message: e.toString());
    }
  }

  @override
  Future<List<StateModel>> getState() async {
    try {
      await init();

      _getStates = _contract.function('statesList');
      final result = await _client.call(
        contract: _contract,
        function: _getStates,
        params: [],
      );
      final rawList = result[0] as List;

      final stateList = rawList.map((state) {
        return StateModel(
          stateName: state[0] as String,
          stateId: int.parse(state[1].toString()),
        );
      }).toList();

      return stateList;
    } catch (e) {
      print('state error:   ${e.toString()}');
      throw TransactionFailedException(message: e.toString());
    }
  }

  @override
  Future<AllDataModel> getAllData(String faydaNo) async {
    try {
      await init();

      _getAllData = _contract.function('getAllData');
      final result = await _client.call(
        contract: _contract,
        function: _getAllData,
        params: [faydaNo],
      );
      int totalVotes = 0;
      print(result);
      // Decode each item from result
      final rawStates = result[0] as List;
      final rawParties = result[1] as List;
      final votingPaused = result[2] as bool;
      final votingActive = result[3] as bool;
      final hasUserVoted = result[4] as bool;
      final start = int.parse(result[5].toString());
      final end = int.parse(result[6].toString());
      DateTime? startTime;
      DateTime? endTime;

      if (start != 0 && end != 0) {
        startTime = DateTime.fromMillisecondsSinceEpoch(start * 1000);
        endTime = DateTime.fromMillisecondsSinceEpoch(end * 1000);
      }

      final stateList = rawStates.map((state) {
        return StateModel(
          stateName: state[0] as String,
          stateId: int.parse(state[1].toString()),
        );
      }).toList();

      final partyList = rawParties.map((party) {
        int totalPartyVote = 0;
        Map<int, int> stateVotes = {};
        List<List<int>> stateVoteList = (party[3] as List)
            .map((e) => [
                  int.parse(e[0].toString()),
                  int.parse(e[1].toString()),
                ])
            .toList();

        for (List<int> state in stateVoteList) {
          stateVotes[state[0]] = state[1];
          totalPartyVote += state[1];
          totalVotes += state[1];
        }

        return PartyModel(
          partyName: party[0] as String,
          partySymbol: party[1] as String,
          partyId: int.parse(party[2].toString()),
          votes: totalPartyVote,
          stateVotes: stateVotes,
        );
      }).toList();

      return AllDataModel(
        parties: partyList,
        states: stateList,
        totalVotes: totalVotes,
        votingPaused: votingPaused,
        isVotringActive: votingActive,
        hasUserVoted: hasUserVoted,
        votingStateTime: startTime,
        votingEndTime: endTime,
      );
    } catch (e) {
      print(e.toString());
      throw TransactionFailedException(message: e.toString());
    }
  }

  @override
  Future<String> uploadImage(pickedFile, String fileName) async {
    try {
      final storage = Supabase.instance.client.storage;
      final bucket = storage.from('main');

      await bucket.upload(
        fileName,
        pickedFile,
        fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
      );

      final publicUrl = bucket.getPublicUrl(fileName);

      if (publicUrl.isEmpty) {
        throw NullPublicUrlException();
      }
      final response = await http.head(Uri.parse(publicUrl));
      if (response.statusCode != 200) {
        throw Exception('Uploaded file not accessible at $publicUrl');
      }

      print("Upload successful. URL: $publicUrl");
      return publicUrl;
    } on StorageException catch (e) {
      print("Supabase StorageException: ${e.message}");
      throw StorageException("Upload failed: ${e.message}");
    } on ClientException catch (e) {
      print("Supabase ClientException: ${e.message}");
      throw ClientException("Upload failed: ${e.message}");
    } on SocketException catch (e) {
      print("Supabase SocketException: ${e.message}");
      throw SocketException("Network issue: ${e.message}");
    } on NullPublicUrlException catch (e) {
      print(e);
      rethrow;
    } catch (e) {
      print("Unknown error during upload: $e");
      throw UnknownException();
    }
  }
}
