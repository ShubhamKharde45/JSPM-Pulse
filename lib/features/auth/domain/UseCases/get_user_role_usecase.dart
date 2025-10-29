
import 'package:jspm_pulse/features/auth/domain/Repositories/auth_repo.dart';

class GetUserRoleUsecase {
  final AuthRepository authRepository;
  GetUserRoleUsecase({required this.authRepository});

  Future<String?> call() async {
    return await authRepository.getCurrentUserRole();
  }
}
