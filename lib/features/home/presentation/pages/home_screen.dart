import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jspm_pulse/core/constants/theme_const.dart';
import 'package:jspm_pulse/core/widgets/app_input_field.dart';
import 'package:jspm_pulse/features/auth/presentation/Bloc/auth_bloc.dart';
import 'package:jspm_pulse/features/auth/presentation/Bloc/auth_events.dart';
import 'package:jspm_pulse/features/auth/presentation/Bloc/auth_state.dart';
import 'package:jspm_pulse/features/home/presentation/pages/view_notice_screen.dart';
import 'package:jspm_pulse/features/home/presentation/widgets/bottom_sheet_cont.dart';
import 'package:jspm_pulse/features/notices/presentation/bloc/notice_bloc.dart';
import 'package:jspm_pulse/features/notices/presentation/bloc/notice_events.dart';
import 'package:jspm_pulse/features/notices/presentation/bloc/notice_states.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? userRole;
  bool roleFetched = false;

  @override
  void initState() {
    super.initState();
    // fetch current user role once
    Future.microtask(() {
      context.read<AuthBloc>().add(GetCurrentUserRoleEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        onPressed: () {
          if (userRole == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Role not loaded yet")),
            );
            return;
          }

          showModalBottomSheet(
            showDragHandle: true,
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) => BottomSheetCont(),
          );
        },
        child: const Icon(Icons.add, size: 25),
      ),

      body: SafeArea(
        child: BlocListener<AuthBloc, AuthStates>(
          listener: (context, state) {
            if (state is GetUserRoleSuccess && !roleFetched) {
              setState(() {
                userRole = state.role;
                roleFetched = true;
              });

context.read<NoticeBloc>().add(
  FetchAllNoticesStreamEvent([state.role]),
);


            } else if (state is GetUserRoleFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Failed to fetch user role: ${state.error}")),
              );
            } else if (state is AuthSignOut) {
              // Optional: Navigate to login screen after signout
              Navigator.of(context).pushReplacementNamed('/login');
            }
          },
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        context.read<AuthBloc>().add(SignOutEvent());
                      },
                      child: const Text(
                        "JSPM Pulse",
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                          fontSize: 35,
                        ),
                      ),
                    ),
                    Text(
                      "All notices at one place.",
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const AppInputField(
                      hint: "Search",
                      obscureText: false,
                      icon: Icons.search,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Expanded(
                child: BlocBuilder<NoticeBloc, NoticeStates>(
                  builder: (context, state) {
                    if (state is NoticeLoadingState) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is NoticeLoadedState) {
                      if (state.notices.isEmpty) {
                        return const Center(
                          child: Text(
                            "No notices available yet.",
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        );
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ListView.builder(
                          itemCount: state.notices.length,
                          itemBuilder: (context, index) {
                            final notice = state.notices[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ViewNoticeScreen(notice: notice),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey.shade200,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 40,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        decoration: BoxDecoration(
                                          color: Colors.deepPurpleAccent.shade100,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              notice.category ?? "Others",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Text(
                                          notice.title,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            notice.description.length > 50
                                                ? "${notice.description.substring(0, 28)}..."
                                                : notice.description,
                                            style: TextStyle(
                                              color: Colors.grey.shade500,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 10),
                                            child: Text(
                                              "${notice.createdAt?.hour ?? 0}h ago",
                                              style: TextStyle(
                                                color: Colors.grey.shade500,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    } else if (state is NoticeFailureState) {
                      return Center(child: Text(state.error));
                    }

                    return const Center(
                      child: Text("Fetching notices..."),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
