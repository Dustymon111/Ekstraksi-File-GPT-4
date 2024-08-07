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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).appBarTheme.backgroundColor,
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
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Examqz..",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Pengetahuan Mengalir Bebas dengan Latihan",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
            SizedBox(height: 80),
            // Updated Button Design for "Ekstrak Buku"
            _buildActionButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => CreateSubject()));
              },
              icon: Icons.folder_open,
              label: "Extract New Book",
            ),
            SizedBox(height: 30),
            // Updated Button Design for "Buat Latihan Baru"
            _buildActionButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return CreateTopicScreen();
                }));
              },
              icon: Icons.library_add,
              label: "Create New Exercise",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 30.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          side: BorderSide(color: Color(0xFF1C88BF)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Color(0xFF1C88BF), size: 30), //
            SizedBox(height: 8.0),
            Text(
              label,
              style: TextStyle(color: Color(0xFF1C88BF), fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
