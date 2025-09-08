class Notice {
  final String? id;
  final DateTime? createdAt;
  final String title;
  final String description;
  final String? attachments;
  final String? category;
  final String? userId;
  final List<String> visibleTo; // roles array

  const Notice({
    this.id,
    this.createdAt,
    required this.title,
    required this.description,
    this.attachments,
    this.category,
    this.userId,
    required this.visibleTo,
  });
}
