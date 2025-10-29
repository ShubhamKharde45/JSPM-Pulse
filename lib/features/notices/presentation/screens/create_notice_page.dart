import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jspm_pulse/core/service_locators/service_locator.dart';
import 'package:jspm_pulse/core/widgets/app_btn.dart';
import 'package:jspm_pulse/core/widgets/app_input_field.dart';
import 'package:jspm_pulse/features/notices/domain/entitis/notice_entity.dart';
import 'package:jspm_pulse/features/notices/presentation/bloc/notice_bloc.dart';
import 'package:jspm_pulse/features/notices/presentation/bloc/notice_events.dart';
import 'package:jspm_pulse/features/notices/presentation/widgets/file_pick_box_widget.dart';
import 'package:jspm_pulse/features/notices/presentation/widgets/role_selector_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreateNoticeScreen extends StatefulWidget {
  const CreateNoticeScreen({super.key});

  @override
  State<CreateNoticeScreen> createState() => _CreateNoticeScreenState();
}

class _CreateNoticeScreenState extends State<CreateNoticeScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  List<String> visibleTo = [];
  bool isFileSelected = false;
  File? selectedFile;

  List<String> noticeTypes = [
    'Exam Schedule',
    'Timetable Change',
    'Assignment Deadline',
    'Result Announcement',
    'Holiday Notice',
    'Fee Payment Deadline',
    'Event Announcement',
    'Placement Notice',
    'Workshop / Seminar',
    'Guest Lecture',
    'Emergency Alert',
    'General Announcement',
  ];

  String? selectNoticeType;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text("Create Notice"),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
        actionsPadding: EdgeInsets.only(right: 10),
        actions: [
          AppBtn(
            height: 45,
            width: 100,
            onTap: () async {
              Notice notice = Notice(
                title: titleController.text,
                description: descController.text,
                visibleTo: visibleTo,
                userId: getIt<SupabaseClient>().auth.currentUser!.id,
                category: selectNoticeType,
              );
              context.read<NoticeBloc>().add(
                CreateNoticeEvent(notice, selectedFile),
              );
              Navigator.pop(context);
            },
            child: Text(
              "upload",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: ListView(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownMenu(
                initialSelection: noticeTypes[0],
                requestFocusOnTap: true,
                hintText: "Select notice type.",
                width: MediaQuery.of(context).size.width * 0.9,
                dropdownMenuEntries: noticeTypes
                    .map((e) => DropdownMenuEntry(value: e, label: e))
                    .toList(),
                onSelected: (value) => setState(() {
                  selectNoticeType = value!;
                }),

                inputDecorationTheme: const InputDecorationTheme(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                ),
              ),
            ),
            SizedBox(height: 25),
            AppInputField(
              hint: "Title",
              obscureText: false,
              controller: titleController,
            ),
            SizedBox(height: 20),
            AppInputField(
              hint: "Description",
              obscureText: false,
              controller: descController,
            ),
            SizedBox(height: 20),
            Text(
              "Select visibility : ",
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            RoleSelector(
              onChanged: (selectedPeoples) => setState(() {
                visibleTo = selectedPeoples;
              }),
            ),
            SizedBox(height: 30),
            FilePickerBox(
              onFilePicked: (file) async {
                if (file != null) {
                  setState(() {
                    selectedFile = file;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
