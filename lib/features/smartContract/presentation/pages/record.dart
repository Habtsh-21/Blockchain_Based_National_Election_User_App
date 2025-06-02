import 'package:blockchain_based_national_election_user_app/features/auth/presentation/auth_provider/auth_provider.dart';
import 'package:blockchain_based_national_election_user_app/features/smartContract/presentation/provider/provider.dart';
import 'package:blockchain_based_national_election_user_app/features/smartContract/presentation/widgets/party_page.dart';
import 'package:blockchain_based_national_election_user_app/features/smartContract/presentation/widgets/state_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Record extends ConsumerStatefulWidget {
  const Record({super.key});

  @override
  ConsumerState<Record> createState() => _RegistryState();
}

class _RegistryState extends ConsumerState<Record> {
  @override
  Widget build(BuildContext context) {
    final userDetail = ref.read(authStateProvider.notifier).getUserDetail();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Record"),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    ref.read(contractProvider.notifier).fatchAllData(
                        userDetail != null ? userDetail['fayda_no'] : 0000);
                  });
                },
                icon: const Icon(Icons.refresh))
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: "PartyList"),
              Tab(text: "StateList"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [PartyPage(), StatePage()],
        ),
      ),
    );
  }
}
