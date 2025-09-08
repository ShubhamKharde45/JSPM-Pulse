import 'package:jspm_pulse/core/errors/server_errors.dart';
import 'package:jspm_pulse/features/profile/domain/repositories/profile_repo.dart';

class GetProfileUseCase {
  final ProfileRepository _profileRepository;

  GetProfileUseCase(this._profileRepository);

  Future<ServerResult<dynamic>> call(String id) async {
    final response = await _profileRepository.getProfile(id);

    return response;
  }
}
