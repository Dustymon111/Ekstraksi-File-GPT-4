import 'package:aplikasi_ekstraksi_file_gpt4/components/question_card.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/models/question_model.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/theme_provider.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/utils/question_stream.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class QuestionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var themeprov = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Question List'),
        actions: [
          Switch(
            activeColor: Colors.white,
            inactiveThumbColor: Colors.indigo,
            value: themeprov.isDarkTheme, 
            onChanged: (bool value){
              themeprov.toggleTheme();
            },
          )
        ],
        
      ),
      body: StreamBuilder<List<Question>>(
        stream: QuestionStream.getQuestions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No questions available'));
          }

          List<Question> questions = snapshot.data!;
          return ListView.builder(
            itemCount: questions.length,
            itemBuilder: (context, index) {
              return buildQuestionCard(questions[index]);
            },
          );
        },
      ),
    );
  }}