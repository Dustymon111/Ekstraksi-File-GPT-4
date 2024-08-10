import 'package:aplikasi_ekstraksi_file_gpt4/components/Custom_Button.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/components/graph_chart.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/models/question_model.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/models/question_set_model.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/global_provider.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/question_provider.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/screen/answers_screen.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/screen/create_topic_screen.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/screen/question_screen.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/utils/docx_generator.dart';
import 'package:flutter/material.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/models/subject_model.dart';
import 'package:provider/provider.dart';

class SubjectDetailScreen extends StatefulWidget {
  final Subject subject;

  SubjectDetailScreen({required this.subject});

  @override
  _SubjectDetailScreenState createState() => _SubjectDetailScreenState();
}

class _SubjectDetailScreenState extends State<SubjectDetailScreen> {
  bool _isChartVisible = false; // State variable to manage chart visibility

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuestionProvider>().fetchQuestionSets(widget.subject.id!);
      context.read<QuestionProvider>().clearSelectedOption();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final questionProvider = Provider.of<QuestionProvider>(context);
    // Get the stream from the provider

    void _showResultDialog(BuildContext context, QuestionSet questionSet,
        List<Question> questions) {
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Your Result',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Total Questions: ${questions.length}',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).textTheme.bodyLarge?.color),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Correct Answers: ${questionSet.correctAnswers}',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).textTheme.bodyLarge?.color),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Score: ${(questionSet.point).ceil()}',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).textTheme.bodyLarge?.color),
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(
                              0xFF1C88BF), // Background color for "Check Answers"
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AnswersScreen(
                                selectedOption: questionSet.selectedOptions,
                                subject: widget.subject,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'Check Answers',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                              color: Color(
                                  0xFF1C88BF)), // Border color for "Generate Docx"
                        ),
                        onPressed: () {
                          generateQuestionsDocx(questions);
                          print("Proses Generate Dokumen berhasil!");
                        },
                        child: Text(
                          'Generate Docx',
                          style:
                              TextStyle(color: Color(0xFF1C88BF)), // Text color
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Topik'),
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFF1C88BF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display the title and description of the subject
              Text(
                widget.subject.title,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color),
              ),
              SizedBox(height: 8),
              Text(
                'Book: ${widget.subject.title}',
                style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).textTheme.bodyLarge?.color),
              ),
              Text(
                'Count of Exercise: ${widget.subject.questionSetIds.length}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              // Toggle chart visibility
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isChartVisible = !_isChartVisible;
                  });
                },
                child: Row(
                  children: [
                    const Text(
                      'Learning Graphics',
                      style: TextStyle(fontSize: 16, color: Colors.blue),
                    ),
                    Icon(
                      _isChartVisible
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
              if (_isChartVisible)
                StreamBuilder<List<double>>(
                  stream: questionProvider
                      .getPointsStreamFromFirestore(widget.subject.id!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData && snapshot.data != null) {
                      return CustomLineChart(yValues: snapshot.data!);
                    } else {
                      return Center(child: Text('No data available'));
                    }
                  },
                ),
              SizedBox(height: 20),
              Text(
                "Question List",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color),
              ),
              StreamBuilder<List<QuestionSet>>(
                stream: questionProvider.questionSetsStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData && snapshot.data != null) {
                    final questionSets = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: questionSets.length,
                      itemBuilder: (context, index) {
                        final questionSet = questionSets[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: Colors.blue, // border color
                              width: 1, // border width
                            ),
                          ),
                          elevation: 3,
                          child: Padding(
                            padding:
                                const EdgeInsets.all(12.0), // Adjust padding
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              title: Text(
                                'Question Set ${index + 1}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                'Number of Questions: ${context.read<QuestionProvider>().questions.length}',
                              ),
                              trailing: Text(
                                questionSet.status == "Selesai"
                                    ? "${questionSet.point}/100"
                                    : "Belum Selesai",
                                style: TextStyle(
                                  color: questionSet.status == "Selesai"
                                      ? Colors.green
                                      : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onTap: () {
                                print(questionSet.questions.length);

                                context
                                    .read<GlobalProvider>()
                                    .setQuestionSetIndex(index);
                                if (questionSet.status == "Selesai") {
                                  _showResultDialog(context, questionSet,
                                      questionSet.questions);
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => QuestionScreen(
                                          questions: context
                                              .read<QuestionProvider>()
                                              .questions,
                                          questionSetId: questionSet.id!,
                                          subject: widget.subject),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(child: Text('No data available'));
                  }
                },
              ),
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.center,
                child: CustomElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CreateTopicScreen()));
                    },
                    label: "Buat Latihan Baru"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
