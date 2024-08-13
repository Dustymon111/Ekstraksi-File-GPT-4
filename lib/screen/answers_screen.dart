import 'package:aplikasi_ekstraksi_file_gpt4/models/question_model.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/models/subject_model.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/question_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnswersScreen extends StatefulWidget {
  final Map<int, dynamic> selectedOption;
  final Subject subject;
  List<Question> questions;

  AnswersScreen(
      {required this.selectedOption,
      required this.subject,
      required this.questions});

  @override
  _AnswersScreenState createState() => _AnswersScreenState();
}

class _AnswersScreenState extends State<AnswersScreen> {
  final ScrollController _scrollController = ScrollController();
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    // Initialize a controller for each question
    _controllers = List.generate(widget.questions.length, (index) {
      final question = widget.questions[index];
      final selectedOption = widget.selectedOption[index];
      // final correctOption = question.correctOption;

      if (question.type == "essay") {}
      // Set initial text based on the type of question and its correctness
      final initialText = question.type == "essay"
          ? selectedOption // Initially display the selected answer
          : null;

      return TextEditingController(text: initialText);
    });
  }

  @override
  void dispose() {
    // Dispose all controllers when the widget is removed
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFF1C88BF),
        title: const Text('Hasil Akhir'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: widget.questions.length,
                itemBuilder: (context, index) {
                  final question = widget.questions[index];
                  final selectedOption = widget.selectedOption[index];
                  final correctOption = question.correctOption;
                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                      side: BorderSide(width: 3, color: Color(0xFF1C88BF)),
                    ),
                    margin: EdgeInsets.all(10),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${index + 1}. ${question.text}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 12),
                          _buildQuestionWidget(
                              question, selectedOption, correctOption, index),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionWidget(Question question, dynamic selectedOption,
      dynamic correctOption, int index) {
    switch (question.type) {
      case "m_choice":
        return Column(
          children: question.options.map((option) {
            return RadioListTile<String>(
              title: Text(style: TextStyle(color: Colors.black), option),
              value: option,
              groupValue: selectedOption ?? "",
              onChanged:
                  null, // No change handler since we're just displaying the results
              secondary: correctOption == option
                  ? Icon(Icons.check, color: Colors.green) // Correct answer
                  : selectedOption == option
                      ? Icon(Icons.close, color: Colors.red) // Incorrect answer
                      : SizedBox.shrink(),
            );
          }).toList(),
        );

      case "m_answer":
        return Column(
          children: question.options.map((option) {
            final isSelected = selectedOption?.contains(option);
            return CheckboxListTile(
              title: Text(style: TextStyle(color: Colors.black), option),
              value: isSelected ?? false,
              onChanged:
                  null, // No change handler since we're just displaying the results
              secondary: selectedOption != null
                  ? correctOption.contains(option)
                      ? Icon(Icons.check, color: Colors.green)
                      : selectedOption?.contains(option)
                          ? Icon(Icons.close,
                              color: Colors.red) // Incorrect answer
                          : SizedBox.shrink()
                  : correctOption.contains(option)
                      ? Icon(Icons.check, color: Colors.green)
                      : Icon(Icons.close, color: Colors.red),

              controlAffinity: ListTileControlAffinity.leading,
            );
          }).toList(),
        );

      case "essay":
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              enabled: false,
              controller: _controllers[index],
              decoration: InputDecoration(
                  labelText: _controllers[index].text == selectedOption
                      ? "Your Answer"
                      : "Correct Answer",
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(),
                  suffixIcon: correctOption == "correct"
                      ? Icon(Icons.check, color: Colors.green)
                      : _controllers[index].text == selectedOption
                          ? Icon(Icons.close, color: Colors.red)
                          : Icon(Icons.check, color: Colors.green)),
              maxLines: null,
              style: TextStyle(color: Colors.black),
            ),
            if (correctOption != "correct") ...[
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _controllers[index].text != selectedOption
                          ? () {
                              setState(() {
                                _controllers[index].text = selectedOption ?? "";
                              });
                            }
                          : null, // Button is disabled when text is already equal to selectedOption
                      child: Text("Your Answer"),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _controllers[index].text != correctOption
                          ? () {
                              print(correctOption);
                              setState(() {
                                _controllers[index].text = correctOption;
                              });
                            }
                          : null, // Button is disabled when text is already equal to selectedOption
                      child: Text("Correct Answer"),
                    ),
                  ),
                ],
              ),
            ],
          ],
        );

      default:
        return SizedBox
            .shrink(); // Return an empty widget for unrecognized types
    }
  }
}
