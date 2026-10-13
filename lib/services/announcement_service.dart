import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/announcement.dart';

class AnnouncementService {
  AnnouncementService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('announcements');

  Stream<List<Announcement>> watchAnnouncements() {
    return _collection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(Announcement.fromDocument)
              .toList(growable: false),
        );
  }

  Future<void> createAnnouncement({
    required String title,
    required String message,
  }) async {
    await _collection.add({
      'title': title.trim(),
      'message': message.trim(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateAnnouncement({
    required String id,
    required String title,
    required String message,
  }) async {
    await _collection.doc(id).update({
      'title': title.trim(),
      'message': message.trim(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteAnnouncement(String id) async {
    await _collection.doc(id).delete();
  }
}
