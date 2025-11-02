import 'package:flutter/material.dart';
import 'package:jspm_pulse/core/errors/server_errors.dart';
import 'package:jspm_pulse/core/service_locators/service_locator.dart';
import 'package:jspm_pulse/core/widgets/app_btn.dart';
import 'package:jspm_pulse/features/profile/data/models/profile_model.dart';
import 'package:jspm_pulse/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:jspm_pulse/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Profile? profile;
  bool isLoading = true;
  String? errorMessage;

  Future<void> fetchProfileDirectly() async {
    final getProfileUseCase = getIt<GetProfileUseCase>();
    final supabase = getIt<SupabaseClient>();
    final userId = supabase.auth.currentUser!.id;

    final result = await getProfileUseCase.call(userId);

    if (result is ServerSuccess<Profile>) {
      setState(() {
        profile = result.data;
        isLoading = false;
      });
    } else if (result is ServerFailure) {
      setState(() {
        errorMessage = result.message;
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProfileDirectly();
  }

  Future<void> updateProfile(Profile updatedProfile) async {
    final updateProfileUseCase = getIt<UpdateProfileUseCase>();

    setState(() => isLoading = true);

    final result = await updateProfileUseCase.call(updatedProfile);

    if (result is ServerSuccess) {
      setState(() {
        profile = updatedProfile;
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Profile updated successfully!")),
      );
    } else if (result is ServerFailure) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Failed: ${result.message}")),
      );
    }
  }

  void showEditDialog(Profile current) {
    final nameCtrl = TextEditingController(text: current.name ?? '');
    final deptCtrl = TextEditingController(text: current.department ?? '');
    final yearCtrl = TextEditingController(
      text: current.year?.toString() ?? '',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Edit Profile",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: deptCtrl,
              decoration: const InputDecoration(labelText: "Department"),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: yearCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Year"),
            ),
            const SizedBox(height: 16),
            AppBtn(
              height: 40,
              width: MediaQuery.of(context).size.width * 0.7,
              onTap: () {
                final updated = Profile(
                  id: current.id,
                  role: current.role,
                  createdAt: current.createdAt,
                  profilePic: current.profilePic,
                  name: nameCtrl.text.isEmpty ? null : nameCtrl.text,
                  department: deptCtrl.text.isEmpty ? null : deptCtrl.text,
                  year: int.tryParse(yearCtrl.text),
                );

                Navigator.pop(ctx);
                updateProfile(updated);
              },
              child: const Text("Save Changes"),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Text(
            "Error: $errorMessage",
            style: const TextStyle(color: Colors.red, fontSize: 18),
          ),
        ),
      );
    }

    final user = profile!;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchProfileDirectly,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: user.profilePic != null
                  ? NetworkImage(user.profilePic!)
                  : null,
              child: user.profilePic == null
                  ? const Icon(Icons.person, size: 60)
                  : null,
            ),
            const SizedBox(height: 16),

            Text(
              user.name ?? "No name provided",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Role: ${user.role}",
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),

            Card(
              child: ListTile(
                leading: const Icon(Icons.school),
                title: const Text("Department"),
                subtitle: Text(user.department ?? "Not specified"),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text("Year"),
                subtitle: Text(
                  user.year != null ? "${user.year}" : "Not specified",
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.access_time),
                title: const Text("Joined on"),
                subtitle: Text(
                  user.createdAt.toLocal().toString().split(' ')[0],
                ),
              ),
            ),
            const SizedBox(height: 20),

            AppBtn(
              height: 50,
              width: MediaQuery.of(context).size.width * 0.7,
              onTap: () => showEditDialog(user),
              child: const Text("Edit Profile"),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
