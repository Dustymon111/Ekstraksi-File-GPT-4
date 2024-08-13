import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import 'package:aplikasi_ekstraksi_file_gpt4/models/bookmark_model.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/models/subject_model.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/bookmark_provider.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/subject_provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

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
  String? difficulty;
  String? filename;
  String? subjectId;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String serverUrl =
      'https://ekstraksi-file-gpt-4-server-xzcbfs2fqq-et.a.run.app';

  List<String> selectedTopics = [];

  Future<void> postData(
      BuildContext context,
      String topic,
      String mChoiceNumber,
      String essayNumber,
      String difficulty,
      String userId,
      String filename,
      String subjectId) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LoadingAnimationWidget.prograssiveDots(
                color: Colors.blue,
                size: MediaQuery.of(context).size.width * 0.25,
              ),
              SizedBox(height: 20),
              Text(
                'Generating exercise\nThis may take some time',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );

    final url = Uri.parse('$serverUrl/question-maker');
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

    Navigator.of(context).pop();

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Exercise Generated'),
            content: Text('Check the book you want to practice with'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.popUntil(context, (route) => route.isFirst);
                  Navigator.pushNamed(context, '/home');
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(
                'Failed to generate exercise. Status code: ${response.statusCode}'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final subjectProv = Provider.of<SubjectProvider>(context);
    final bookProv = Provider.of<BookmarkProvider>(context);
    final difficulties = ['beginner', 'intermediate', 'expert'];
    final language = ['English', 'Indonesian'];

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
                    "Create Exercises Based on the Chapters in the Book",
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Customize According to the Chapters You Want!",
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                "Book",
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
                        "Choose Book",
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
                        selectedTopics
                            .clear(); // clear selected topics when book changes
                        if (selectedSubject != null) {
                          subjectProv.filterSubjectByBookId(selectedSubject!);
                          filename =
                              bookProv.findFilenameById(selectedSubject!);
                        }
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
                "Chapters Book",
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
                child: ListTile(
                  title: Text("Choose Chapters"),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        List<String> tempSelectedTopics =
                            List.from(selectedTopics);
                        return AlertDialog(
                          title: Text("Choose Chapters"),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: subjectProv.filteredSubjects
                                  .map((Subject value) {
                                return CheckboxListTile(
                                  title: Text(value.title),
                                  value: tempSelectedTopics.contains(value.id),
                                  onChanged: (bool? isSelected) {
                                    setState(() {
                                      if (isSelected == true) {
                                        tempSelectedTopics.add(value.id!);
                                      } else {
                                        tempSelectedTopics.remove(value.id);
                                      }
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text("Cancel"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text("Choose"),
                              onPressed: () {
                                setState(() {
                                  selectedTopics = tempSelectedTopics;
                                });
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              if (selectedTopics.isNotEmpty)
                Wrap(
                  spacing: 8.0,
                  children: selectedTopics.map((topicId) {
                    String topicTitle =
                        subjectProv.getSubjectTitleById(topicId);
                    return Chip(
                      label: Text(topicTitle),
                      onDeleted: () {
                        setState(() {
                          selectedTopics.remove(topicId);
                        });
                      },
                    );
                  }).toList(),
                ),
              SizedBox(height: 20),
              Text(
                "Number Of Questions",
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
              Text("Difficulties",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Wrap(
                alignment: WrapAlignment.spaceEvenly,
                children: List.generate(difficulties.length, (index) {
                  final value = difficulties[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        difficulty = value;
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Radio<String>(
                          value: value,
                          groupValue: difficulty,
                          onChanged: (selectedValue) {
                            setState(() {
                              difficulty = selectedValue;
                            });
                          },
                        ),
                        Text(
                          value[0].toUpperCase() + value.substring(1),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }),
              ),
              const SizedBox(height: 30),
              Text("Language",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Wrap(
                alignment: WrapAlignment.spaceEvenly,
                children: List.generate(language.length, (index) {
                  final value = language[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        difficulty = value;
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Radio<String>(
                          value: value,
                          groupValue: difficulty,
                          onChanged: (selectedValue) {
                            setState(() {
                              difficulty = selectedValue;
                            });
                          },
                        ),
                        Text(
                          value[0].toUpperCase() + value.substring(1),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }),
              ),
              const SizedBox(height: 30),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width *
                      0.5, // 80% of screen width
                  height: MediaQuery.of(context).size.height * 0.07,
                  child: ElevatedButton.icon(
                    onPressed: selectedSubject != null &&
                            selectedEssay != null &&
                            selectedMultipleChoice != null &&
                            selectedTopic != null &&
                            difficulty != null
                        ? () {
                            // print("Button Pressed");
                            postData(
                                context,
                                selectedTopic!,
                                selectedMultipleChoice.toString(),
                                selectedEssay.toString(),
                                difficulty!,
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
                      backgroundColor: Color(0xFF1C88BF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
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
