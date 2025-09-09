import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jspm_pulse/core/widgets/app_btn.dart';
import 'package:jspm_pulse/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:jspm_pulse/features/profile/presentation/bloc/profile_state.dart';
import 'package:jspm_pulse/features/profile/presentation/widgets/profile_info_container.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
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
            child: Text(
              "Update",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoadingState) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is ProfileFailureState) {
            return Center(child: Text(state.error));
          }
          if (state is ProfileSuccessState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // AVATAR AND USERNAME CONTAINER
                    Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(),
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                              state.data.profilePic!,
                            ),
                            radius: 40,
                          ),
                          Text(
                            state.data.name,
                            style: TextStyle(
                              color: Colors.grey.shade900,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Text(
                            "shubham@gmail.com",
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ProfileInfoContainer(
                      text: "Department",
                      desc: state.data.department,
                    ),
                    SizedBox(height: 20),
                    ProfileInfoContainer(
                      text: "Year",
                      desc: state.data.year.toString(),
                    ),
                  ],
                ),
              ),
            );
          }
          return Text("Error");
        },
      ),
    );
  }
}
