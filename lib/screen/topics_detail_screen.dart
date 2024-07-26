import 'package:aplikasi_ekstraksi_file_gpt4/components/graph_chart.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/models/question_set_model.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/global_provider.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/question_provider.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/theme_provider.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/screen/answers_screen.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/screen/question_screen.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/utils/docx_generator.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeprov = Provider.of<ThemeNotifier>(context);

    // Get the stream from the provider
    final questionSetsStream =
        context.watch<QuestionProvider>().getQuestionSetsStream(
              "book_${_auth.currentUser!.uid}", // bookmarkId
              context.watch<GlobalProvider>().bookmarkIndex,
              context.watch<GlobalProvider>().subjectIndex,
            );

    // Stream to convert questionSets to points
    Stream<List<double>> getPointsStream() {
      return questionSetsStream.map((questionSets) {
        final points = <double>[];
        questionSets.forEach((data) {
          points.add(data.point.toDouble());
        });
        return points;
      });
    }

    void _showResultDialog(BuildContext context, QuestionSet questionSet) {
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
                    'Total Questions: ${questionSet.questions.length}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Correct Answers: ${(questionSet.point / 100 * questionSet.questions.length).toInt()}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Score: ${(questionSet.point).ceil()}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
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
                                questions: questionSet.questions,
                                selectedOption: questionSet.selectedOption,
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
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Book: ${widget.subject.title}, Bab I',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Count of Exercise: ${widget.subject.questionSets?.length ?? 0}',
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
                  stream: getPointsStream(),
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
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              StreamBuilder<List<QuestionSet>>(
                stream: questionSetsStream,
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
                                'Number of Questions: ${questionSet.questions.length}',
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
                                context
                                    .read<GlobalProvider>()
                                    .setQuestionSetIndex(index);
                                if (questionSet.status == "Selesai") {
                                  _showResultDialog(context, questionSet);
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => QuestionScreen(
                                          questions: questionSet.questions),
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
            ],
          ),
        ),
      ),
    );
  }
}
