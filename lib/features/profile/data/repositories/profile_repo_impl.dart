import 'dart:io';

import 'package:jspm_pulse/core/errors/server_errors.dart';
import 'package:jspm_pulse/features/profile/data/datasource/profile_datasaurce.dart';
import 'package:jspm_pulse/features/profile/data/models/student_profile.dart';
import 'package:jspm_pulse/features/profile/domain/repositories/profile_repo.dart';

class ProfileRepoImpl implements ProfileRepository {
  final ProfileDatasaurce _datasaurce;

  ProfileRepoImpl(this._datasaurce);

  @override
  Future<ServerResult> updateProfile(Profile profile) async {
    ServerResult result = await _datasaurce.updateProfile(profile);
    if (result is ServerSuccess) {
      return ServerSuccess(result.data);
    } else {
      return ServerFailure(message: "Error");
    }
  }

  @override
  Future<ServerResult> updateProfilePic(Profile profile, File file) async {
    ServerResult result = await _datasaurce.updateProfilePic(profile, file);
    if (result is ServerSuccess) {
      return ServerSuccess(result.data);
    } else {
      return ServerFailure(message: "Error while updating.");
    }
  }

  @override
  Future<ServerResult<Profile>> getProfile(String id) async {
    ServerResult result = await _datasaurce.getProfile(id);
    if (result is ServerSuccess) {
      return ServerSuccess(result.data);
    } else {
      return ServerFailure(message: "Error while gettimg profile.");
    }
  }
}
