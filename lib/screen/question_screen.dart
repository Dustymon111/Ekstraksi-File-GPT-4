import 'package:aplikasi_ekstraksi_file_gpt4/components/question_card.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/models/question_model.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/question_provider.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/theme_provider.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/utils/question_stream.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuestionScreen extends StatefulWidget {
  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  @override
  Widget build(BuildContext context) {
    var questionprov = Provider.of<QuestionProvider>(context); 
    var themeprov = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Question List'),
        actions: [
          Switch(
            activeColor: Colors.white,
            inactiveThumbColor: Colors.indigo,
            value: themeprov.isDarkTheme, 
            onChanged: (bool value) {
              themeprov.toggleTheme();
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Question>>(
        stream: QuestionStream.getQuestions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No questions available'));
          }

          List<Question> questions = snapshot.data!;
          return ListView.builder(
            itemCount: questions.length,
            itemBuilder: (context, index) {
              return buildQuestionCard(
                number: index+1,
                question: questions[index],
                selectedOption: questionprov.selectedOption[index] ?? "",
                onOptionChanged: (value) {
                  context.read<QuestionProvider>().setSelectedOption(index, value!);
                  // print(questionprov.selectedOption);
                }
                );
            },
          );
        },
      ),
    );
  }
}