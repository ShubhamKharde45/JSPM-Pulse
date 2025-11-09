import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jspm_pulse/core/constants/theme_const.dart';
import 'package:jspm_pulse/core/service_locators/service_locator.dart';
import 'package:jspm_pulse/core/widgets/app_input_field.dart';
import 'package:jspm_pulse/features/home/presentation/pages/view_notice_screen.dart';
import 'package:jspm_pulse/features/home/presentation/widgets/bottom_sheet_cont.dart';
import 'package:jspm_pulse/features/notices/presentation/bloc/notice_bloc.dart';
import 'package:jspm_pulse/features/notices/presentation/bloc/notice_events.dart';
import 'package:jspm_pulse/features/notices/presentation/bloc/notice_states.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? userRole;
  bool roleFetched = false;
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await getCurrentUserRole();
    if (userRole != null && mounted) {
      context.read<NoticeBloc>().add(FetchAllNoticesStreamEvent([userRole!]));
    }
  }

  Future<void> getCurrentUserRole() async {
    try {
      final client = getIt<SupabaseClient>();
      final user = client.auth.currentUser;

      if (user == null) {
        debugPrint("No user logged in");
        if (!mounted) return;
        setState(() {
          userRole = "guest";
          roleFetched = true;
        });
        return;
      }

      final data = await client
          .from('users')
          .select('role')
          .eq('id', user.id)
          .maybeSingle();

      if (!mounted) return;
      setState(() {
        userRole = data?['role'] as String?;
        roleFetched = true;
      });
    } catch (e) {
      debugPrint("Error fetching user role: $e");
      if (!mounted) return;
      setState(() {
        userRole = null;
        roleFetched = true;
      });
    }
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
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "JSPM Pulse",
                    style: TextStyle(
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
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
                  AppInputField(
                    controller: _searchController,
                    hint: "Search",
                    obscureText: false,
                    icon: Icons.search,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.toLowerCase();
                      });
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<NoticeBloc, NoticeStates>(
                builder: (context, state) {
                  if (state is NoticeLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is NoticeLoadedState) {
                    var filteredNotices = state.notices.where((notice) {
                      final query = _searchQuery.toLowerCase();
                      return notice.title.toLowerCase().contains(query) ||
                          notice.description.toLowerCase().contains(query) ||
                          (notice.category?.toLowerCase().contains(query) ??
                              false);
                    }).toList();

                    if (filteredNotices.isEmpty) {
                      return const Center(
                        child: Text(
                          "No notices found.",
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ListView.builder(
                        itemCount: filteredNotices.length,
                        itemBuilder: (context, index) {
                          final notice = filteredNotices[index];
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
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 40,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
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
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Text(
                                            timeago.format(
                                              notice.createdAt?.toLocal() ??
                                                  DateTime.now(),
                                            ),
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

                  return const Center(child: Text("Fetching notices..."));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
