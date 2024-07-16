import 'package:aplikasi_ekstraksi_file_gpt4/components/custom_button.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/components/question_card.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/models/question_model.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/question_provider.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/theme_provider.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/screen/exercise_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  final ScrollController _scrollController = ScrollController();
  late int totalQuestions;
  Set<int> answeredQuestions = Set<int>();
  int correctAnswers = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuestionProvider>().initiateQuestion();
    });

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
          content: const Text(
            'Periksa kembali jawaban anda jika belum yakin'
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Submit'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ExerciseResultScreen(totalQuestions: totalQuestions, correctAnswers: correctAnswers)));
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


  @override
  Widget build(BuildContext context) {
    var questionprov = Provider.of<QuestionProvider>(context); 
    var themeprov = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Question List'),
        actions: [
          Switch(
            thumbIcon: themeprov.isDarkTheme? WidgetStateProperty.all(const Icon(Icons.nights_stay)) :WidgetStateProperty.all(const Icon(Icons.sunny)) ,
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
          StreamBuilder<List<Question>>(
            stream: questionprov.questionStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No questions available'));
              }
          
              List<Question> questions = snapshot.data!;
              
              return Expanded(
                child: 
                SizedBox(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: questions.length,
                    itemBuilder: (context, index) {
                      totalQuestions = questions.length;
                      return buildQuestionCard(
                        number: index + 1,
                        question: questions[index],
                        selectedOption: questionprov.selectedOption[index] ?? "",
                        onOptionChanged: (value) {
                          context.read<QuestionProvider>().setSelectedOption(index, value!);
                          if (questionprov.selectedOption[index] == questions[index].correctOption && !answeredQuestions.contains(index))  {
                            correctAnswers++;
                            answeredQuestions.add(index);
                          }else if (questionprov.selectedOption[index] != questions[index].correctOption && answeredQuestions.contains(index)){
                            correctAnswers--;
                            answeredQuestions.remove(index);
                          }else if (questionprov.selectedOption[index] == questions[index].correctOption && answeredQuestions.contains(index)){
                            correctAnswers++;
                          }
                          // print(questions[index].options);
                          // print(answeredQuestions);
                          print(correctAnswers);
                        }
                      );
                    },
                  ),
              ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomElevatedButton(label: "Submit", onPressed: (){
              _dialogBuilder(context);
            }),
          )
        ],
      ),
      
    );
  }
}
