import 'package:jspm_pulse/features/notices/domain/entitis/notice_entity.dart';

class NoticeModel extends Notice {
  @override
  String? attachments;

  NoticeModel({
    super.id,
    super.createdAt,
    required super.title,
    required super.description,
    this.attachments,
    super.category,
    super.userId,
    required super.visibleTo,
  }) : super(attachments: attachments);

  factory NoticeModel.fromMap(Map<String, dynamic> map) {
    return NoticeModel(
      id: map['id'] as String?,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
      title: map['title'] as String,
      description: map['description'] as String,
      attachments: map['attachments'] as String?,
      category: map['category'] as String?,
      userId: map['user_id'] as String?,
      visibleTo: List<String>.from(map['visible_to'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'title': title,
      'description': description,
      'attachments': attachments,
      'category': category,
      'user_id': userId,
      'visible_to': visibleTo,
    };

    if (id != null) map['id'] = id;
    if (createdAt != null) map['created_at'] = createdAt!.toIso8601String();

    return map;
  }

  factory NoticeModel.fromEntity(Notice entity) {
    return NoticeModel(
      id: entity.id,
      createdAt: entity.createdAt,
      title: entity.title,
      description: entity.description,
      attachments: entity.attachments,
      category: entity.category,
      userId: entity.userId,
      visibleTo: entity.visibleTo,
    );
  }

  /// ✅ Allows updating attachments after creation
  void updateAttachments(String? newAttachments) {
    attachments = newAttachments;
  }
}
