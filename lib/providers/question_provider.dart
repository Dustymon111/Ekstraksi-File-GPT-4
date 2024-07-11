import 'package:flutter/material.dart';

class QuestionProvider extends ChangeNotifier {
  Map <int, String> _selectedOption = {}; // keep track of the selected question option

  
  Map<int, String> get selectedOption => _selectedOption;
  
  void setSelectedOption(int index, String option) {
    _selectedOption[index] = option;
    notifyListeners();
  }
}