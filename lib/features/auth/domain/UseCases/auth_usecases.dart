import 'package:jspm_pulse/features/auth/domain/UseCases/get_current_user_usecase.dart';
import 'package:jspm_pulse/features/auth/domain/UseCases/log_in_usecase.dart';
import 'package:jspm_pulse/features/auth/domain/UseCases/sign_out_usecase.dart';
import 'package:jspm_pulse/features/auth/domain/UseCases/sign_up_usecase.dart';

class AuthUseCases {
  final SignUpUseCase signUp;
  final LogInUseCase logIn;
  final SignOutUseCase signOut;
  final GetCurrentUserUseCase getCurrentUser;

  AuthUseCases({
    required this.signUp,
    required this.logIn,
    required this.signOut,
    required this.getCurrentUser,
  });
}
