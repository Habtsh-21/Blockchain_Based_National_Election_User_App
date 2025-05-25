import 'package:blockchain_based_national_election_user_app/features/auth/presentation/pages/login.dart';
import 'package:blockchain_based_national_election_user_app/features/smartContract/presentation/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
        final session = snapshot.hasData ? snapshot.data!.session : null;

        if (session == null) {
          return const LoginPage();
        } else {
          return  const MainPage();
        }
      },
    );
  }
}
