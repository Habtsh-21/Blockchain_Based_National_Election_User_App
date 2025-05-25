import 'package:blockchain_based_national_election_user_app/core/widgets/gradient_button.dart';
import 'package:blockchain_based_national_election_user_app/features/auth/presentation/pages/login.dart';
import 'package:blockchain_based_national_election_user_app/features/auth/presentation/pages/registration/signup_page.dart';
import 'package:flutter/material.dart';

class Intro extends StatefulWidget {
  const Intro({super.key});

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.1,
          vertical: height * 0.1,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: Container()),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: width * 0.48,
                  height: height * 0.22,
                  fit: BoxFit.contain,
                ),
                const Text(
                  'Federal Election Commission',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Transparent,Reliable and Secure Election \non Ethereum Blockchain',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            Expanded(child: Container()),
            Column(
              children: [
                GradientButton(
                  text: const Text("REGISTRATION"),
                  onPress: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUpPage()),
                  ),
                ),
                SizedBox(height: height * 0.008),
                SizedBox(
                  width: double.infinity,
                  height: height * 0.055,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(0),
                      shape: const RoundedRectangleBorder(
                        side: BorderSide(
                          color: Color.fromARGB(255, 119, 26, 185),
                          width: 2,
                        ),
                      ),
                      elevation: 2,
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    ),
                    child: const Text(
                      'LOGIN',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 119, 26, 185),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
