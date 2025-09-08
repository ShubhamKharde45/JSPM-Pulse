import 'package:jspm_pulse/core/errors/server_errors.dart';
import 'package:jspm_pulse/features/notices/domain/entitis/notice_entity.dart';
import 'package:jspm_pulse/features/notices/domain/repository/notice_repo.dart';

class DeleteNoticeUsecase {
  final NoticeRepo _repo;

  DeleteNoticeUsecase(this._repo);

  Future<ServerResult<int>> call(Notice notice) async {
    final response = await _repo.deleteNotice(notice.id.toString());

    if (response is ServerSuccess) {
      return ServerSuccess(200);
    }
    return ServerFailure(message: "Error while deleting notice.");
  }
}
