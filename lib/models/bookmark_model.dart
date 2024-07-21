import 'package:cloud_firestore/cloud_firestore.dart';
import 'subject_model.dart';

class Bookmark {
  final String title;
  final String author;
  final int totalPages;
  final String bookUrl;
  final List<Subject> subjects;
  final String localFilePath;

  Bookmark({
    required this.title,
    required this.author,
    required this.totalPages,
    required this.bookUrl,
    required this.subjects,
    required this.localFilePath,
  });

  // Convert Firestore document to Bookmark
  factory Bookmark.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Bookmark(
      title: data['title'] ?? '',
      author: data['author'] ?? '',
      totalPages: data['totalPages'] ?? 0,
      bookUrl: data['bookUrl'] ?? '',
      localFilePath: data['localFilePath'] ?? '',
      subjects: (data['subjects'] as List<dynamic>? ?? []).map((subjectData) {
        return Subject.fromMap(subjectData as Map<String, dynamic>);
      }).toList(),
    );
  }

  // Convert Firestore document map to Bookmark
  factory Bookmark.fromMap(Map<String, dynamic> data) {
    return Bookmark(
      title: data['title'] ?? '',
      author: data['author'] ?? '',
      totalPages: data['totalPages'] ?? 0,
      bookUrl: data['bookUrl'] ?? '',
      localFilePath: data['localFilePath'] ?? '',
      subjects: (data['subjects'] as List<dynamic>? ?? []).map((subjectData) {
        return Subject.fromMap(subjectData as Map<String, dynamic>);
      }).toList(),
    );
  }

  // Convert Bookmark to Firestore document map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'totalPages': totalPages,
      'bookUrl' :  bookUrl,
      'localFilePath': localFilePath,
      'subjects': subjects.map((subject) => subject.toMap()).toList(),
    };
  }
}