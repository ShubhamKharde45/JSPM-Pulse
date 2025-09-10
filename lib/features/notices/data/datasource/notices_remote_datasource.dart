import 'dart:io';

import 'package:jspm_pulse/features/notices/data/models/notice_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NoticesRemoteDatasource {
  final SupabaseClient _client;

  NoticesRemoteDatasource(this._client);

  Future<List<NoticeModel>> getAllNotices(String role) async {
    try {
      final response = await _client.from('notices').select().contains(
        'visible_to',
        [role],
      );

      if (response is List) {
        return response
            .map(
              (notice) => NoticeModel.fromMap(notice as Map<String, dynamic>),
            )
            .toList();
      } else {
        throw Exception("Unexpected response format: $response");
      }
    } catch (e) {
      throw Exception("Failed to fetch notices: $e");
    }
  }

  Future<NoticeModel> createNotice(NoticeModel notice, File? file) async {
    try {
      final userId = _client.auth.currentUser!.id;

      if (file != null) {
        final fileName = "${DateTime.now().millisecondsSinceEpoch}.png";
        final path = "$userId/$fileName";
        final bytes = await file.readAsBytes();
        final uploadResponse = await _client.storage
            .from("attachments")
            .uploadBinary(
              path,
              bytes,
              fileOptions: const FileOptions(upsert: true),
            );
        notice.attachments = path;
      } else {
        notice.attachments = null;
      }
      final response = await _client
          .from('notices')
          .insert(notice.toMap())
          .select()
          .single();

      return NoticeModel.fromMap(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception("Failed to create notices: $e");
    }
  }

  Future<NoticeModel> updateNotice(NoticeModel newnotice) async {
    try {
      final response = await _client
          .from('notices')
          .update(newnotice.toMap())
          .eq('id', newnotice.id!)
          .select()
          .single();

      return NoticeModel.fromMap(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception("Failed to update notice: $e");
    }
  }

  Future<void> deleteNotice(String id) async {
    try {
      final response = await _client.from('notices').delete().eq('id', id);
    } catch (e) {
      throw Exception("Failed to delete notice: $e");
    }
  }

  Stream<List<NoticeModel>> fetchAllNoticesStream(String role) {
    return _client.from('notices').stream(primaryKey: ['id']).map((rows) {
      final all = rows.map((e) => NoticeModel.fromMap(e)).toList();
      return all.where((n) => n.visibleTo.contains(role)).toList();
    });
  }
}
