import 'package:cloud_firestore/cloud_firestore.dart';

class Announcement {
  const Announcement({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String message;
  final DateTime? createdAt;

  factory Announcement.fromDocument(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data() ?? <String, dynamic>{};
    final timestamp = data['createdAt'];
    return Announcement(
      id: document.id,
      title: data['title'] as String? ?? '',
      message: data['message'] as String? ?? '',
      createdAt: timestamp is Timestamp ? timestamp.toDate() : null,
    );
  }
}
