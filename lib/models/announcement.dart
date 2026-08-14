class AnnouncementModel {
  final String id;
  final String title;
  final String content;
  final String date;
  final String audience; // 'All', 'Students', 'Teachers', 'Parents'
  final String status; // 'Published', 'Draft'

  const AnnouncementModel({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.audience,
    this.status = 'Published',
  });
}
