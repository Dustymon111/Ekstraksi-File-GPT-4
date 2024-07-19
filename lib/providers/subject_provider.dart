import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/models/subject_model.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/models/bookmark_model.dart';

class SubjectProvider with ChangeNotifier {
  List<Subject> _subjects = [];
  List<double> _points = [];
  List<Subject> get subjects => _subjects;
  List<double> get points => _points;

  void setPoints(List<double> points) {
    _points = points;
    notifyListeners();
  }

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

  Future<void> addSubjects(String bookId, String bookmarkId, List<Subject> newSubjects) async {
  try {
    // Fetch the book document
    final bookDoc = await FirebaseFirestore.instance.collection('books').doc(bookId).get();

    if (bookDoc.exists) {
      final data = bookDoc.data();
      if (data != null && data['bookmarks'] != null) {
        // Find the specific bookmark with bookmarkId
        final bookmarks = List<Map<String, dynamic>>.from(data['bookmarks']);
        final bookmarkIndex = bookmarks.indexWhere((b) => b['bookmarkId'] == bookmarkId);
        
        if (bookmarkIndex != -1) {
          final bookmarkData = bookmarks[bookmarkIndex];

          // Add the new subjects to the subjects list
          List<Map<String, dynamic>> subjects = List<Map<String, dynamic>>.from(bookmarkData['subjects'] ?? []);
          newSubjects.forEach((subject) {
            subjects.add(subject.toMap());
          });
          bookmarkData['subjects'] = subjects;

          // Update the bookmarks list
          bookmarks[bookmarkIndex] = bookmarkData;

          // Save the updated bookmarks back to Firestore
          await FirebaseFirestore.instance.collection('books').doc(bookId).update({
            'bookmarks': bookmarks,
          });

          // Update the local state if needed
          _subjects = bookmarkData['subjects'].map<Subject>((subject) => Subject.fromMap(subject)).toList();
          notifyListeners();
        }
      }
    }
  } catch (error) {
    print("Error adding subjects: $error");
  }
}

Future<void> fetchPoints(String bookId, int bookmarkIndex, int subjectIndex) async {

  try {
    // Fetch the book document
    final bookDoc = await FirebaseFirestore.instance.collection('books').doc(bookId).get();

    if (bookDoc.exists) {
      final data = bookDoc.data();
      if (data != null && data['bookmarks'] != null) {
        final bookmarks = List<Map<String, dynamic>>.from(data['bookmarks']);
        
        // Ensure the bookmarkIndex is within bounds
        if (bookmarks.length > bookmarkIndex) {
          final bookmark = bookmarks[bookmarkIndex];
          if (bookmark['subjects'] != null) {
            final subjects = List<Map<String, dynamic>>.from(bookmark['subjects']);
            
            // Ensure the subjectIndex is within bounds
            if (subjects.length > subjectIndex) {
              final subject = subjects[subjectIndex];
              if (subject['questionSets'] != null) {
                final questionSets = List<Map<String, dynamic>>.from(subject['questionSets']);
                
                for (var questionSet in questionSets) {
                  if (questionSet.containsKey('point')) {
                    points.add(questionSet['point'].toDouble());
                  }
                }
              }
            }
          }
        }
      }
    }
  } catch (error) {
    print("Error fetching points: $error");
  }

}


}
