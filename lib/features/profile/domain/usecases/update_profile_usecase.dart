import 'package:jspm_pulse/core/errors/server_errors.dart';
import 'package:jspm_pulse/features/profile/data/models/student_profile.dart';
import 'package:jspm_pulse/features/profile/domain/repositories/profile_repo.dart';

class UpdateProfileUseCase {
  final ProfileRepository _profileRepository;

  UpdateProfileUseCase(this._profileRepository);

  Future<ServerResult<dynamic>> call(Profile profile) async {
    final response = await _profileRepository.updateProfile(profile);

    return response;
  }
}
