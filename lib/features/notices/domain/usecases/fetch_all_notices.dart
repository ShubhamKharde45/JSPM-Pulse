import 'package:jspm_pulse/core/errors/server_errors.dart';
import 'package:jspm_pulse/features/notices/domain/entitis/notice_entity.dart';
import 'package:jspm_pulse/features/notices/domain/repository/notice_repo.dart';

class FetchAllNoticesUseCase {
  final NoticeRepo _repo;
  FetchAllNoticesUseCase(this._repo);

  Future<ServerResult<List<Notice>>> call(String role) async {
    final result = await _repo.fetchAllNotices(role);
    return result;
  }
}
