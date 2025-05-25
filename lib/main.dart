import 'package:blockchain_based_national_election_user_app/features/auth/presentation/widget/auth_gate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://zohckgmkkhkxuovbbyrz.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpvaGNrZ21ra2hreHVvdmJieXJ6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDU3ODUwOTMsImV4cCI6MjA2MTM2MTA5M30.ARr87USkmghu7v2OpBQXkuX_ZF5-u1MI2TXRSzlfKZU',
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'National Election User APP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AuthGate(),
    );
  }
}
