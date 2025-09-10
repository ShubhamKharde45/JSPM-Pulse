import 'dart:io';

import 'package:jspm_pulse/core/errors/server_errors.dart';
import 'package:jspm_pulse/features/notices/domain/entitis/notice_entity.dart';

abstract class NoticeRepo {
  Future<ServerResult<Notice>> createNotice(Notice notice, File? file);
  Future<ServerResult<void>> deleteNotice(String id);
  Future<ServerResult<Notice>> updateNotice(Notice notice);
  Future<ServerResult<List<Notice>>> fetchAllNotices(String role);
  Stream<List<Notice>> fetchAllNoticesStream(String role);
}
