import 'package:jspm_pulse/features/auth/domain/Repositories/auth_repo.dart';

class SignOutUseCase {
  final AuthRepository authRepository;
  SignOutUseCase({required this.authRepository});

  Future<void> call() async {
    await authRepository.signOut();
  }
}
