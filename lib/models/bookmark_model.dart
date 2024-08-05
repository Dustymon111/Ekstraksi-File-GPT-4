import 'package:cloud_firestore/cloud_firestore.dart';

class Bookmark {
  String? id;
  final String title;
  final List<String> author;
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

  factory Bookmark.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    // Ensure that 'author' is a list of strings
    List<String> authors = (data['author'] as List<dynamic>)
        .map((item) => item as String)
        .toList();

    return Bookmark(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      author: authors,
      totalPages: data['totalPages'] ?? 0,
      bookUrl: data['bookUrl'] ?? '',
      userId: data['userId'] ?? '',
    );
  }

  factory Bookmark.fromMap(Map<String, dynamic> data) {
    // Ensure that 'author' is a list of strings
    List<String> authors = (data['author'] as List<dynamic>)
        .map((item) => item as String)
        .toList();

    return Bookmark(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      author: authors,
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
