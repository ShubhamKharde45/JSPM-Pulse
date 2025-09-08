import 'package:jspm_pulse/features/notices/domain/entitis/notice_entity.dart';
import 'package:jspm_pulse/features/notices/domain/repository/notice_repo.dart';

class FetchAllNoticesStreamUseCase{
  final NoticeRepo _repo;
  FetchAllNoticesStreamUseCase(this._repo);

  Stream<List<Notice>> call(String role) {
    final result = _repo.fetchAllNoticesStream(role);
    return result;
  }
}
