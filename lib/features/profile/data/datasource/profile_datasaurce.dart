import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:jspm_pulse/core/errors/server_errors.dart';
import 'package:jspm_pulse/features/profile/data/models/student_profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileDatasaurce {
  final SupabaseClient _client;

  ProfileDatasaurce(this._client);

  Future<ServerResult> updateProfile(Profile profile) async {
    try {
      final response = await _client
          .from("users")
          .update(profile.toMap())
          .eq('id', profile.id)
          .select()
          .single();
      if (response != null) {
        return ServerSuccess(response);
      }
      return ServerFailure(message: "Error while updating profile");
    } catch (e) {
      return ServerFailure(message: "Error : ${e.toString()}");
    }
  }

  Future<ServerResult> updateProfilePic(Profile profile, File file) async {
    try {
      final userId = _client.auth.currentUser!.id;
      final fileName = "${DateTime.now().millisecondsSinceEpoch}.png";
      final path = "$userId/$fileName";
      if (kIsWeb) {
        final bytes = await file.readAsBytes();
        final response = await _client.storage
            .from("attachments")
            .uploadBinary(
              path,
              bytes,
              fileOptions: const FileOptions(upsert: true),
            );
      } else {
        final bytes = await file.readAsBytes();
        final response = await _client.storage
            .from("attachments")
            .uploadBinary(path, bytes);
      }

      final response = await _client
          .from("users")
          .update({"profile_pic": path})
          .eq('id', profile.id)
          .select()
          .single();

      return ServerSuccess(response);
    } catch (e) {
      return ServerFailure(message: "Error : ${e.toString()}");
    }
  }

  Future<ServerResult<Profile>> getProfile(String id) async {
    try {
      final response = await _client.from("users").select().eq('id', id);
      final data = Profile.fromMap(response.first);

      final signedUrl = await _client.storage
          .from("attachments")
          .createSignedUrl(data.profilePicUrl ?? "dummy/profile.png", 60);

      data.profilePicUrl = signedUrl;

      return ServerSuccess(data); // data is profile here
    } catch (e) {
      return ServerFailure(message: "Error : ${e.toString()}");
    }
  }
}
