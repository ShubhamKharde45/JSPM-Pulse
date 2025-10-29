import 'dart:io';
import 'package:jspm_pulse/features/notices/data/models/notice_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NoticesRemoteDatasource {
  final SupabaseClient _client;

  NoticesRemoteDatasource(this._client);

  Future<List<NoticeModel>> getAllNotices(String role) async {
    try {
      final response = await _client
          .from('notices')
          .select()
          .contains('visible_to', [role])
          .order('created_at', ascending: false);

      if (response is List) {
        return response
            .map((notice) => NoticeModel.fromMap(notice as Map<String, dynamic>))
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
        await _client.storage.from("attachments").uploadBinary(
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
          .insert({
            ...notice.toMap(),
            'visible_to': notice.visibleTo, // explicitly set array
          })
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
      await _client.from('notices').delete().eq('id', id);
    } catch (e) {
      throw Exception("Failed to delete notice: $e");
    }
  }

  

Stream<List<NoticeModel>> fetchAllNoticesStream(List<String> roles) {
  final normalizedRoles = roles.map((r) => r.trim().toLowerCase()).toList();

  return _client.from('notices').stream(primaryKey: ['id']).map((rows) {
    final all = rows.map((e) => NoticeModel.fromMap(e)).toList();

    final filtered = all.where((notice) {
      final visible = notice.visibleTo.map((r) => r.trim().toLowerCase());
      return visible.any((r) => normalizedRoles.contains(r));
    }).toList();

    // ✅ Sort so latest notice appears first
    filtered.sort((a, b) {
      final dateA = a.createdAt ?? DateTime(1970);
      final dateB = b.createdAt ?? DateTime(1970);
      return dateB.compareTo(dateA);
    });

    return filtered;
  });
}

}
