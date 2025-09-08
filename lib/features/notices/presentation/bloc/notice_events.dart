import 'package:jspm_pulse/features/notices/domain/entitis/notice_entity.dart';

abstract class NoticeEvents {}

class CreateNoticeEvent extends NoticeEvents {
  final Notice notice;

  CreateNoticeEvent(this.notice);
}

class UpdateNoticeEvent extends NoticeEvents {}

class DeleteNoticeEvent extends NoticeEvents {}

class FetchAllNoticesEvent extends NoticeEvents {
  final String role;

  FetchAllNoticesEvent({required this.role});
}

class FetchAllNoticesStreamEvent extends NoticeEvents {
  final List<String> roles;
  FetchAllNoticesStreamEvent(this.roles);
}
