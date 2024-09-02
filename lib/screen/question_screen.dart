import 'dart:convert';
import 'package:aplikasi_ekstraksi_file_gpt4/components/custom_button.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/components/essay_question_card.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/components/m_answer_question_card.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/components/m_choice_question_card.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/models/question_model.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/models/subject_model.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/bookmark_provider.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/global_provider.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/question_provider.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/theme_provider.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/user_provider.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/screen/exercise_result_screen.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';

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
  late int totalQuestions;
  int correctAnswers = 0;
  int essayCorrect = 0;
  int mChoiceCorrect = 0;
  int mAnswerCorrect = 0;
  double calculatedPoint = 0;
  final List<TextEditingController> _controllers = [];
  Map<int, List<String>> selectedCheckboxOptions = {};
  Map<int, String> essayAnswers = {};
  final String serverUrl =
      'https://ekstraksi-file-gpt-4-server-xzcbfs2fqq-et.a.run.app';
  // final String localhost = dotenv.env["LOCALHOST"]!;
  // final String port = dotenv.env["PORT"]!;

  bool areListsEqual(List<dynamic> list1, List<dynamic> list2) {
    if (list1.length != list2.length) {
      return false;
    }
    List<String> sortedList1 = List.from(list1)..sort();
    List<String> sortedList2 = List.from(list2)..sort();
    for (int i = 0; i < sortedList1.length; i++) {
      if (sortedList1[i] != sortedList2[i]) {
        return false;
      }
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    context.read<QuestionProvider>().clearSelectedOption();

    for (int i = 0; i < widget.questions.length; i++) {
      if (widget.questions[i].type == "essay") {
        // Initialize controllers for essay questions only
        _controllers.add(TextEditingController(
          text: context.read<QuestionProvider>().getSelectedOption(i),
        ));
      } else {
        _controllers.add(TextEditingController()); // To keep indexes aligned
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<dynamic> checkEssayAnswer(
      BuildContext context, // Add BuildContext to manage dialogs
      List<Map<String, String>> answers,
      String userId,
      String filename,
      String subjectId,
      String questionSetId) async {
    // Show the initial dialog with loading animation
    Stopwatch stopwatch = Stopwatch()..start();
    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevent dialog from being dismissed by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.blue,
                size: MediaQuery.of(context).size.width * 0.25,
              ),
              SizedBox(width: 20),
              Text('Checking answer...'),
            ],
          ),
        );
      },
    );

    final url = Uri.parse('$serverUrl/essay-checker');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'answers': answers,
        'userId': userId,
        'filename': filename,
        'subjectId': subjectId,
        'questionSetId': questionSetId,
      }),
    );
    stopwatch.stop();
    if (response.statusCode == 200) {
      print('Response time: ${stopwatch.elapsedMilliseconds} ms');
      log(response.body);

      // If the server returns a 200 OK response, parse the JSON.
      final responseData = jsonDecode(response.body);
      final responseContent = responseData["data"];
      Navigator.pop(context);
      return responseContent; // Return the parsed response data
    } else {
      // Show error dialog if the response status is not 200
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(
                'Failed to check answer. Status code: ${response.statusCode}'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the error dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<bool> _dialogBuilder(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Submit Exercise?',
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          content: const Text('Double-check your answer if you not sure.'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text(
                'Submit',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                for (int i = 0; i < widget.questions.length; i++) {
                  if (widget.questions[i].type == 'm_answer') {
                    if (areListsEqual(
                        widget.questions[i].correctOption,
                        context.read<QuestionProvider>().selectedOption[i] ??
                            [])) {
                      setState(() {
                        correctAnswers++;
                        mAnswerCorrect++;
                      });
                    }
                  } else {
                    if (widget.questions[i].correctOption ==
                        context.read<QuestionProvider>().selectedOption[i]) {
                      setState(() {
                        correctAnswers++;
                        mChoiceCorrect++;
                      });
                    }
                  }
                }
                String questionSetId = widget.questionSetId;
                for (int i = 0; i < widget.questions.length; i++) {
                  if (widget.questions[i].type == "essay") {
                    context.read<QuestionProvider>().setEssayAnswers(
                        i.toString(),
                        widget.questions[i].text,
                        context.read<QuestionProvider>().selectedOption[i] ??
                            "");
                  }
                }
                String? bookmarkId = context.read<GlobalProvider>().bookmarkId;
                String? filename = context
                    .read<BookmarkProvider>()
                    .findFilenameById(bookmarkId);
                try {
                  final res = await checkEssayAnswer(
                      context,
                      context.read<QuestionProvider>().essayAnswers,
                      context.read<UserProvider>().userId,
                      filename!,
                      widget.subject.id!,
                      questionSetId);
                  setState(() {
                    correctAnswers += res['correct_answers'] as int;
                    essayCorrect += res['correct_answers'] as int;
                  });
                } catch (e) {
                  Navigator.pop(context);
                  Fluttertoast.showToast(
                      msg: "Error Submitting Exercise, Please try again.",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0);
                }
                print("mChoice correct: $mChoiceCorrect");
                print("mAnswer correct: $mAnswerCorrect");
                print("essay correct: $essayCorrect");
                print("correct answer count :$correctAnswers");

                setState(() {
                  calculatedPoint = context
                      .read<QuestionProvider>()
                      .calculatePoints(
                          questions: widget.questions,
                          mChoiceCorrect: mChoiceCorrect,
                          mAnswerCorrect: mAnswerCorrect,
                          essayCorrect: essayCorrect);
                });

                final newData = {
                  "point": calculatedPoint.round().toInt(),
                  "status": "Selesai",
                  "selectedOption":
                      context.read<QuestionProvider>().selectedOption,
                  "correct_answers": correctAnswers,
                  "question_count": widget.questions.length
                };

                await context
                    .read<QuestionProvider>()
                    .updateQuestionSetFields(questionSetId, newData);

                await context
                    .read<QuestionProvider>()
                    .fetchQuestions(questionSetId);

                Navigator.pop(
                    context, true); // Close the dialog and return true
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.pop(
                    context, false); // Close the dialog and return false
              },
            ),
          ],
        );
      },
    ).then((value) => value ?? false); // Ensure a bool is returned
  }

  Future<bool> _showExitDialog(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Are you sure you want to exit?'),
              content:
                  Text('If you leave, all your answered question will reset'),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      child: Text(style: TextStyle(color: Colors.red), 'Leave'),
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                    ),
                    TextButton(
                      child: Text('Cancel'),
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                    ),
                  ],
                )
              ],
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    var themeprov = Provider.of<ThemeNotifier>(context);
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        final bool shouldPop = await _showExitDialog(context);
        if (context.mounted && shouldPop) {
          context.read<QuestionProvider>().clearSelectedOption();

          Navigator.pop(context, widget.subject);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Question List'),
          backgroundColor: Color(0xFF1C88BF),
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
                    Question question = widget.questions[index];
                    totalQuestions = widget.questions.length;
                    switch (question.type) {
                      case 'm_choice':
                        return MultipleChoiceQuestionCard(
                          number: index + 1,
                          question: question,
                          selectedOption: context
                                  .watch<QuestionProvider>()
                                  .selectedOption[index] ??
                              '',
                          onOptionChanged: (value) {
                            context
                                .read<QuestionProvider>()
                                .setSelectedOption(index, value!);
                            context
                                .read<QuestionProvider>()
                                .insertSelectedOptionMultiple();
                          },
                        );
                      case 'm_answer':
                        return MultipleAnswerQuestionCard(
                          number: index + 1,
                          question: question,
                          selectedOptions: context
                                  .watch<QuestionProvider>()
                                  .selectedOptionMultiple[index] ??
                              [],
                          onCheckboxChanged: (bool? value, String option) {
                            context
                                .read<QuestionProvider>()
                                .setSelectedOptionMultiple(
                                    index, option, value!);
                            context
                                .read<QuestionProvider>()
                                .insertSelectedOptionMultiple();
                          },
                        );
                      case 'essay':
                        return EssayQuestionCard(
                          number: index + 1,
                          question: question,
                          controller: _controllers[index],
                          onEssayChanged: (value) {
                            context
                                .read<QuestionProvider>()
                                .setSelectedOption(index, value);
                          },
                        );
                      default:
                        return SizedBox.shrink(); // Handle any other cases
                    }
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomElevatedButton(
                label: "Submit",
                onPressed: () async {
                  bool shouldNavigate = await _dialogBuilder(context);
                  if (shouldNavigate) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExerciseResultScreen(
                            subject: widget.subject,
                            questions:
                                context.read<QuestionProvider>().questions,
                            totalQuestions: widget.questions.length,
                            correctAnswers: correctAnswers,
                            selectedOptions:
                                context.read<QuestionProvider>().selectedOption,
                            score: calculatedPoint.roundToDouble()),
                      ),
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
