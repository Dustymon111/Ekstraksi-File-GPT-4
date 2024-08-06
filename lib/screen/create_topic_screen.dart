import 'dart:convert';

import 'package:aplikasi_ekstraksi_file_gpt4/models/bookmark_model.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/models/subject_model.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/bookmark_provider.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/subject_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class CreateTopicScreen extends StatefulWidget {
  const CreateTopicScreen({super.key});

  @override
  State<CreateTopicScreen> createState() => _CreateTopicScreenState();
}

class _CreateTopicScreenState extends State<CreateTopicScreen> {
  String? selectedSubject;
  String? selectedTopic;
  int? selectedMultipleChoice;
  int? selectedEssay;
  String? filename;
  String? subjectId;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String localhost = dotenv.env["LOCALHOST"]!;
  final String port = dotenv.env["PORT"]!;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SubjectProvider>().fetchAllSubjectsFromAllBooks();
    });
    super.initState();
  }

  Future<void> postData(
      String topic,
      String mChoiceNumber,
      String essayNumber,
      String difficulty,
      String userId,
      String filename,
      String subjectId) async {
    final url = Uri.parse('$localhost:$port/question-maker');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'topic': topic,
        'm_choice_number': mChoiceNumber,
        'essay_number': essayNumber,
        'difficulty': difficulty,
        'userId': userId,
        'filename': filename,
        'subjectId': subjectId,
      }),
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON.
      print('Response data: ${response.body}');
    } else {
      // If the server did not return a 200 OK response, throw an exception.
      print('Failed to post data. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final subjectProv = Provider.of<SubjectProvider>(context);
    final bookProv = Provider.of<BookmarkProvider>(context);
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFF1C88BF),
        elevation: 0,
        title: Text(
          'Buat Latihan',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Buat Latihan Berdasarkan Bab di dalam Buku",
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Sesuaikan dengan Bab yang kamu inginkan!",
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                "Buku",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color),
              ),
              SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF1C88BF),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    hint: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Pilih Buku",
                        style: TextStyle(
                            color:
                                Theme.of(context).textTheme.bodyLarge?.color),
                      ),
                    ),
                    value: selectedSubject,
                    isExpanded: true,
                    onChanged: (newValue) {
                      setState(() {
                        selectedSubject = newValue;
                        subjectProv.filterSubjectByBookId(selectedSubject!);
                        filename = bookProv.findFilenameById(selectedSubject!);
                      });
                    },
                    items: bookProv.bookmarks
                        .map<DropdownMenuItem<String>>((Bookmark value) {
                      return DropdownMenuItem<String>(
                        value: value.id,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(value.title,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.color)),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Topik Buku",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color),
              ),
              SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF1C88BF),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    hint: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Pilih Topik",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                    ),
                    value: selectedTopic,
                    isExpanded: true,
                    onChanged: selectedSubject == null
                        ? null
                        : (newValue) {
                            setState(() {
                              selectedTopic = newValue;
                              subjectId = selectedTopic;
                            });
                          },
                    items: subjectProv.filteredSubjects
                        .map<DropdownMenuItem<String>>((Subject value) {
                      return DropdownMenuItem<String>(
                        value: value.id,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            value.title,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Jumlah Soal",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color),
              ),
              const SizedBox(height: 12),
              Text(
                "Multiple choice",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 10.0,
                children: List.generate(7, (index) {
                  int number = (index + 1) * 5;
                  return ChoiceChip(
                    label: Text(number.toString()),
                    labelStyle: TextStyle(
                      color: selectedMultipleChoice == number
                          ? Colors.white
                          : Colors.black,
                    ),
                    selected: selectedMultipleChoice == number,
                    onSelected: (selected) {
                      setState(() {
                        selectedMultipleChoice = selected ? number : null;
                      });
                    },
                    selectedColor: Color(0xFF1C88BF),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: selectedMultipleChoice == number
                            ? Color(0xFF1C88BF)
                            : Colors.grey.shade300,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
              Text(
                "Essay",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 10.0,
                children: List.generate(5, (index) {
                  int number;
                  if (index == 0) {
                    number = 2;
                  } else if (index == 1) {
                    number = 3;
                  } else if (index == 2) {
                    number = 5;
                  } else if (index == 3) {
                    number = 8;
                  } else {
                    number = 10;
                  }
                  return ChoiceChip(
                    label: Text(number.toString()),
                    labelStyle: TextStyle(
                      color:
                          selectedEssay == number ? Colors.white : Colors.black,
                    ),
                    selected: selectedEssay == number,
                    onSelected: (selected) {
                      setState(() {
                        selectedEssay = selected ? number : null;
                      });
                    },
                    selectedColor: Color(0xFF1C88BF),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: selectedEssay == number
                            ? Color(0xFF1C88BF)
                            : Colors.grey.shade300,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton.icon(
                  onPressed: selectedSubject != null &&
                          selectedEssay != null &&
                          selectedMultipleChoice != null &&
                          selectedTopic != null
                      ? () {
                          postData(
                              selectedTopic!,
                              selectedMultipleChoice.toString(),
                              selectedEssay.toString(),
                              "intermmediate",
                              _auth.currentUser!.uid,
                              filename!,
                              subjectId!);
                        }
                      : null,
                  icon: Icon(Icons.arrow_forward, color: Colors.white),
                  label: Text(
                    "Generate",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(vertical: 17.0, horizontal: 130.0),
                    backgroundColor: Color(0xFF1C88BF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
