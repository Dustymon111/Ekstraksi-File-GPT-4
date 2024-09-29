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
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SubjectDetailScreen extends StatefulWidget {
  final Subject subject;

  SubjectDetailScreen({required this.subject});

  @override
  _SubjectDetailScreenState createState() => _SubjectDetailScreenState();
}

class _SubjectDetailScreenState extends State<SubjectDetailScreen> {
  bool _isChartVisible = false; // State variable to manage chart visibility
  late Future<List<QuestionSet>> _futureQuestionSets;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuestionProvider>().clearSelectedOption();
    });
    _futureQuestionSets =
        context.read<QuestionProvider>().fetchQuestionSets(widget.subject.id!);
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
                      color: Colors.blueAccent,
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Total Questions: ${questions.length}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Correct Answers: ${questionSet.correctAnswers}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Score: ${(questionSet.point.toDouble())}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  Text(
                    'Duration: ${(questionSet.duration)}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(
                                  0xFF1C88BF), // Background color for "Check Answers"
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    8.0), // Rounded corners
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AnswersScreen(
                                    selectedOption: questionSet.selectedOptions,
                                    subject: widget.subject,
                                    questions: questionSet.questions,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              'Check Answers',
                              style: TextStyle(
                                color: Colors.white, // Text color
                                fontSize: 16.0, // Font size
                                fontWeight: FontWeight
                                    .w600, // Font weight for better emphasis
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                          width: 8.0), // Add some spacing between the buttons
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                  color: Color(
                                      0xFF1C88BF)), // Border color for "Export as Document"
                              padding: EdgeInsets.symmetric(vertical: 5.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    8.0), // Rounded corners
                              ),
                            ),
                            onPressed: () {
                              generateQuestionsDocx(
                                  questions,
                                  questionSet.title ??
                                      "Exercise ${questionSet.id}");
                            },
                            child: Text(
                              'Export as Document',
                              style: TextStyle(
                                color: Color(0xFF1C88BF), // Text color
                                fontSize: 16.0, // Font size
                                fontWeight: FontWeight
                                    .w500, // Font weight for better emphasis
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Chapters Details'),
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFF1C88BF),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
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
                'Description: ${widget.subject.description}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Number of Exercise(s): ${widget.subject.questionSetIds.length}',
                style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).textTheme.bodyLarge?.color),
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
                StreamBuilder<List<Map<String, dynamic>>>(
                  stream: questionProvider
                      .getPointsStreamFromFirestore(widget.subject.id!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData && snapshot.data != null) {
                      List<double> scores = snapshot.data!
                          .map((data) => data['point'] as double)
                          .toList();
                      List<String> statuses = snapshot.data!
                          .map((data) => data['status'] as String)
                          .toList();
                      List<DateTime> createdDate = snapshot.data!
                          .map((data) => data['createdAt'] as DateTime)
                          .toList();

                      return CustomLineChart(
                        yValues: scores,
                        statuses: statuses,
                        createdAt: createdDate,
                      );
                    } else {
                      return Center(child: Text('No data available'));
                    }
                  },
                ),
              SizedBox(height: 20),
              Text(
                "Exercise List",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color),
              ),
              FutureBuilder<List<QuestionSet>>(
                future:
                    _futureQuestionSets, // Ensure the correct Future is passed here
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No question sets available.'));
                  } else {
                    List<QuestionSet> questionSets = snapshot.data!;

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: questionSets.length,
                      itemBuilder: (context, index) {
                        QuestionSet questionSet = questionSets[index];
                        List<Question> questions = questionSet.questions;

                        return Card(
                          margin: const EdgeInsets.only(bottom: 8.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: Colors.blue,
                              width: 1,
                            ),
                          ),
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              title: Text(
                                questionSet.title!.isNotEmpty
                                    ? questionSet.title!
                                    : 'Question Set ${index + 1}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.ellipsis,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.color),
                                maxLines: 1,
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Number of Questions: ${questionSet.questionCount}',
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Created At: ${questionSet.createdAt != null ? DateFormat('yyyy MMMM dd').format(questionSet.createdAt!) : 'Not Available'}',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.color,
                                    ),
                                  ),
                                  Text(
                                    'Finished At: ${questionSet.finishedAt != null ? DateFormat('yyyy MMMM dd').format(questionSet.finishedAt!) : 'Not Finished'}',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.color,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Text(
                                questionSet.status == "Selesai"
                                    ? "${questionSet.point}/100"
                                    : "Not Finished",
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
                                  _showResultDialog(
                                    context,
                                    questionSets[index],
                                    questions,
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => QuestionScreen(
                                          questions: questions
                                              .where((e) =>
                                                  e.questionSetId ==
                                                  questionSet.id)
                                              .toList(),
                                          questionSetId: questionSet.id!,
                                          subject: widget.subject,
                                          questionSet: questionSet),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        );
                      },
                    );
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
                    label: "Add Exercise"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
