import 'dart:io';

import 'package:jspm_pulse/core/errors/server_errors.dart';
import 'package:jspm_pulse/features/profile/data/models/student_profile.dart';

abstract class ProfileRepository {
  Future<ServerResult> updateProfile(Profile profile);
  Future<ServerResult<Profile>> getProfile(String id);

  Future<ServerResult> updateProfilePic(Profile profile, File file);
}
