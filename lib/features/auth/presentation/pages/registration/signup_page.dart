import 'package:blockchain_based_national_election_user_app/core/widgets/gradient_button.dart';
import 'package:blockchain_based_national_election_user_app/core/widgets/textfield.dart';
import 'package:blockchain_based_national_election_user_app/features/auth/presentation/auth_provider/auth_provider.dart';
import 'package:blockchain_based_national_election_user_app/features/auth/presentation/auth_provider/provider_state.dart';
import 'package:blockchain_based_national_election_user_app/features/auth/presentation/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({
    super.key,
  });

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool isVisible = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    AuthProviderState authState = ref.watch(authStateProvider);
    if (authState is SignedUpState) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.08,
                    vertical: height * 0.06,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Column(
                          children: [
                            const Icon(
                              Icons.password_outlined,
                              size: 100,
                              color: Color.fromARGB(255, 186, 9, 153),
                            ),
                            SizedBox(height: height * 0.005),
                            const Text(
                              'Complete Your Profile',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(height: height * 0.002),
                            const Text(
                              'Please Enter Email and set 6 digit password',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        Expanded(child: Container()),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: Column(
                            children: [
                              CustomTextField(
                                controller: _emailController,
                                labelText: 'Email',
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Invalid Email';
                                  }
                                  if (!RegExp(
                                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                  ).hasMatch(value)) {
                                    return 'Invalid Email';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: height * 0.02),
                              CustomTextField(
                                controller: _passwordController,
                                labelText: 'Password',
                                obscureText: isVisible,
                                keyboardType: TextInputType.number,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    isVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isVisible = !isVisible;
                                    });
                                  },
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter valid password';
                                  }
                                  if (value.length != 6) {
                                    return 'Please enter 6 digit password';
                                  }
                                  if (int.tryParse(value) == null) {
                                    return "only Integer";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: height * 0.02),
                              CustomTextField(
                                controller: _confirmPasswordController,
                                labelText: 'Confirm Password',
                                keyboardType: TextInputType.number,
                                obscureText: isVisible,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter valid password';
                                  }
                                  if (value.length != 6) {
                                    return 'Please enter 6 digit password';
                                  }
                                  if (int.tryParse(value) == null) {
                                    return "only Integer";
                                  }
                                  if (_confirmPasswordController.text !=
                                      _passwordController.text) {
                                    return "mismatched password";
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        Expanded(child: Container()),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GradientButton(
                              text: authState is SigningUpState
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : const Text('REGISTER'),
                              onPress: () async {
                                if (_formKey.currentState!.validate()) {
                                  await ref
                                      .read(authStateProvider.notifier)
                                      .signUp(_emailController.text,
                                          _passwordController.text);
                                }
                              },
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginPage(),
                                  ),
                                );
                              },
                              child: const Text("login"),
                            ),
                            if (authState is AuthFailureState)
                              Text(authState.message),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
