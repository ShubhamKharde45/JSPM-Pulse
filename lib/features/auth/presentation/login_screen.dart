import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jspm_pulse/core/constants/theme_const.dart';
import 'package:jspm_pulse/core/widgets/app_btn.dart';
import 'package:jspm_pulse/core/widgets/app_input_field.dart';
import 'package:jspm_pulse/features/auth/presentation/Bloc/auth_bloc.dart';
import 'package:jspm_pulse/features/auth/presentation/Bloc/auth_events.dart';
import 'package:jspm_pulse/features/auth/presentation/Bloc/auth_state.dart';
import 'package:jspm_pulse/features/auth/presentation/sign_up_screen.dart';
import 'package:jspm_pulse/features/home/presentation/pages/home_screen.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthStates>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                (route) => false,
              );
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return Stack(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(CupertinoIcons.shield_fill, size: 45),
                          const SizedBox(width: 5),
                          const Text(
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
                          "LogIn",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 45,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 60),
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
                      AppBtn(
                        height: 70,
                        width: MediaQuery.of(context).size.width * 0.9,
                        onTap: isLoading
                            ? null
                            : () {
                                context.read<AuthBloc>().add(
                                      LogInEvent(
                                        emailController.text,
                                        passController.text,
                                      ),
                                    );
                              },
                        child: Text(
                          isLoading ? "Logging In..." : "Log In",
                          style: const TextStyle(
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
                            "Don't have an account? ",
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
                                  builder: (context) => const SignUpScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              "Create here.",
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
                if (isLoading)
                  Container(
                    color: Colors.black26,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
