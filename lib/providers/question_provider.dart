import 'dart:async';
import 'package:aplikasi_ekstraksi_file_gpt4/models/question_model.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/models/question_set_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class QuestionProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _questionSetsController =
      StreamController<List<QuestionSet>>.broadcast();
  Stream<List<QuestionSet>> get questionSetsStream =>
      _questionSetsController.stream;

  List<QuestionSet> _questionSets = [];
  List<Question> _questions = [];
  Map<int, dynamic> _selectedOption = {};
  Map<int, dynamic> _sortedSelectedOption = {};
  List<Map<String, String>> _essayAnswers = [];
  Map<int, List<String>> selectedOptionMultiple = {};

  List<QuestionSet> get questionSets => _questionSets;
  List<Question> get questions => _questions;
  Map<int, dynamic> get selectedOption => _sortedSelectedOption;
  List<Map<String, String>> get essayAnswers => _essayAnswers;

  dynamic getSelectedOption(int index) {
    return _selectedOption[index] ?? '';
  }

  void setSelectedOption(int index, dynamic option) {
    _selectedOption[index] = option;
    _sortedSelectedOption = Map.fromEntries(_selectedOption.entries.toList()
      ..sort((e1, e2) => e1.key.compareTo(e2.key)));
    notifyListeners();
  }

  void insertSelectedOptionMultiple() {
    selectedOptionMultiple.forEach((key, value) {
      _selectedOption[key] = value;
    });
    _sortedSelectedOption = Map.fromEntries(_selectedOption.entries.toList()
      ..sort((e1, e2) => e1.key.compareTo(e2.key)));
    notifyListeners();
  }

  void setSelectedOptionMultiple(int index, String option, bool value) {
    if (value) {
      selectedOptionMultiple.putIfAbsent(index, () => []).add(option);
    } else {
      selectedOptionMultiple[index]?.remove(option);
    }
    notifyListeners();
  }

  void setEssayAnswers(String index, String question, String answer) {
    _essayAnswers.add({"index": index, "question": question, "answer": answer});
    notifyListeners();
  }

  void clearSelectedOption() {
    _selectedOption.clear();
    _sortedSelectedOption.clear();
    selectedOptionMultiple.clear();
    _essayAnswers.clear();
  }

  Future<void> fetchQuestionSets(String subjectId) async {
    try {
      QuerySnapshot questionSetSnapshot = await _firestore
          .collection('question_set')
          .where('subjectId', isEqualTo: subjectId)
          .get();

      if (questionSetSnapshot.docs.isNotEmpty) {
        _questionSets.clear();

        _questionSets = await Future.wait(
            questionSetSnapshot.docs.map((questionSetDoc) async {
          final data = questionSetDoc.data() as Map<String, dynamic>;
          final questionSet = QuestionSet.fromMap(data);
          questionSet.id = questionSetDoc.id;

          // Fetch questions for each question set
          QuerySnapshot questionSnapshot =
              await questionSetDoc.reference.collection('question').get();
          _questions = questionSnapshot.docs.map((questionDoc) {
            return Question.fromMap(questionDoc.data() as Map<String, dynamic>);
          }).toList();
          return questionSet;
        }).toList());
        _notifyChanges();
      } else {
        print('No question sets found for the current subject.');
        _questionSets = [];
        _notifyChanges();
      }
    } catch (e) {
      print('Error fetching question sets: $e');
      Fluttertoast.showToast(
          msg: "Error fetching question sets: $e",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
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
        questionSet.selectedOptions = newData['selectedOption'];
        questionSet.correctAnswers = newData['correct_answers'];
        questionSet.questionCount = newData['question_count'];
        QuestionSet currentQSet =
            _questionSets.firstWhere((q) => q.id == questionSetId);
        currentQSet.status = "Selesai";

        await FirebaseFirestore.instance
            .collection('question_set')
            .doc(questionSetId)
            .update(questionSet.toMap());
      }
      _notifyChanges();
    } catch (error) {
      print("Error updating questionSet fields: $error");
    }
  }

  Stream<List<double>> getPointsStreamFromFirestore(String subjectId) {
    return FirebaseFirestore.instance
        .collection('question_set')
        .where('subjectId', isEqualTo: subjectId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return (data['point'] as num).toDouble();
      }).toList();
    });
  }

  Stream<List<QuestionSet>> getQuestionSetsStream(String subjectId) {
    return FirebaseFirestore.instance
        .collection('question_set')
        .where('subjectId', isEqualTo: subjectId)
        .snapshots()
        .asyncMap((snapshot) async {
      List<QuestionSet> questionSets = await Future.wait(
        snapshot.docs.map((doc) async {
          final data = doc.data() as Map<String, dynamic>;
          final questionSet = QuestionSet.fromMap(data);
          questionSet.id = doc.id;

          // Fetch questions for each question set
          final questionSnapshot =
              await doc.reference.collection('question').get();
          questionSet.questions = questionSnapshot.docs.map((questionDoc) {
            return Question.fromMap(questionDoc.data() as Map<String, dynamic>);
          }).toList();
          return questionSet;
        }).toList(),
      );
      return questionSets;
    });
  }

  void _notifyChanges() {
    _questionSetsController.sink.add(_questionSets);
    notifyListeners();
  }

  @override
  void dispose() {
    _questionSetsController.close();
    super.dispose();
  }
}
