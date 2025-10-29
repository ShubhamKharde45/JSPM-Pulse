abstract class AuthEvent {}

class LoadCurrentUserEvent extends AuthEvent {}

class SignUpEvent extends AuthEvent {
  final String email;
  final String password;

  SignUpEvent(this.email, this.password);
}

class LogInEvent extends AuthEvent {
  final String email;
  final String password;

  LogInEvent(this.email, this.password);
}

class SignOutEvent extends AuthEvent {}

class AddRoleDbEvent extends AuthEvent {
  final String role;
  final String userId;
  AddRoleDbEvent(this.role, this.userId);
}


class GetCurrentUserRoleEvent extends AuthEvent {}
