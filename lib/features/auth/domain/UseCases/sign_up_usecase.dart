import 'package:jspm_pulse/features/auth/domain/Entities/user_entity.dart';
import 'package:jspm_pulse/features/auth/domain/Repositories/auth_repo.dart';

class SignUpUseCase {
  final AuthRepository authRepository;
  SignUpUseCase({required this.authRepository});

  Future<UserEntity?> call(String email, String pwd) async {
    return await authRepository.signUp(email, pwd);
  }
}
