import 'package:aplikasi_ekstraksi_file_gpt4/components/custom_button.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/components/question_card.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/models/question_model.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/models/subject_model.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/question_provider.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/theme_provider.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/screen/exercise_result_screen.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/screen/topics_detail_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuestionScreen extends StatefulWidget {
  final List<Question> questions;
  final String questionSetId;
  final Subject subject;
  QuestionScreen(
      {required this.questions,
      required this.questionSetId,
      required this.subject});

  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  final ScrollController _scrollController = ScrollController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late int totalQuestions;
  int correctAnswers = 0;
  String bookmarkId = "";

  @override
  void initState() {
    bookmarkId = "book_${_auth.currentUser!.uid}";
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Submit Latihan?'),
          content: const Text('Periksa kembali jawaban anda jika belum yakin'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Submit'),
              onPressed: () async {
                int correctAnswers = 0;
                for (int i = 0; i < widget.questions.length; i++) {
                  if (widget.questions[i].correctOption ==
                      context.read<QuestionProvider>().selectedOption[i]) {
                    correctAnswers++;
                  }
                }
                final newData = {
                  "point":
                      (correctAnswers / widget.questions.length * 100).round(),
                  "status": "Selesai",
                  "selectedOption":
                      context.read<QuestionProvider>().selectedOption
                };

                // Retrieve the questionSetId from the context or the appropriate source
                String questionSetId = widget.questionSetId;

                await context
                    .read<QuestionProvider>()
                    .updateQuestionSetFields(questionSetId, newData);

                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExerciseResultScreen(
                      subject: widget.subject,
                      questions: widget.questions,
                      totalQuestions: widget.questions.length,
                      correctAnswers: correctAnswers,
                      selectedOptions:
                          context.read<QuestionProvider>().selectedOption,
                    ),
                  ),
                );
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> _onWillPop() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => SubjectDetailScreen(
                subject: widget.subject,
              )),
    );
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    var questionprov = Provider.of<QuestionProvider>(context);
    var themeprov = Provider.of<ThemeNotifier>(context);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Question List'),
          actions: [
            Switch(
              thumbIcon: themeprov.isDarkTheme
                  ? WidgetStateProperty.all(const Icon(Icons.nights_stay))
                  : WidgetStateProperty.all(const Icon(Icons.sunny)),
              activeColor: Colors.white,
              inactiveThumbColor: Colors.indigo,
              value: themeprov.isDarkTheme,
              onChanged: (bool value) {
                themeprov.toggleTheme();
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: SizedBox(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: widget.questions.length,
                  itemBuilder: (context, index) {
                    totalQuestions = widget.questions.length;
                    return buildQuestionCard(
                      number: index + 1,
                      question: widget.questions[index],
                      selectedOption: questionprov.selectedOption[index] ?? "",
                      onOptionChanged: (value) {
                        context
                            .read<QuestionProvider>()
                            .setSelectedOption(index, value!);
                      },
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomElevatedButton(
                label: "Submit",
                onPressed: () {
                  _dialogBuilder(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
