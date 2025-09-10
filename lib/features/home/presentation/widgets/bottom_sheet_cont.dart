import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jspm_pulse/features/notices/presentation/screens/create_notice_page.dart';
import 'package:jspm_pulse/features/profile/presentation/pages/profile_screen.dart';

class BottomSheetCont extends StatelessWidget {
  const BottomSheetCont({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Wrap(
        children: [
          // AppBtn(
          //   height: 70,
          //   width: MediaQuery.of(context).size.width,
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => CreateNoticeScreen()),
          //     );
          //   },
          //   child: Text(
          //     "Create Notice",
          //     style: TextStyle(
          //       color: Colors.white,
          //       fontSize: 25,

          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          // ),
          SizedBox(height: 15),
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateNoticeScreen()),
              );
            },
            leading: Icon(CupertinoIcons.add, size: 35),
            title: Text("Create Notice", style: TextStyle(fontSize: 20)),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
            leading: Icon(CupertinoIcons.person_crop_circle_fill, size: 35),
            title: Text("Profile", style: TextStyle(fontSize: 20)),
          ),
          ListTile(
            onTap: () {},
            leading: Icon(Icons.settings, size: 35),
            title: Text("Settings", style: TextStyle(fontSize: 20)),
          ),
        ],
      ),
    );
  }
}
