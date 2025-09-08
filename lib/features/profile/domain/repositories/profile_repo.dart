import 'dart:io';

import 'package:jspm_pulse/core/errors/server_errors.dart';
import 'package:jspm_pulse/features/profile/domain/entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<ServerResult> updateProfile(StudentProfileEntity studentProfileEntity);

  Future<ServerResult> updateProfilePic(
    StudentProfileEntity studentProfileEntity,
    File file,
    String fileType,
  );
}
