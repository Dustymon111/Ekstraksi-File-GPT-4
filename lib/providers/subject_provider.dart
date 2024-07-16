import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/models/subject_model.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/models/bookmark_model.dart';

class SubjectProvider with ChangeNotifier {
  List<Subject> _subjects = [];

  List<Subject> get subjects => _subjects;

  Future<void> fetchSubjects(String bookId, String bookmarkId) async {
    try {
      // Fetch the book document
      final bookDoc = await FirebaseFirestore.instance.collection('books').doc(bookId).get();

      if (bookDoc.exists) {
        final data = bookDoc.data();
        if (data != null && data['bookmarks'] != null) {
          // Find the specific bookmark with bookmarkId
          final bookmarks = List<Map<String, dynamic>>.from(data['bookmarks']);
          final bookmarkData = bookmarks.firstWhere((b) => b['bookmarkId'] == bookmarkId, orElse: () => {});
          
          if (bookmarkData.isNotEmpty) {
            final bookmark = Bookmark.fromMap(bookmarkData);
            _subjects = bookmark.subjects;
            notifyListeners();
          }
        }
      }
    } catch (error) {
      print("Error fetching subjects: $error");
    }
  }
}
