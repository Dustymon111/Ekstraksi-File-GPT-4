import 'package:aplikasi_ekstraksi_file_gpt4/components/graph_chart.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/theme_provider.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/screen/question_screen.dart';
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
  Widget build(BuildContext context) {
    final themeprov = Provider.of<ThemeNotifier>(context);
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
              CustomLineChart(yValues: [40, 50, 30]), // Adjust with real data
            SizedBox(height: 20),
            Text("List Latihan", style: TextStyle(fontSize: 20)),
            Expanded(
              child: ListView.builder(
                itemCount: widget.subject.questionSets?.length,
                itemBuilder: (context, index) {
                  final questionSet = widget.subject.questionSets?[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8.0),
                    child: ListTile(
                      title: Text('Question Set ${index + 1}'),
                      subtitle: Text('Number of Questions: ${questionSet?.questions.length}'),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => QuestionScreen(),
                        ));
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
