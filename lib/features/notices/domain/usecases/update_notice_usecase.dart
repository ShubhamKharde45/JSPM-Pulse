import 'package:jspm_pulse/core/errors/server_errors.dart';
import 'package:jspm_pulse/features/notices/domain/entitis/notice_entity.dart';
import 'package:jspm_pulse/features/notices/domain/repository/notice_repo.dart';

class UpdateNoticeUsecase {
  final NoticeRepo _repo;

  UpdateNoticeUsecase(this._repo);

  Future<ServerResult> call(Notice notice) async {
    final response = await _repo.updateNotice(notice);

    if (response is ServerSuccess) {
      return response;
    }
    return ServerFailure(message: "Error while updating notice.");
  }
}
