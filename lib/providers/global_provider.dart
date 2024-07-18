import 'package:flutter/material.dart';

class GlobalProvider extends ChangeNotifier{
  int _subjectIndex = 0;
  int _bookmarkIndex = 0;
  int _questionSetIndex = 0;

  int get subjectIndex => _subjectIndex;
  int get bookmarkIndex => _bookmarkIndex;
  int get questionSetIndex => _questionSetIndex;

  void setSubjectIndex(int index) {
    _subjectIndex = index;
    notifyListeners();
  }

  void setBookmarkIndex(int index) {
    _bookmarkIndex = index;
    notifyListeners();
  }

  void setQuestionSetIndex(int index) {
    _questionSetIndex = index;
    notifyListeners();
  }

  void clearAllData() {
    _subjectIndex = 0;
    _bookmarkIndex = 0;
    _questionSetIndex = 0;
    notifyListeners();
  } 
}