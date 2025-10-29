import 'package:flutter/material.dart';

class RoleDropdown extends StatefulWidget {
  final Function(String) onRoleSelected;

  const RoleDropdown({super.key, required this.onRoleSelected});

  @override
  State<RoleDropdown> createState() => _RoleDropdownState();
}

class _RoleDropdownState extends State<RoleDropdown> {
  final List<String> roles = ["Student", "Faculty", "Member"];
  String? selectedRole;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: DropdownButton<String>(
        value: selectedRole,
        hint: const Text("Select Role"),
        isExpanded: true,
        underline: const SizedBox(),
        items: roles.map((role) {
          return DropdownMenuItem<String>(
            value: role,
            child: Text(role),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedRole = value;
          });
          widget.onRoleSelected(value!);
        },
      ),
    );
  }
}
