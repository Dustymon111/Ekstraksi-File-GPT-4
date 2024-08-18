import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:aplikasi_ekstraksi_file_gpt4/models/subject_model.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/subject_provider.dart';

class ChapterSelectionScreen extends StatefulWidget {
  final List<String> selectedChapters;
  final String bookId;

  const ChapterSelectionScreen({
    Key? key,
    required this.selectedChapters,
    required this.bookId,
  }) : super(key: key);

  @override
  State<ChapterSelectionScreen> createState() => _ChapterSelectionScreenState();
}

class _ChapterSelectionScreenState extends State<ChapterSelectionScreen> {
  List<String> selectedChapters = [];

  @override
  void initState() {
    super.initState();
    selectedChapters = List.from(widget.selectedChapters);
  }

  @override
  Widget build(BuildContext context) {
    final subjectProv = Provider.of<SubjectProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Chapters'),
        backgroundColor: const Color(0xFF1C88BF),
      ),
      body: ListView(
        children: subjectProv.filteredSubjects
            .where((subject) => subject.bookmarkId == widget.bookId)
            .map((subject) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: Theme.of(context).primaryColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: CheckboxListTile(
                contentPadding: const EdgeInsets.all(8.0),
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(
                  subject.title,
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge?.color),
                ),
                value: selectedChapters.contains(subject.id),
                onChanged: (isSelected) {
                  setState(() {
                    if (isSelected == true) {
                      selectedChapters.add(subject.id!);
                    } else {
                      selectedChapters.remove(subject.id);
                    }
                  });
                },
              ),
            ),
          );
        }).toList(),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Kembali tanpa menyimpan
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(selectedChapters); // Kembali dengan pilihan
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1C88BF),
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: const Text(
                'Choose',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
