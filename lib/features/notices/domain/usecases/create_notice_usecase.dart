import 'dart:io';

import 'package:jspm_pulse/core/errors/server_errors.dart';
import 'package:jspm_pulse/features/notices/domain/entitis/notice_entity.dart';
import 'package:jspm_pulse/features/notices/domain/repository/notice_repo.dart';

class CreateNoticeUseCase {
  final NoticeRepo _repo;

  CreateNoticeUseCase(this._repo);

  Future<ServerResult<Notice>> call(Notice notice, File? file) async {
    return await _repo.createNotice(notice, file);
  }
}
