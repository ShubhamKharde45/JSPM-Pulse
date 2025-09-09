import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:jspm_pulse/core/service_locators/service_locator.dart';
import 'package:jspm_pulse/features/profile/data/models/profile_model.dart';
import 'package:jspm_pulse/features/profile/domain/repositories/profile_repo.dart';
import 'package:jspm_pulse/features/profile/domain/usecases/update_profile_pic_usecase.dart';

class CreateNoticePage extends StatefulWidget {
  const CreateNoticePage({super.key});

  @override
  State<CreateNoticePage> createState() => _CreateNoticePageState();
}

class _CreateNoticePageState extends State<CreateNoticePage> {
  Future<File?> pickFile() async {
    final file = await FilePicker.platform.pickFiles();

    if (file != null && file.files.single.path != null) {
      return File.fromUri(Uri.parse(file.files.single.path!));
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                // Profile profile = Profile(
                //   id: "d15839af-f50d-4e5d-a8c4-ef6c707348bc",
                //   name: "Shubham",
                //   role: "Student",
                // );

                // final file = await pickFile();
                // UpdateProfilePicUseCase(
                //   getIt<ProfileRepository>(),
                // ).call(profile, file!);
              },
              child: Icon(Icons.add),
            ),

            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
              },
              child: Icon(Icons.back_hand),
            ),
          ],
        ),
      ),
    );
  }
}
