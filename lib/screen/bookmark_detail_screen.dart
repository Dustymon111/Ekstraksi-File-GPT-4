import 'package:aplikasi_ekstraksi_file_gpt4/models/bookmark_model.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/models/subject_model.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/global_provider.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/theme_provider.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/screen/subject_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class BookmarkDetailScreen extends StatefulWidget {
  final Bookmark bookmark;

  BookmarkDetailScreen({required this.bookmark});
  @override
  _BookmarkDetailScreenState createState() => _BookmarkDetailScreenState();
}

class _BookmarkDetailScreenState extends State<BookmarkDetailScreen> {
  // bool _isChartVisible = false;

  @override
  Widget build(BuildContext context) {
    final themeprov = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Modul/Buku'),
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
                'Penulis: ${widget.bookmark.author}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Jumlah Halaman: ${widget.bookmark.totalPages.toString()}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
           
                
              SizedBox(height: 16),
              Text("List Topik", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.bookmark.subjects.length,
                itemBuilder: (context, index) {
                  List <Subject> subjects = widget.bookmark.subjects;
                  return Card(
                    child: ListTile(
                    title: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(subjects[index].title, overflow: TextOverflow.ellipsis), 
                    ),
                    onTap: () {
                      context.read<GlobalProvider>().setSubjectIndex(index);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SubjectDetailScreen(
                              subject: subjects[index]
                            ),
                          ),
                        );
                    },
                    trailing: Text('${subjects[index].questionSets?.length} latihan'),
                  ),
                  ) ;
                  
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
