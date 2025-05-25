import 'package:blockchain_based_national_election_user_app/core/widgets/gradient_button.dart';
import 'package:blockchain_based_national_election_user_app/core/widgets/textfield.dart';
import 'package:blockchain_based_national_election_user_app/features/auth/presentation/auth_provider/auth_provider.dart';
import 'package:blockchain_based_national_election_user_app/features/auth/presentation/auth_provider/provider_state.dart';
import 'package:blockchain_based_national_election_user_app/features/auth/presentation/pages/registration/signup_page.dart';
import 'package:blockchain_based_national_election_user_app/features/auth/presentation/widget/auth_gate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isIdVisible = false;
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    AuthProviderState authState = ref.watch(authStateProvider);

    if (authState is LoggedInState) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AuthGate()),
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
                              Icons.login_outlined,
                              size: 100,
                              color: Color.fromARGB(255, 186, 9, 153),
                            ),
                            SizedBox(height: height * 0.005),
                            const Text(
                              'Login',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(height: height * 0.002),
                            const Text(
                              'Please your Information',
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
                                keyboardType: TextInputType.number,
                                obscureText: isPasswordVisible,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isPasswordVisible = !isPasswordVisible;
                                    });
                                  },
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter valid password';
                                  }
                                  if (int.tryParse(value) == null) {
                                    return "only Integer";
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
                              text: authState is LogingInState
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : const Text('LOGIN'),
                              onPress: () {
                                if (_formKey.currentState!.validate()) {
                                  ref.read(authStateProvider.notifier).login(
                                      _emailController.text,
                                      _passwordController.text);
                                }
                              },
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignUpPage(),
                                  ),
                                );
                              },
                              child: const Text("REGISTER?"),
                            ),
                            SizedBox(height: height * 0.02),
                            if (authState is LoggedInState)
                              const Text('Verified successfully'),
                            if (authState is AuthFailureState)
                              Text(authState.message)
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
