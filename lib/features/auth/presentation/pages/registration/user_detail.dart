import 'package:blockchain_based_national_election_user_app/core/widgets/gradient_button.dart';
import 'package:blockchain_based_national_election_user_app/core/widgets/textfield.dart';
import 'package:blockchain_based_national_election_user_app/features/auth/presentation/auth_provider/auth_provider.dart';
import 'package:blockchain_based_national_election_user_app/features/auth/presentation/auth_provider/provider_state.dart';
import 'package:blockchain_based_national_election_user_app/features/smartContract/presentation/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserDetail extends ConsumerStatefulWidget {
  const UserDetail({
    super.key,
  });

  @override
  ConsumerState<UserDetail> createState() => _FirstPageState();
}

class _FirstPageState extends ConsumerState<UserDetail> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _idNoController = TextEditingController();
  final user = Supabase.instance.client.auth.currentUser;
  String? selectedState;
  bool isVisible = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _idNoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final authState = ref.watch(authStateProvider);
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
                              Icons.person_2_outlined,
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
                              'Please provide your details to continue',
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
                                controller: _firstNameController,
                                labelText: 'First Name',
                                keyboardType: TextInputType.name,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter valid name';
                                  }
                                  if (!RegExp(
                                    r"^[a-zA-Z]+(?:[-' ][a-zA-Z]+)*$",
                                  ).hasMatch(value)) {
                                    return 'Invalid character';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: height * 0.02),
                              CustomTextField(
                                controller: _lastNameController,
                                labelText: 'Last Name',
                                keyboardType: TextInputType.name,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter valid name';
                                  }
                                  if (!RegExp(
                                    r"^[a-zA-Z]+(?:[-' ][a-zA-Z]+)*$",
                                  ).hasMatch(value)) {
                                    return 'Invalid character';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: height * 0.02),
                              CustomTextField(
                                controller: _idNoController,
                                labelText: 'Fayda No',
                                keyboardType: TextInputType.number,
                                obscureText: isVisible,
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
                                    return 'Please enter valid Phone No';
                                  }
                                  if (int.tryParse(value) == null) {
                                    return "only Integer";
                                  }
                                  if (value.length != 10) {
                                    return 'Enter 10 digit';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: height * 0.02),
                              DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                  labelText: 'Select Region',
                                  border: OutlineInputBorder(),
                                ),
                                value: selectedState,
                                items: ref
                                    .read(contractProvider.notifier)
                                    .getStates()!
                                    .map((state) {
                                  return DropdownMenuItem<String>(
                                    value: state.stateId.toString(),
                                    child: Text(state.stateName),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedState = value;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select a region';
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
                              text: authState is UserDetailUploadingState
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : const Text('Verify'),
                              onPress: () {
                                if (_formKey.currentState!.validate()) {
                                  if (selectedState == null) return;
                                  int? selectedStateId =
                                      int.tryParse(selectedState!);
                                  int? faydaNo =
                                      int.tryParse(_idNoController.text);
                                  if (selectedStateId != null &&
                                      user != null &&
                                      faydaNo != null) {
                                    ref
                                        .read(authStateProvider.notifier)
                                        .userDetail(
                                            user!.id,
                                            _firstNameController.text,
                                            _lastNameController.text,
                                            faydaNo,
                                            selectedStateId);
                                  }
                                }
                              },
                            ),
                            SizedBox(height: height * 0.02),
                            if (authState is UserDetailUploadedState)
                              const Text('Verified successfully'),
                            if (authState is UserDetailUploadFailureState)
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
