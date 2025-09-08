import 'package:jspm_pulse/features/notices/domain/entitis/notice_entity.dart';

abstract class NoticeStates {}

class NoticeInitialState extends NoticeStates {}

class NoticeLoadingState extends NoticeStates {}

class NoticeLoadedState extends NoticeStates {
  final List<Notice> notices;

  NoticeLoadedState(this.notices);
}

class NoticeCreatedState extends NoticeStates {}

class NoticeUpdatedState extends NoticeStates {}

class NoticeDeletedState extends NoticeStates {}

class NoticeFailureState extends NoticeStates {
  final String error;

  NoticeFailureState(this.error);
}
