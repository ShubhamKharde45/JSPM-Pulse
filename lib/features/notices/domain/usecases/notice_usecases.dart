import 'package:jspm_pulse/features/notices/domain/usecases/create_notice_usecase.dart';
import 'package:jspm_pulse/features/notices/domain/usecases/delete_notice_usecase.dart';
import 'package:jspm_pulse/features/notices/domain/usecases/fetch_all_notices.dart';
import 'package:jspm_pulse/features/notices/domain/usecases/fetch_all_notices_stream.dart';
import 'package:jspm_pulse/features/notices/domain/usecases/update_notice_usecase.dart';

class NoticeUsecases {
  final CreateNoticeUseCase createNoticeUseCase;
  final FetchAllNoticesUseCase fetchAllNoticesUseCase;
  final UpdateNoticeUsecase updateNoticeUsecase;
  final DeleteNoticeUsecase deleteNoticeUsecase;
  final FetchAllNoticesStreamUseCase fetchAllNoticesStreamUseCase;

  NoticeUsecases({
    required this.createNoticeUseCase,
    required this.fetchAllNoticesUseCase,
    required this.updateNoticeUsecase,
    required this.deleteNoticeUsecase,
    required this.fetchAllNoticesStreamUseCase,
  });
}
