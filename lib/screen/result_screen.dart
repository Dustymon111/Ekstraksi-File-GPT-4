import 'package:aplikasi_ekstraksi_file_gpt4/components/question_card.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/models/question_model.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/question_provider.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResultScreen extends StatefulWidget {
  final Map<int, String> selectedOption;

  const ResultScreen({super.key, required this.selectedOption});

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final ScrollController _scrollController = ScrollController();

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


  @override
  Widget build(BuildContext context) {
    var questionprov = Provider.of<QuestionProvider>(context); 
    var themeprov = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Akhir'),
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
                    return Card(
                      margin: EdgeInsets.all(8),
                      child: Padding(
                        padding: EdgeInsets.all(16),  
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('${index+1}. ${questions[index].text}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            SizedBox(height: 12),
                            Column(
                              children: questions[index].options.map((option) {
                                return RadioListTile<String>(
                                  title: Text(option),
                                  value: option,
                                  groupValue: widget.selectedOption[index] ?? "", // Provide the selected answer here if implementing selection logic
                                  onChanged: (value){}, // Handling the selected option
                                  secondary: questions[index].correctOption == option
                                    ? Icon(Icons.check) // Correct answer selected
                                    : widget.selectedOption[index] == option // Check if an option is selected
                                        ? Icon(Icons.close) // Incorrect answer selected
                                        : SizedBox.shrink(), // Render nothing for unselected options,
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    );
                    },
                  ),
              ),
              );
            },
          ),
        ],
      ),
      
    );
  }
}
