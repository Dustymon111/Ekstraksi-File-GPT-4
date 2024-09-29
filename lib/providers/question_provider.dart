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

  List<String> typePriority = ['m_choice', 'm_answer', 'essay'];

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

  Future<List<QuestionSet>> fetchQuestionSets(String subjectId) async {
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

            QuerySnapshot questionSnapshot =
                await questionSetDoc.reference.collection('question').get();

            questionSet.questions = questionSnapshot.docs.map((questionDoc) {
              return Question.fromMap(
                  questionDoc.data() as Map<String, dynamic>);
            }).toList();

            questionSet.questions.sort((a, b) {
              return typePriority
                  .indexOf(a.type)
                  .compareTo(typePriority.indexOf(b.type));
            });

            return questionSet;
          }).toList(),
        );

        _questionSets.sort((a, b) {
          final dateA = _parseDate(a.createdAt);
          final dateB = _parseDate(b.createdAt);

          // Compare dates, with null dates treated as the oldest
          if (dateA != null && dateB != null) {
            return dateA.compareTo(dateB); // Sort by latest date first
          } else if (dateA == null && dateB != null) {
            return 1; // Treat null dates as older
          } else if (dateA != null && dateB == null) {
            return -1;
          } else {
            return 0; // Both dates are null
          }
        });

        _notifyChanges();
        return _questionSets;
      } else {
        print('No question sets found for the current subject.');
        _questionSets = [];
        _notifyChanges();
        return _questionSets;
      }
    } catch (e) {
      print('Error fetching question sets: $e');
      Fluttertoast.showToast(
        msg: "Error fetching question sets: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      return [];
    }
  }

  Future<void> fetchQuestions(String questionSetId) async {
    try {
      // Reference to the 'question' collection inside a specific 'questionSets' document
      CollectionReference questionCollection = _firestore
          .collection('question_set')
          .doc(questionSetId)
          .collection('question');

      // Fetch the documents from the 'question' collection
      QuerySnapshot querySnapshot = await questionCollection.get();

      // Map each document into a list of maps
      _questions = querySnapshot.docs.map((doc) {
        return Question.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
      questions.sort((a, b) {
        return typePriority
            .indexOf(a.type)
            .compareTo(typePriority.indexOf(b.type));
      });
    } catch (e) {
      // Handle any errors that occur during fetching
      print('Error fetching questions: $e');
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

  Stream<List<Map<String, dynamic>>> getPointsStreamFromFirestore(
      String subjectId) {
    return FirebaseFirestore.instance
        .collection('question_set')
        .where('subjectId', isEqualTo: subjectId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        // Check if 'createdAt' is a String or Timestamp and handle accordingly
        DateTime createdAt;
        if (data['createdAt'] is Timestamp) {
          createdAt = (data['createdAt'] as Timestamp).toDate();
        } else if (data['createdAt'] is String) {
          createdAt = DateTime.parse(data['createdAt']);
        } else {
          createdAt = DateTime
              .now(); // Default to current time if no valid date is found
        }
        return {
          'point': (data['point'] as num).toDouble(),
          'status': data['status'] as String, // Assuming status is a String
          'createdAt': createdAt
        };
      }).toList();
    });
  }

  double calculatePoints({
    required List<Question> questions,
    double essayMultiplier = 2.5,
    double multipleAnswerMultiplier = 1.5,
    double totalPoints = 100,
    required int essayCorrect,
    required int mAnswerCorrect,
    required int mChoiceCorrect,
  }) {
    // Initialize counts
    int essayCount = 0;
    int multipleAnswerCount = 0;
    int multipleChoiceCount = 0;

    // Count the number of each question type
    for (var q in questions) {
      if (q.type == 'm_answer') multipleAnswerCount++;
      if (q.type == 'm_choice') multipleChoiceCount++;
      if (q.type == 'essay') essayCount++;
    }

    // Ensure there are questions to avoid division by zero
    if (essayCount == 0 &&
        multipleAnswerCount == 0 &&
        multipleChoiceCount == 0) {
      print("No questions available.");
      return 0;
    }

    print("Essay Count : $essayCount");
    print("multipleAnswer Count : $multipleAnswerCount");
    print("multipleChoice Count : $multipleChoiceCount");

    // Calculate z (points for each multiple choice question)
    double z = totalPoints /
        (essayCount * essayMultiplier +
            multipleAnswerCount * multipleAnswerMultiplier +
            multipleChoiceCount);

    // Calculate x (points for each essay question) and y (points for each multiple answer question)
    double x = essayMultiplier * z;
    double y = multipleAnswerMultiplier * z;

    print("Before Normalization");
    print("x: $x");
    print("y: $y");
    print("z: $z");

    // Calculate the total calculated points
    double totalCalculatedPoints =
        essayCount * x + multipleAnswerCount * y + multipleChoiceCount * z;

    // Normalize if necessary
    if (totalCalculatedPoints != totalPoints) {
      double normalizationFactor = totalPoints / totalCalculatedPoints;
      x *= normalizationFactor;
      y *= normalizationFactor;
      z *= normalizationFactor;
    }

    print("After Normalization");
    print("x: $x");
    print("y: $y");
    print("z: $z");

    // Calculate the total points based on the correct answers
    double pointCalculation =
        (essayCorrect * x) + (mAnswerCorrect * y) + (mChoiceCorrect * z);
    print("Total Points: $pointCalculation");
    return pointCalculation;
  }

  // Helper function to parse date
  DateTime? _parseDate(dynamic createdAt) {
    if (createdAt == null) return null;

    if (createdAt is String) {
      try {
        return DateTime.parse(_convertDateFormat(createdAt));
      } catch (e) {
        print("Error parsing date: $e");
        return null;
      }
    } else if (createdAt is DateTime) {
      return createdAt; // If it's already a DateTime, return it directly
    } else {
      return null;
    }
  }

  String _convertDateFormat(String dateStr) {
    // Assuming dateStr is in "YYYY MMMM dd" format like "2024 August 19"
    final dateParts = dateStr.split(' ');
    final year = dateParts[0];
    final month = dateParts[1];
    final day = dateParts[2];

    final monthNumber = _getMonthNumber(month);
    return "$year-${monthNumber.toString().padLeft(2, '0')}-$day";
  }

  int _getMonthNumber(String month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months.indexOf(month) + 1;
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
