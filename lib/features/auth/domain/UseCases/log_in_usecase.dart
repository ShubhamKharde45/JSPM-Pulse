import 'package:jspm_pulse/features/auth/domain/Entities/user_entity.dart';
import 'package:jspm_pulse/features/auth/domain/Repositories/auth_repo.dart';

class LogInUseCase {
  final AuthRepository authRepository;
  LogInUseCase({required this.authRepository});

  Future<UserEntity?> call(String email, String pwd) async {
    return await authRepository.logIn(email, pwd);
  }
}
