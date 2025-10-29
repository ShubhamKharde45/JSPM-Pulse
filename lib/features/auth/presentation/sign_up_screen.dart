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

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  String selectedRole = "Student";
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthStates>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              final userId = state.user!.id;
              context.read<AuthBloc>().add(
                AddRoleDbEvent(selectedRole, userId),
              );
            } else if (state is RoleToDBSuccess) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LogInScreen()),
              );
            } else if (state is RoleToDBFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Failed to add your role")),
              );
            }
            // else if (state is AuthFailure) {
            //   ScaffoldMessenger.of(
            //     context,
            //   ).showSnackBar(SnackBar(content: Text(state.error)));
            // }
          },

          builder: (context, state) {
            if (state is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(CupertinoIcons.shield_fill, size: 45),
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

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AppInputField(
                        hint: "Email",
                        icon: Icons.email,
                        obscureText: false,
                        controller: emailController,
                      ),
                      const SizedBox(height: 30),
                      AppInputField(
                        hint: "Password",
                        icon: Icons.lock,
                        obscureText: true,
                        controller: passController,
                      ),

                      const SizedBox(height: 30),
                      RoleDropdown(
                        onRoleSelected: (role) => setState(() {
                          selectedRole = role;
                        }),
                      ),
                      const SizedBox(height: 30),
                      AppBtn(
                        height: 70,
                        width: MediaQuery.of(context).size.width * 0.9,
                        onTap: () {
                          context.read<AuthBloc>().add(
                            SignUpEvent(
                              emailController.text,
                              passController.text,
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
                            autofocus: true,
                            focusColor: Colors.grey,
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
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
