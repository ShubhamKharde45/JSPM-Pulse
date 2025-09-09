import 'dart:io';

import 'package:jspm_pulse/core/errors/server_errors.dart';
import 'package:jspm_pulse/features/profile/data/models/profile_model.dart';
import 'package:jspm_pulse/features/profile/domain/repositories/profile_repo.dart';

class UpdateProfilePicUseCase {
  final ProfileRepository _profileRepository;
  UpdateProfilePicUseCase(this._profileRepository);

  Future<ServerResult<dynamic>> call(Profile profile, File file) async {
    final response = await _profileRepository.updateProfilePic(profile, file);
    return response;
  }
}
