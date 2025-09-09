import 'package:jspm_pulse/features/profile/data/models/profile_model.dart';

abstract class ProfileState {}

class ProfileInitialState extends ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileSuccessState extends ProfileState {
  final Profile data;

  ProfileSuccessState({required this.data});
}

class ProfileFailureState extends ProfileState {
  final String error;

  ProfileFailureState({required this.error});
}
