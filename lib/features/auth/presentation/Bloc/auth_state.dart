import 'package:jspm_pulse/features/auth/domain/Entities/user_entity.dart';

abstract class AuthStates {}

class AuthInitial extends AuthStates {}

class AuthLoading extends AuthStates {}

class AuthSuccess extends AuthStates {
  final UserEntity user;
  AuthSuccess(this.user);
}

class AuthSignOut extends AuthStates {}

class AuthFailure extends AuthStates {
  final String error;

  AuthFailure(this.error);
}
