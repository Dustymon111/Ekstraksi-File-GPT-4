import 'package:aplikasi_ekstraksi_file_gpt4/screen/book_details.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/screen/topics_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/models/bookmark_model.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/models/subject_model.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/subject_provider.dart';
import 'package:provider/provider.dart';

class BookmarkDetailScreen extends StatelessWidget {
  final String bookmarkId;
  final Bookmark bookmark;

  BookmarkDetailScreen({required this.bookmarkId, required this.bookmark});

  @override
  Widget build(BuildContext context) {
    final subjectProvider = Provider.of<SubjectProvider>(context);
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFF1C88BF),
        title: Text('Extracted Book Pages'),
      ),
      body: StreamBuilder<List<Subject>>(
        stream: subjectProvider.getSubjectsStream(bookmarkId),
        builder: (context, snapshot) {
          List<Subject> subjects = snapshot.data ?? [];

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bookmark details
                  Text(
                    bookmark.title,
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge?.color),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Author(s): ${bookmark.author.join(', ')}',
                    style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).textTheme.bodyLarge?.color),
                  ),
                  Text(
                    'Number Of Pages: ${bookmark.totalPages.toString()}',
                    style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).textTheme.bodyLarge?.color),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => BookDetailScreen(
                                title: bookmark.title,
                                author: bookmark.author.join(', '),
                                totalPages: bookmark.totalPages,
                                subjects: subjects)));
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Color(0xFF1C88BF), width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      ),
                      child: Text(
                        'Book details',
                        style:
                            TextStyle(color: Color(0xFF1C88BF), fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Chapters In Your Book (${subjects.length})",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge?.color),
                  ),
                  Text(
                    "List of chapters that you have extracted",
                    style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).textTheme.bodyLarge?.color),
                  ),
                  SizedBox(height: 12),
                  if (snapshot.connectionState == ConnectionState.waiting)
                    Center(child: CircularProgressIndicator())
                  else if (snapshot.hasError)
                    Center(child: Text('Error: ${snapshot.error}'))
                  else
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 3 / 2,
                      ),
                      itemCount: subjects.length,
                      itemBuilder: (context, index) {
                        Subject subject = subjects[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SubjectDetailScreen(subject: subject),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.background,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).shadowColor,
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      subject.title,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      '${subject.questionSetIds.length} Exercise(s)',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
