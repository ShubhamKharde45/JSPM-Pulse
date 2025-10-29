import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jspm_pulse/core/errors/server_errors.dart';

import 'package:jspm_pulse/features/notices/domain/entitis/notice_entity.dart';
import 'package:jspm_pulse/features/notices/domain/usecases/notice_usecases.dart';
import 'package:jspm_pulse/features/notices/presentation/bloc/notice_events.dart';
import 'package:jspm_pulse/features/notices/presentation/bloc/notice_states.dart';

class NoticeBloc extends Bloc<NoticeEvents, NoticeStates> {
  final NoticeUsecases noticeUsecases;
  Stream<List<Notice>>? _noticesStream;

  NoticeBloc(this.noticeUsecases) : super(NoticeInitialState()) {
    on<CreateNoticeEvent>(_createNotice);
    on<FetchAllNoticesEvent>(_fetchAllNotices);
    on<FetchAllNoticesStreamEvent>(_fetchAllNoticesStream);
  }

  Future<void> _createNotice(
    CreateNoticeEvent event,
    Emitter<NoticeStates> emit,
  ) async {
    emit(NoticeLoadingState());
    try {
      await noticeUsecases.createNoticeUseCase(event.notice, event.file);
      emit(NoticeCreatedState());
    } catch (e) {
      emit(NoticeFailureState(e.toString()));
    }
  }

  Future<void> _fetchAllNotices(
    FetchAllNoticesEvent event,
    Emitter<NoticeStates> emit,
  ) async {
    emit(NoticeLoadingState());
    try {
      final result = await noticeUsecases.fetchAllNoticesUseCase(event.role);

      if (result is ServerSuccess<List<Notice>>) {
        // data is guaranteed non-null
        emit(NoticeLoadedState(result.data));
      } else if (result is ServerFailure<List<Notice>>) {
        // message is guaranteed non-null
        emit(NoticeFailureState(result.message));
      } else {
        emit(NoticeFailureState("Unknown error occurred"));
      }
    } catch (e) {
      emit(NoticeFailureState(e.toString()));
    }
  }

Future<void> _fetchAllNoticesStream(
  FetchAllNoticesStreamEvent event,
  Emitter<NoticeStates> emit,
) async {
  emit(NoticeLoadingState());
  try {
    _noticesStream = noticeUsecases.fetchAllNoticesStreamUseCase(event.roles);
    await emit.forEach<List<Notice>>(
      _noticesStream!,
      onData: (notices) => NoticeLoadedState(notices),
    );
  } catch (e) {
    emit(NoticeFailureState("Failed to load notices: $e"));
  }
}

}
