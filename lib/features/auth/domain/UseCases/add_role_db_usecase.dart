import 'package:jspm_pulse/features/auth/domain/Repositories/auth_repo.dart';

class AddRoleToDbUseCase {
  final AuthRepository authRepository;
  AddRoleToDbUseCase({required this.authRepository});

  Future<void> call(String role, String userId) async {
    await authRepository.addRoleToDB(role, userId);
  }
}
