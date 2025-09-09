import 'dart:io';

import 'package:jspm_pulse/features/profile/data/models/profile_model.dart';

abstract class ProfileEvents {}

class FetchProfileEvent extends ProfileEvents {
  final String id;

  FetchProfileEvent({required this.id});
}

class UpdateProfileEvent extends ProfileEvents {
  final Profile profile;

  UpdateProfileEvent({required this.profile});
}

class UpdateProfilePicEvent extends ProfileEvents {
  final Profile profile;
  final File file;

  UpdateProfilePicEvent({required this.profile, required this.file});
}
