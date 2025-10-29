import 'package:flutter/material.dart';

class RoleSelector extends StatefulWidget {
  final Function(List<String>) onChanged; // callback

  const RoleSelector({Key? key, required this.onChanged}) : super(key: key);

  @override
  State<RoleSelector> createState() => _RoleSelectorState();
}

class _RoleSelectorState extends State<RoleSelector> {
  bool student = false;
  bool faculty = false;
  bool member = false;

  void _notifyParent() {
    final selected = <String>[];
    if (student) selected.add("Student");
    if (faculty) selected.add("Faculty");
    if (member) selected.add("Member");
    widget.onChanged(selected);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CheckboxListTile(
          title: const Text("Student"),
          value: student,
          onChanged: (val) {
            setState(() => student = val ?? false);
            _notifyParent();
          },
        ),
        CheckboxListTile(
          title: const Text("Faculty"),
          value: faculty,
          onChanged: (val) {
            setState(() => faculty = val ?? false);
            _notifyParent();
          },
        ),
        CheckboxListTile(
          title: const Text("Member"),
          value: member,
          onChanged: (val) {
            setState(() => member = val ?? false);
            _notifyParent();
          },
        ),
      ],
    );
  }
}
