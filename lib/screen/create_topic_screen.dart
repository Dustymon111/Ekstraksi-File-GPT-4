import 'dart:convert';
import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
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
  List<String> selectedTopic = [];
  int? selectedMultipleChoice;
  int? selectedEssay;
  String? difficulty;
  String? filename;
  String? subjectId;
  String? language;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String serverUrl =
      'https://ekstraksi-file-gpt-4-server-xzcbfs2fqq-et.a.run.app';
  // final String localhost = dotenv.env["LOCALHOST"]!;
  // final String port = dotenv.env["PORT"]!;
  List<String> selectedTopicsId = [];

  Future<void> postData(
      BuildContext context,
      List<String> topics,
      String mChoiceNumber,
      String essayNumber,
      String? difficulty,
      String userId,
      String filename,
      String subjectId,
      String bookId,
      String? language) async {
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
        'topics': topics,
        'm_choice_number': mChoiceNumber,
        'essay_number': essayNumber,
        'difficulty': difficulty ?? "Combined",
        'userId': userId,
        'filename': filename,
        'subjectId': subjectId,
        'bookId': bookId,
        'language': language ?? "Book's Original Language"
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
  void initState() {
    context.read<SubjectProvider>().fetchAllSubjectsFromAllBooks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final subjectProv = Provider.of<SubjectProvider>(context);
    final bookProv = Provider.of<BookmarkProvider>(context);
    final difficulties = ['beginner', 'intermediate', 'expert'];
    final languages = ['English', 'Indonesian'];

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
                        selectedTopicsId
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
                "Chapters",
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
                  onTap: () async {
                    List<String> tempSelectedTopicsId =
                        List.from(selectedTopicsId);
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter setState) {
                            return AlertDialog(
                              title: Text("Choose Chapters"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "If you choose more than one topic, it will be added to the custom topic instead.",
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  SizedBox(
                                      height:
                                          16), // Add some space between the subtitle and the list
                                  SingleChildScrollView(
                                    child: ListBody(
                                      children: subjectProv.filteredSubjects
                                          .where((Subject value) =>
                                              value.title != "Custom Topic")
                                          .map((Subject value) {
                                        return CheckboxListTile(
                                          title: Text(value.title),
                                          value: tempSelectedTopicsId
                                              .contains(value.id),
                                          onChanged: (bool? isSelected) {
                                            setState(() {
                                              if (isSelected == true) {
                                                tempSelectedTopicsId
                                                    .add(value.id!);
                                                selectedTopic.add(value.title);
                                              } else {
                                                tempSelectedTopicsId
                                                    .remove(value.id);
                                                selectedTopic
                                                    .remove(value.title);
                                              }
                                              print(selectedTopic);
                                            });
                                          },
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
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
                                    Navigator.of(context)
                                        .pop(tempSelectedTopicsId);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ).then((selectedTopicsIdResult) {
                      if (selectedTopicsIdResult != null) {
                        setState(() {
                          selectedTopicsId = selectedTopicsIdResult;
                          subjectId = selectedTopicsId[0];
                          print(subjectId);
                        });
                      }
                    });
                  },
                ),
              ),
              SizedBox(height: 20),
              if (selectedTopicsId.isNotEmpty)
                Wrap(
                  spacing: 8.0,
                  children: selectedTopicsId.map((topicId) {
                    String topicTitle =
                        subjectProv.getSubjectTitleById(topicId);
                    return Chip(
                      label: Text(topicTitle),
                      onDeleted: () {
                        setState(() {
                          selectedTopicsId.remove(topicId);
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
              Text("Difficulties (Optional)",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text("Default is combined of the three difficulties",
                  style: TextStyle(fontSize: 14)),
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
              Text("Language (optional)",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text("Default is the book original language",
                  style: TextStyle(fontSize: 14)),
              Wrap(
                alignment: WrapAlignment.spaceEvenly,
                children: List.generate(languages.length, (index) {
                  final value = languages[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        language = value;
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Radio<String>(
                          value: value,
                          groupValue: language,
                          onChanged: (selectedValue) {
                            setState(() {
                              language = selectedValue!;
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
                            selectedTopic.isNotEmpty
                        ? () {
                            // print("Button Pressed");
                            postData(
                                context,
                                selectedTopic,
                                selectedMultipleChoice.toString(),
                                selectedEssay.toString(),
                                difficulty ?? "Combined",
                                _auth.currentUser!.uid,
                                filename!,
                                subjectId!,
                                selectedSubject!,
                                language ?? "Book's Original Language");
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
