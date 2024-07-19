import 'package:aplikasi_ekstraksi_file_gpt4/components/graph_chart.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/models/question_set_model.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/bookmark_provider.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/global_provider.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/question_provider.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/subject_provider.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/theme_provider.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/screen/exercise_result_screen.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/screen/question_screen.dart';
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
    final questionSetsStream = context.watch<QuestionProvider>().getQuestionSetsStream(
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

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Topik'),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
              "Deskripsi Topik:\n${widget.subject.description}",
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
                    'Grafik Pembelajaran',
                    style: TextStyle(fontSize: 16, color: Colors.blue),
                  ),
                  Icon(_isChartVisible
                      ? Icons.arrow_drop_up
                      : Icons.arrow_drop_down),
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
            Text("List Latihan", style: TextStyle(fontSize: 20)),
            Expanded(
              child: StreamBuilder<List<QuestionSet>>(
                stream: questionSetsStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData && snapshot.data != null) {

                    final questionSets = snapshot.data!;

                    return ListView.builder(
                      itemCount: questionSets.length,
                      itemBuilder: (context, index) {
                        final questionSet = questionSets[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8.0),
                          child: ListTile(
                            title: Text('Question Set ${index + 1}'),
                            subtitle: Text('Number of Questions: ${questionSet.questions.length}'),
                            trailing: questionSet.status == "Selesai" ? Text("${questionSet.point}/100") : Text("Belum Selesai"),
                            onTap: () {
                              context.read<GlobalProvider>().setQuestionSetIndex(index);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => questionSet.status == "Selesai"
                                    ? ExerciseResultScreen(
                                        totalQuestions: questionSet.questions.length,
                                        correctAnswers: (questionSet.point/100 * questionSet.questions.length).toInt(),
                                        questions: questionSet.questions,
                                        selectedOptions: questionSet.selectedOption,
                                      )
                                    : QuestionScreen(questions: questionSet.questions),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(child: Text('No data available'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
