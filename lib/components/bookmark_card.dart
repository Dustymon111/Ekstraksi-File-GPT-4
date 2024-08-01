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
  required String bookmarkId,
}) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: BorderSide(color: Color(0xFF1C88BF)),
    ),
    margin: EdgeInsets.symmetric(vertical: 8),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          bookmark.title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Author: ${bookmark.author}',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              'Number Of Pages: ${bookmark.totalPages.toString()} Pages',
              style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).textTheme.bodyLarge?.color),
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            print("Item telah dihapus!");
          },
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookmarkDetailScreen(
                  bookmarkId: bookmarkId, bookmark: bookmark),
            ),
          );
        },
      ),
    ),
  );
}
