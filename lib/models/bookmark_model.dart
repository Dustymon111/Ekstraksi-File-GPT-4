import 'package:cloud_firestore/cloud_firestore.dart';

class Bookmark {
  String? id;
  final String title;
  final String author;
  final int totalPages;
  final String bookUrl;
  final String userId;

  Bookmark({
    this.id,
    required this.title,
    required this.author,
    required this.totalPages,
    required this.bookUrl,
    required this.userId,
  });

  // Convert Firestore document to Bookmark
  factory Bookmark.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Bookmark(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      author: data['author'] ?? '',
      totalPages: data['totalPages'] ?? 0,
      bookUrl: data['bookUrl'] ?? '',
      userId: data['userId'] ?? '',
    );
  }

  // Convert Firestore document map to Bookmark
  factory Bookmark.fromMap(Map<String, dynamic> data) {
    return Bookmark(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      author: data['author'] ?? '',
      totalPages: data['totalPages'] ?? 0,
      bookUrl: data['bookUrl'] ?? '',
      userId: data['userId'] ?? '',
    );
  }

  // Convert Bookmark to Firestore document map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'totalPages': totalPages,
      'bookUrl': bookUrl,
      'userId': userId,
    };
  }
}
