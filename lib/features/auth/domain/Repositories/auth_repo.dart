import 'package:jspm_pulse/features/auth/domain/Entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity?> getCurrentUser();
  Future<UserEntity?> signUp(String email, String pwd);
  Future<UserEntity?> logIn(String email, String pwd);
  Future<void> signOut();
}
