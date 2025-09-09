import 'package:flutter/material.dart';

class ProfileInfoContainer extends StatelessWidget {
  const ProfileInfoContainer({
    super.key,
    required this.text,
    required this.desc,
  });
  final String text;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      margin: EdgeInsets.symmetric(horizontal: 15),

      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200, width: 3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: TextStyle(
              color: Colors.grey.shade800,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),

          Text(
            desc,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
