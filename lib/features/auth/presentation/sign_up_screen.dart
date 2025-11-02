import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jspm_pulse/core/constants/theme_const.dart';
import 'package:jspm_pulse/core/widgets/app_btn.dart';
import 'package:jspm_pulse/core/widgets/app_input_field.dart';
import 'package:jspm_pulse/features/auth/presentation/Bloc/auth_bloc.dart';
import 'package:jspm_pulse/features/auth/presentation/Bloc/auth_events.dart';
import 'package:jspm_pulse/features/auth/presentation/Bloc/auth_state.dart';
import 'package:jspm_pulse/features/auth/presentation/login_screen.dart';
import 'package:jspm_pulse/features/auth/presentation/widgets/drop_down_role.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  String selectedRole = "Student";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthStates>(
          listener: (context, state) async {
            if (state is AuthSuccess) {
              final userId = state.user!.id;

              await updateUserRole(userId, selectedRole);

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Account created successfully!"),
                    backgroundColor: Colors.green,
                  ),
                );

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LogInScreen()),
                );
              }
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Icon(CupertinoIcons.shield, size: 40),
                        SizedBox(width: 8),
                        Text(
                          "JSPM Pulse",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),

                    /// 🔹 Email Field
                    AppInputField(
                      hint: "Email",
                      icon: Icons.email,
                      obscureText: false,
                      controller: emailController,
                    ),
                    const SizedBox(height: 30),

                    /// 🔹 Password Field
                    AppInputField(
                      hint: "Password",
                      icon: Icons.lock,
                      obscureText: true,
                      controller: passController,
                    ),
                    const SizedBox(height: 30),

                    /// 🔹 Role Dropdown
                    RoleDropdown(
                      onRoleSelected: (role) => setState(() {
                        selectedRole = role;
                      }),
                    ),
                    const SizedBox(height: 30),

                    /// 🔹 Create Account Button
                    AppBtn(
                      height: 70,
                      width: MediaQuery.of(context).size.width * 0.9,
                      onTap: () {
                        context.read<AuthBloc>().add(
                              SignUpEvent(
                                emailController.text.trim(),
                                passController.text.trim(),
                              ),
                            );
                      },
                      child: const Text(
                        "Create account",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    /// 🔹 Already have account
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: TextStyle(
                            color: Colors.grey.shade900,
                            fontSize: 15,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LogInScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "Login here.",
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

Future<void> updateUserRole(String userId, String role) async {
  final supabase = Supabase.instance.client;

  try {
    final response = await supabase
        .from('users')
        .update({'role': role})
        .eq('id', userId);

    debugPrint('Role updated successfully for $userId');
  } catch (e) {
    debugPrint('Error updating role: $e');
    rethrow;
  }
}
