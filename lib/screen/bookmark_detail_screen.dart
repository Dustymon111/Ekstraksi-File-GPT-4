import 'package:aplikasi_ekstraksi_file_gpt4/models/bookmark_model.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/models/subject_model.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/global_provider.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/theme_provider.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/screen/book_details.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/screen/create_topic_screen.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/screen/topics_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class BookmarkDetailScreen extends StatefulWidget {
  final Bookmark bookmark;

  BookmarkDetailScreen({required this.bookmark});

  @override
  _BookmarkDetailScreenState createState() => _BookmarkDetailScreenState();
}

class _BookmarkDetailScreenState extends State<BookmarkDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final themeprov = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFF1C88BF),
        title: Text('Detail Modul/Buku'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.bookmark.title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Author: ${widget.bookmark.author}',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Number Of Pages: ${widget.bookmark.totalPages.toString()}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Center(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return BookDetailScreen(
                          title: widget.bookmark.title,
                          author: widget.bookmark.author,
                          totalPages: widget.bookmark.totalPages);
                    }));
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                        color: Color(0xFF1C88BF),
                        width: 2), // Border color and width
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(20), // Rounded corners
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 120), // Padding inside the button
                  ),
                  child: Text(
                    'See Details Book',
                    style: TextStyle(
                      color: Color(0xFF1C88BF), // Text color
                      fontSize: 16, // Font size
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Your Topics (${widget.bookmark.subjects.length})",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                "List of topics that you have created",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 3 / 2,
                ),
                itemCount: widget.bookmark.subjects.length + 1,
                itemBuilder: (context, index) {
                  if (index == widget.bookmark.subjects.length) {
                    return GestureDetector(
                      onTap: () {
                        // Handle create new topic
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                          border: Border.all(color: Color(0xFF1C88BF)),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 8),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                      return CreateTopicScreen();
                                    }));
                                  },
                                  child: Column(
                                    children: [
                                      Icon(Icons.add,
                                          size: 40, color: Color(0xFF1C88BF)),
                                      Text('Create New Topics',
                                          style: TextStyle(
                                              color: Color(0xFF1C88BF)))
                                    ],
                                  ))
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    List<Subject> subjects = widget.bookmark.subjects;
                    return GestureDetector(
                      onTap: () {
                        context.read<GlobalProvider>().setSubjectIndex(index);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SubjectDetailScreen(
                              subject: subjects[index],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF1C88BF),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
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
                                  subjects[index].title,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  '${subjects[index].questionSets?.length} latihan',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
