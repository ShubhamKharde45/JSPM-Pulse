import 'package:jspm_pulse/features/auth/domain/Entities/user_entity.dart';
import 'package:jspm_pulse/features/auth/domain/Repositories/auth_repo.dart';

class GetCurrentUserUseCase {
  final AuthRepository authRepository;
  GetCurrentUserUseCase({required this.authRepository});

  Future<UserEntity?> call() async {
    return await authRepository.getCurrentUser();
  }
}
