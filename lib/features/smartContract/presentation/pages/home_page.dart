import 'package:blockchain_based_national_election_user_app/features/auth/presentation/auth_provider/auth_provider.dart';
import 'package:blockchain_based_national_election_user_app/features/auth/presentation/pages/registration/user_detail.dart';
import 'package:blockchain_based_national_election_user_app/features/auth/presentation/widget/transition.dart';
import 'package:blockchain_based_national_election_user_app/features/smartContract/data/model/party_model.dart';
import 'package:blockchain_based_national_election_user_app/features/smartContract/data/model/state_model.dart';
import 'package:blockchain_based_national_election_user_app/features/smartContract/presentation/provider/provider.dart';
import 'package:blockchain_based_national_election_user_app/features/smartContract/presentation/widgets/box_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  List<PartyModel>? partyList;
  List<StateModel>? stateList;
  final user = Supabase.instance.client.auth.currentUser;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final email = user?.email;
    final userDetail = ref.read(authStateProvider.notifier).getUserDetail();
    final hashedFaydaNo = ref.read(authStateProvider.notifier).hashedFaydaNo();
    bool hasUserVoted = ref.read(contractProvider.notifier).hasUserVoted();

    int totalUser = ref.read(authStateProvider.notifier).getTotalVoter();

    //  init();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('DASHBOARD'),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  ref
                      .read(authStateProvider.notifier)
                      .fatchUserProfile(user!.id);
                  ref
                      .read(contractProvider.notifier)
                      .fatchAllData(hashedFaydaNo);
                });
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      drawer: buildDrawer(
        userDetail: userDetail,
        email: email!,
        isVerified: userDetail != null,
        onEditProfile: () {},
        onLogout: () {
          ref.read(authStateProvider.notifier).logout();
        },
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.05,
        ),
        physics: const ClampingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Hello, ${userDetail != null ? userDetail['first_name'] : email}",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        userDetail != null
                            ? Icons.verified
                            : Icons.error_outline,
                        size: 20,
                        color: userDetail != null
                            ? Colors.green
                            : Colors.redAccent,
                      )
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (userDetail != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color:
                            ref.read(contractProvider.notifier).hasUserVoted()
                                ? Colors.green.shade100
                                : Colors.red.shade100,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: hasUserVoted ? Colors.green : Colors.red,
                        ),
                      ),
                      child: Text(
                        hasUserVoted ? 'You have voted' : 'You have not voted',
                        style: TextStyle(
                          color: hasUserVoted
                              ? Colors.green.shade800
                              : Colors.red.shade800,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  const SizedBox(height: 6),
                  if (userDetail == null)
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          SlideTransition1(
                            page: const UserDetail(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.verified_user),
                      label: const Text("Complete Verification"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Overview',
              style: TextStyle(color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              padding: const EdgeInsets.all(8),
              children: [
                Box1(
                    iconData: Icons.people_sharp,
                    amount: totalUser,
                    text: 'VOTER'),
                Box1(
                    iconData: Icons.group_work_outlined,
                    amount: ref
                        .read(contractProvider.notifier)
                        .getTotalNoOfParties(),
                    text: 'PARTIES'),
                Box1(
                    iconData: Icons.countertops,
                    amount: ref
                        .read(contractProvider.notifier)
                        .getTotalNoOfStates(),
                    text: 'STATES'),
                Box1(
                    iconData: Icons.person,
                    amount: ref.read(contractProvider.notifier).getTotalVote(),
                    text: 'Total Votes'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Drawer buildDrawer({
  Map<String, dynamic>? userDetail,
  required String email,
  required bool isVerified,
  required VoidCallback onEditProfile,
  required VoidCallback onLogout,
}) {
  return Drawer(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.zero,
        bottomRight: Radius.zero,
      ),
    ),
    child: Column(
      children: [
        UserAccountsDrawerHeader(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 153, 11, 134),
          ),
          accountName: Row(
            children: [
              Text(
                isVerified ? "Verified" : "Unverified",
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(width: 6),
              Icon(
                isVerified ? Icons.verified : Icons.error_outline,
                color: isVerified ? Colors.greenAccent : Colors.redAccent,
                size: 18,
              )
            ],
          ),
          accountEmail: Text(isVerified
              ? "${userDetail!['first_name']} ${userDetail['last_name']} "
              : email),
          currentAccountPicture: const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 40, color: Colors.deepPurple),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text("Edit Profile"),
          onTap: onEditProfile,
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text("Logout"),
          onTap: onLogout,
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text("About App"),
          onTap: () {},
        ),
      ],
    ),
  );
}
