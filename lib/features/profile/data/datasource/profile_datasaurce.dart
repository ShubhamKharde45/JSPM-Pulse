import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:jspm_pulse/core/errors/server_errors.dart';
import 'package:jspm_pulse/features/profile/data/models/profile_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileDatasaurce {
  final SupabaseClient _client;

  ProfileDatasaurce(this._client);

  Future<ServerResult<void>> updateProfile(Profile profile) async {
    try {
      final updateData = {
        'name': profile.name ?? '',
        'department': profile.department ?? '',
        'year': profile.year ?? 0,
        'role': profile.role,
        'profile_pic': profile.profilePic ?? 'dummy/profile.png',
      };

      await _client.from('users').update(updateData).eq('id', profile.id);

      return ServerSuccess(null);
    } catch (e, st) {
      print('❌ UpdateProfile Error: $e');
      print('STACKTRACE:\n$st');
      return ServerFailure(message: 'Error updating profile: ${e.toString()}');
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
    final response = await _client
        .from("users")
        .select()
        .eq('id', id)
        .maybeSingle();

    if (response == null) {
      return ServerFailure(message: "User not found");
    }

    final data = Profile.fromMap(response);

    final imagePath = (data.profilePic?.isNotEmpty ?? false)
        ? data.profilePic!
        : "dummy/profile.png";

    String finalImageUrl;

    if (imagePath.startsWith("http")) {
      finalImageUrl = imagePath;
    } 
    else {
      try {
        final signedUrl = await _client.storage
            .from("attachments")
            .createSignedUrl(imagePath, 60);
        finalImageUrl = signedUrl;
      } catch (e) {
        finalImageUrl =
            "https://cgokpagcgcbgswmbphrr.supabase.co/storage/v1/object/sign/attachments/dummy/profile.png?token=eyJraWQiOiJzdG9yYWdlLXVybC1zaWduaW5nLWtleV8yNjg5MGM4NC0wZTk1LTRkMmQtOGYyYy01OGU5MmJmNWZmNDYiLCJhbGciOiJIUzI1NiJ9.eyJ1cmwiOiJhdHRhY2htZW50cy9kdW1teS9wcm9maWxlLnBuZyIsImlhdCI6MTc2MjA5MDQ2MiwiZXhwIjoxNzkzNjI2NDYyfQ.SZKQY61jt3DnEwprIqVL4jxXkCg63B1jJb-5n5UmTWk";
        print("⚠️ Could not sign image URL: $e");
      }
    }

    data.profilePic = finalImageUrl;
    return ServerSuccess(data);
  } catch (e, st) {
    return ServerFailure(message: "Error: ${e.toString()}");
  }
}

}
