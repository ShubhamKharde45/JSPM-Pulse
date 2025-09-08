import 'dart:io';

import 'package:jspm_pulse/core/errors/server_errors.dart';
import 'package:jspm_pulse/features/profile/domain/entities/profile_entity.dart';
import 'package:jspm_pulse/features/profile/domain/repositories/profile_repo.dart';

class ProfileRepoImpl implements ProfileRepository {
  @override
  Future<ServerResult> updateProfile(
    StudentProfileEntity studentProfileEntity,
  ) async {
    return ServerFailure(message: "message");
  }

  @override
  Future<ServerResult> updateProfilePic(
    StudentProfileEntity studentProfileEntity,
    File file,
    String fileType,
  ) async {
    return ServerFailure(message: "message");
  }
}
