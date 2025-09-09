import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jspm_pulse/core/errors/server_errors.dart';
import 'package:jspm_pulse/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:jspm_pulse/features/profile/domain/usecases/update_profile_pic_usecase.dart';
import 'package:jspm_pulse/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:jspm_pulse/features/profile/presentation/bloc/profile_events.dart';
import 'package:jspm_pulse/features/profile/presentation/bloc/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvents, ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final UpdateProfilePicUseCase updateProfilePicUseCase;

  ProfileBloc(
    this.getProfileUseCase,
    this.updateProfileUseCase,
    this.updateProfilePicUseCase,
  ) : super(ProfileInitialState()) {
    on<FetchProfileEvent>(_fetchProfile);
    on<UpdateProfileEvent>(_updateProfile);
    on<UpdateProfilePicEvent>(_updateProfilePic);
  }

  Future<void> _fetchProfile(FetchProfileEvent event, Emitter emit) async {
    emit(ProfileLoadingState());

    final response = await getProfileUseCase.call(event.id);

    if (response is ServerSuccess) {
      emit(ProfileSuccessState(data: response.data));
      return;
    } else {
      response as ServerFailure;
      emit(ProfileFailureState(error: response.message));
      return;
    }
  }

  Future<void> _updateProfile(UpdateProfileEvent event, Emitter emit) async {
    emit(ProfileLoadingState());

    final response = await updateProfileUseCase.call(event.profile);

    if (response is ServerSuccess) {
      emit(ProfileSuccessState(data: response.data));
      return;
    } else {
      response as ServerFailure;
      emit(ProfileFailureState(error: response.message));
      return;
    }
  }

  Future<void> _updateProfilePic(
    UpdateProfilePicEvent event,
    Emitter emit,
  ) async {
    emit(ProfileLoadingState());

    final response = await updateProfilePicUseCase.call(
      event.profile,
      event.file,
    );

    if (response is ServerSuccess) {
      emit(ProfileSuccessState(data: response.data));
      return;
    } else {
      response as ServerFailure;
      emit(ProfileFailureState(error: response.message));
      return;
    }
  }
}
