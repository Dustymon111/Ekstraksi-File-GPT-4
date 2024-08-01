import 'package:aplikasi_ekstraksi_file_gpt4/models/question_set_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class QuestionProvider extends ChangeNotifier {
  Map<int, String> _selectedOption = {};
  Map<int, String> _sortedSelectedOption = {};

  Map<int, String> get selectedOption => _sortedSelectedOption;

  void setSelectedOption(int index, String option) {
    _selectedOption[index] = option;
    _sortedSelectedOption = Map.fromEntries(_selectedOption.entries.toList()
      ..sort((e1, e2) => e1.key.compareTo(e2.key)));
    notifyListeners();
  }

  // Existing methods...
  Future<int> getQuestionSetCount(List<String> questionSetIds) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('question_set')
          .where(FieldPath.documentId, whereIn: questionSetIds)
          .get();

      return querySnapshot.size;
    } catch (error) {
      print("Error fetching question set count: $error");
      return 0;
    }
  }

  Stream<List<QuestionSet>> getQuestionSetsStream(String subjectId) {
    return FirebaseFirestore.instance
        .collection('question_set')
        .where('subjectId', isEqualTo: subjectId)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return QuestionSet.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Future<void> updateQuestionSetFields(
      String questionSetId, Map<String, dynamic> newData) async {
    try {
      final questionSetDoc = await FirebaseFirestore.instance
          .collection('question_set')
          .doc(questionSetId)
          .get();

      if (questionSetDoc.exists) {
        QuestionSet questionSet =
            QuestionSet.fromMap(questionSetDoc.data() as Map<String, dynamic>);

        questionSet.point = newData['point'];
        questionSet.status = newData['status'];
        questionSet.selectedOption = newData['selectedOption'];

        await FirebaseFirestore.instance
            .collection('question_set')
            .doc(questionSetId)
            .update(questionSet.toMap());
      }
    } catch (error) {
      print("Error updating questionSet fields: $error");
    }
  }
}
