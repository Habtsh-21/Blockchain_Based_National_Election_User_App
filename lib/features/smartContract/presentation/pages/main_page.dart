import 'package:blockchain_based_national_election_user_app/features/auth/presentation/auth_provider/auth_provider.dart';
import 'package:blockchain_based_national_election_user_app/features/smartContract/presentation/pages/home_page.dart';
import 'package:blockchain_based_national_election_user_app/features/smartContract/presentation/pages/registry.dart';
import 'package:blockchain_based_national_election_user_app/features/smartContract/presentation/pages/vote.dart';
import 'package:blockchain_based_national_election_user_app/features/smartContract/presentation/provider/provider.dart';
import 'package:blockchain_based_national_election_user_app/features/smartContract/presentation/provider/provider_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  int currentIndex = 0;
  Widget currentPage = const HomePage();
  final user = Supabase.instance.client.auth.currentUser;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(authStateProvider.notifier).fatchUserProfile(user!.id);
      final userDetail = ref.read(authStateProvider.notifier).getUserDetail();

      if (userDetail != null && userDetail.containsKey('fayda_no')) {
        await ref
            .read(contractProvider.notifier)
            .fatchAllData(userDetail['fayda_no']);
      } else {
        await ref.read(contractProvider.notifier).fatchAllData(0000);
      }
    });
  }

  List<Widget> pages = const [
    HomePage(),
    Vote(),
    Registry(),
  ];

  @override
  Widget build(BuildContext context) {
    double refWidth = 416;
    final width = MediaQuery.of(context).size.width;
    ContractProviderState contractState = ref.watch(contractProvider);

    if (contractState is ContractAllDataFatchedState) {
      return Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.add_box_sharp), label: "Vote"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.input), label: "Registry"),
            ],
            selectedItemColor: Colors.white,
            selectedFontSize: 16 * width / refWidth,
            unselectedItemColor: const Color.fromARGB(255, 167, 165, 165),
            unselectedFontSize: 14 * width / refWidth,
            selectedIconTheme: IconThemeData(
              size: 32 * width / refWidth,
              color: const Color.fromARGB(255, 255, 255, 255),
            ),
            unselectedIconTheme: IconThemeData(
                size: 30 * width / refWidth,
                color: const Color.fromARGB(255, 167, 165, 165)),
            currentIndex: currentIndex,
            backgroundColor: const Color.fromARGB(255, 153, 11, 134),
            onTap: (value) {
              setState(() {
                currentIndex = value;
              });
            },
          ),
          body: IndexedStack(
            index: currentIndex,
            children: pages,
          ));
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 97, 7, 149),
              Color.fromARGB(255, 152, 1, 114),
            ],
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.how_to_vote,
                color: Colors.white,
                size: 72,
              ),
              SizedBox(height: 24),
              Text(
                'Loading Election Data...',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 24),
              CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
