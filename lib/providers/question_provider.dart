// import 'package:aplikasi_ekstraksi_file_gpt4/models/question_model.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/models/bookmark_model.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/models/question_set_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class QuestionProvider extends ChangeNotifier {
  Map <int, String> _selectedOption = {}; // keep track of the selected question option
  Map <int, String> _sortedSelectedOption = {};
  List<QuestionSet> _questionsSet = [];
  // List<Question> _questions = [];

  List<QuestionSet> get questionSet => _questionsSet;


  Map<int, String> get selectedOption => _sortedSelectedOption;
  
  void setSelectedOption(int index, String option) {
    _selectedOption[index] = option;
    _sortedSelectedOption= Map.fromEntries(_selectedOption.entries.toList()..sort((e1, e2) => e1.key.compareTo(e2.key)));
    notifyListeners();
  }

  Future<void> updateQuestionSetFields(String bookId, int bookmarkIndex, int subjectIndex, int questionSetIndex, Map<String, dynamic> newData) async {
  try {
    // Fetch the book document
    final bookDoc = await FirebaseFirestore.instance.collection('books').doc(bookId).get();

    if (bookDoc.exists) {
      final data = bookDoc.data();
      if (data != null && data['bookmarks'] != null) {
        // Find the specific bookmark with bookmarkId
        final bookmarks = List<Map<String, dynamic>>.from(data['bookmarks']);
        
        if (bookmarkIndex != -1) {
          Bookmark bookmark = Bookmark.fromMap(bookmarks[bookmarkIndex]);

          // Ensure subjectIndex and questionSetIndex are within bounds
          if (subjectIndex >= 0 && subjectIndex < bookmark.subjects.length &&
              questionSetIndex >= 0 && questionSetIndex < bookmark.subjects[subjectIndex].questionSets!.length) {
            
            // Update the specific fields in the questionSet
            QuestionSet questionSet = bookmark.subjects[subjectIndex].questionSets![questionSetIndex];
            questionSet.point = newData['point'];
            questionSet.status = newData['status'];
            questionSet.selectedOption = newData['selectedOption'];

            // Update the questionSets list within the subject
            bookmark.subjects[subjectIndex].questionSets![questionSetIndex] = questionSet;

            // Update the bookmarks list
            bookmarks[bookmarkIndex] = bookmark.toMap();

            // Update the document in Firestore
            await FirebaseFirestore.instance.collection('books').doc(bookId).update({
              'bookmarks': bookmarks,
            });

            // Update local state if needed
            // _subjects = bookmark.subjects;
            // notifyListeners();
          }
        }
      }
    }
  } catch (error) {
    print("Error updating questionSet fields: $error");
  }
}


}