import 'package:aplikasi_ekstraksi_file_gpt4/models/bookmark_model.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/global_provider.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/screen/bookmark_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget buildBookmarkCard({
  required Bookmark bookmark,
  required String title,
  required String author,
  required int pageNumber, 
  required BuildContext context,
  required int bookIdx
}) {
  return Card(
    margin: EdgeInsets.all(8),
    child: Padding(
      padding: EdgeInsets.all(16),
      child: ListTile(
        title: Text(bookmark.title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Penulis: ${bookmark.author}', style: TextStyle(fontSize: 16), overflow: TextOverflow.ellipsis),
          Text('Jumlah Halaman: ${bookmark.pageNumber.toString()} halaman', style: TextStyle(fontSize: 16)),
        ],
        ),
        onTap: (){
          context.read<GlobalProvider>().setBookmarkIndex(bookIdx);
          Navigator.push(context, MaterialPageRoute(builder: (context) => BookmarkDetailScreen(bookmark: bookmark)));
        },
      ),
    ),
  );
}