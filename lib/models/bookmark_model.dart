import 'package:cloud_firestore/cloud_firestore.dart';
import 'subject_model.dart';

class Bookmark {
  final String title;
  final String author;
  final int pageNumber;
  final List<Subject> subjects;

  Bookmark({
    required this.title,
    required this.author,
    required this.pageNumber,
    required this.subjects,
  });

  // Convert Firestore document to Bookmark
  factory Bookmark.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Bookmark(
      title: data['title'] ?? '',
      author: data['author'] ?? '',
      pageNumber: data['pageNumber'] ?? 0,
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
      pageNumber: data['pageNumber'] ?? 0,
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
      'pageNumber': pageNumber,
      'subjects': subjects.map((subject) => subject.toMap()).toList(),
    };
  }
}