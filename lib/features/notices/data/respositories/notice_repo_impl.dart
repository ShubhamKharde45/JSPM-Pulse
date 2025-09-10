import 'dart:io';

import 'package:jspm_pulse/core/errors/server_errors.dart';
import 'package:jspm_pulse/features/notices/data/datasource/notices_remote_datasource.dart';
import 'package:jspm_pulse/features/notices/data/models/notice_model.dart';
import 'package:jspm_pulse/features/notices/domain/entitis/notice_entity.dart';
import 'package:jspm_pulse/features/notices/domain/repository/notice_repo.dart';

class NoticeRepoImpl implements NoticeRepo {
  final NoticesRemoteDatasource _datasource;

  NoticeRepoImpl(this._datasource);

  @override
  Future<ServerResult<Notice>> createNotice(Notice notice, File? file) async {
    try {
      final model = NoticeModel.fromEntity(notice);
      final data = await _datasource.createNotice(model, file);
      return ServerSuccess(data);
    } catch (e) {
      return ServerFailure(
        message: "Failed to sreate notice: $e",
        statusCode: 404,
      );
    }
  }

  @override
  Future<ServerResult> deleteNotice(String id) async {
    try {
      await _datasource.deleteNotice(id);
      return const ServerSuccess(null);
    } catch (e) {
      return ServerFailure(
        message: "Failed to delete notices: $e",
        statusCode: 404,
      );
    }
  }

  @override
  Future<ServerResult<Notice>> updateNotice(Notice notice) async {
    try {
      final model = NoticeModel.fromEntity(notice);
      final data = await _datasource.updateNotice(model);
      return ServerSuccess(data);
    } catch (e) {
      return ServerFailure(
        message: "Failed to update notices: $e",
        statusCode: 404,
      );
    }
  }

  @override
  Future<ServerResult<List<Notice>>> fetchAllNotices(String role) async {
    try {
      final data = await _datasource.getAllNotices(role);
      return ServerSuccess(data);
    } catch (e) {
      return ServerFailure(
        message: "Failed to fetch notices: $e",
        statusCode: 404,
      );
    }
  }

  @override
  Stream<List<Notice>> fetchAllNoticesStream(String role) {
    try {
      return _datasource.fetchAllNoticesStream(role);
    } catch (e) {
      return Stream.empty(broadcast: false);
    }
  }
}
