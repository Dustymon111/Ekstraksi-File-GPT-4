import 'package:flutter/material.dart';

class GlobalProvider extends ChangeNotifier {
  int _subjectIndex = 0;
  String _bookmarkId = "";
  int _questionSetIndex = 0;

  int get subjectIndex => _subjectIndex;
  String get bookmarkId => _bookmarkId;
  int get questionSetIndex => _questionSetIndex;

  void setSubjectIndex(int index) {
    _subjectIndex = index;
    notifyListeners();
  }

  void setBookmarkId(String id) {
    _bookmarkId = id;
    notifyListeners();
  }

  void setQuestionSetIndex(int index) {
    _questionSetIndex = index;
    notifyListeners();
  }

  void clearAllData() {
    _subjectIndex = 0;
    _bookmarkId = "";
    _questionSetIndex = 0;
    notifyListeners();
  }
}
