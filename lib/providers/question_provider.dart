import 'package:aplikasi_ekstraksi_file_gpt4/models/bookmark_model.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/models/question_set_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class QuestionProvider extends ChangeNotifier {
  Map<int, String> _selectedOption = {};
  Map<int, String> _sortedSelectedOption = {};

  Map<int, String> get selectedOption => _sortedSelectedOption;

  void setSelectedOption(int index, String option) {
    _selectedOption[index] = option;
    _sortedSelectedOption = Map.fromEntries(_selectedOption.entries.toList()..sort((e1, e2) => e1.key.compareTo(e2.key)));
    notifyListeners();
  }

  Stream<List<QuestionSet>> getQuestionSetsStream(String bookId, int bookmarkIndex, int subjectIndex) {
    return FirebaseFirestore.instance
        .collection('books')
        .doc(bookId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data();
        if (data != null && data['bookmarks'] != null) {
          final bookmarks = List<Map<String, dynamic>>.from(data['bookmarks']);
          if (bookmarkIndex != -1) {
            Bookmark bookmark = Bookmark.fromMap(bookmarks[bookmarkIndex]);
            if (subjectIndex >= 0 && subjectIndex < bookmark.subjects.length) {
              return bookmark.subjects[subjectIndex].questionSets!;
            }
          }
        }
      }
      return [];
    });
  }

  Future<void> updateQuestionSetFields(String bookId, int bookmarkIndex, int subjectIndex, int questionSetIndex, Map<String, dynamic> newData) async {
    try {
      final bookDoc = await FirebaseFirestore.instance.collection('books').doc(bookId).get();

      if (bookDoc.exists) {
        final data = bookDoc.data();
        if (data != null && data['bookmarks'] != null) {
          final bookmarks = List<Map<String, dynamic>>.from(data['bookmarks']);

          if (bookmarkIndex != -1) {
            Bookmark bookmark = Bookmark.fromMap(bookmarks[bookmarkIndex]);

            if (subjectIndex >= 0 && subjectIndex < bookmark.subjects.length &&
                questionSetIndex >= 0 && questionSetIndex < bookmark.subjects[subjectIndex].questionSets!.length) {
              
              QuestionSet questionSet = bookmark.subjects[subjectIndex].questionSets![questionSetIndex];
              questionSet.point = newData['point'];
              questionSet.status = newData['status'];
              questionSet.selectedOption = newData['selectedOption'];

              bookmark.subjects[subjectIndex].questionSets![questionSetIndex] = questionSet;
              bookmarks[bookmarkIndex] = bookmark.toMap();

              await FirebaseFirestore.instance.collection('books').doc(bookId).update({
                'bookmarks': bookmarks,
              });
            }
          }
        }
      }
    } catch (error) {
      print("Error updating questionSet fields: $error");
    }
  }
}
