import 'package:aplikasi_ekstraksi_file_gpt4/screen/create_topic_screen.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/screen/create_subject.dart';
import 'package:flutter/material.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Color(0xFF1C88BF),
      //   elevation: 0,
      // ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF1C88BF),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(50.0),
                ),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.school,
                            color: Color(0xFF1C88BF), size: 40),
                      ),
                      SizedBox(width: 16.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Liquiz..",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Where Knowledge Flows Freely",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
            SizedBox(height: 50),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return CreateSubject();
                }));
              },
              icon: Icon(Icons.folder_open, color: Color(0xFF1C88BF)),
              label: Text(
                "Create New Subject",
                style: TextStyle(color: Color(0xFF1C88BF), fontSize: 16),
              ),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 50.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                side: BorderSide(color: Color(0xFF1C88BF)),
              ),
            ),
            SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return CreateTopicScreen();
                }));
              },
              icon: Icon(Icons.create_new_folder, color: Color(0xFF1C88BF)),
              label: Text(
                "Create New Topics",
                style: TextStyle(color: Color(0xFF1C88BF), fontSize: 16),
              ),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 50.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                side: BorderSide(color: Color(0xFF1C88BF)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
