import 'package:bloc/bloc.dart';
import 'package:jspm_pulse/features/auth/domain/UseCases/auth_usecases.dart';
import 'package:jspm_pulse/features/auth/presentation/Bloc/auth_events.dart';
import 'package:jspm_pulse/features/auth/presentation/Bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthStates> {
  final AuthUseCases useCases;

  AuthBloc(this.useCases) : super(AuthInitial()) {
    on<SignUpEvent>(_onSignUp);
    on<LogInEvent>(_onLogIn);
    on<LoadCurrentUserEvent>(_onLoadCurrentUserEvent);
    on<SignOutEvent>(_onSignOutEvent);
    on<AddRoleDbEvent>(_onAddRoleDbEvent);
    on<GetCurrentUserRoleEvent>(_onGetCurrentUserRoleEvent);
  }

  Future<void> _onSignUp(SignUpEvent event, Emitter<AuthStates> emit) async {
    emit(AuthLoading());
    try {
      final user = await useCases.signUp(event.email, event.password);
      if (user != null) {
        emit(AuthSuccess(user));
      } else {
        emit(AuthFailure("Signup failed"));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onLogIn(LogInEvent event, Emitter<AuthStates> emit) async {
    emit(AuthLoading());
    try {
      final user = await useCases.logIn(event.email, event.password);
      if (user != null) {
        emit(AuthSuccess(user));
      } else {
        emit(AuthFailure("Login failed"));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onLoadCurrentUserEvent(
    LoadCurrentUserEvent event,
    Emitter<AuthStates> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await useCases.getCurrentUser();
      if (user != null) {
        emit(AuthSuccess(user));
      } else {
        emit(AuthFailure("No current user found"));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onSignOutEvent(
    SignOutEvent event,
    Emitter<AuthStates> emit,
  ) async {
    emit(AuthLoading());
    try {
      await useCases.signOut();
      emit(AuthSignOut());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

Future<void> _onAddRoleDbEvent(
  AddRoleDbEvent event,
  Emitter<AuthStates> emit,
) async {
  try {
    await useCases.addRoleToDbUseCase(event.role, event.userId);
    emit(RoleToDBSuccess());
  } catch (e) {
    emit(RoleToDBFailure());
  }
}


  Future<void> _onGetCurrentUserRoleEvent(
    GetCurrentUserRoleEvent event,
    Emitter<AuthStates> emit,
  ) async {
    emit(AuthLoading());
    try {
      final role = await useCases.getUserRoleUsecase();
      if (role != null) {
        emit(GetUserRoleSuccess(role));
      } else {
        emit(GetUserRoleFailure("Role not found for current user"));
      }
    } catch (e) {
      emit(GetUserRoleFailure(e.toString()));
    }
  }
}
