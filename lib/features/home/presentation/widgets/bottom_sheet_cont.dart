import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jspm_pulse/core/widgets/app_btn.dart';

class BottomSheetCont extends StatelessWidget {
  const BottomSheetCont({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Wrap(
        children: [
          AppBtn(
            height: 70,
            width: MediaQuery.of(context).size.width,
            onTap: () {},
            child: Text(
              "Create Notice",
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,

                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 15),
          ListTile(
            onTap: () {},
            leading: Icon(CupertinoIcons.person_crop_circle_fill, size: 35),
            title: Text("Profile", style: TextStyle(fontSize: 20)),
          ),
          ListTile(
            onTap: () {},
            leading: Icon(Icons.settings, size: 35),
            title: Text("Settings", style: TextStyle(fontSize: 20)),
          ),
          ListTile(
            onTap: () {},
            leading: Icon(Icons.inbox, size: 35),
            title: Text("About", style: TextStyle(fontSize: 20)),
          ),
        ],
      ),
    );
  }
}
