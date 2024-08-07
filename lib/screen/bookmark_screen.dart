import 'package:aplikasi_ekstraksi_file_gpt4/components/bookmark_card.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/models/bookmark_model.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/bookmark_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  TextEditingController searchController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bookmarkprov = Provider.of<BookmarkProvider>(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Your Bookmark!",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge?.color),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search your Bookmark...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide(color: Color(0xFF1C88BF)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide(color: Colors.black),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide(color: Color(0xFF1C88BF)),
                ),
              ),
              onChanged: (value) {
                bookmarkprov.updateFilteredBookmarks(value);
              },
            ),
          ),
          Expanded(
            child: bookmarkprov.bookmarks.isEmpty
                ? Center(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('You don\'t have a subject yet'),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/add-bookmark');
                          },
                          child: Text("Add Your First Bookmark")),
                    ],
                  ))
                : ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    itemCount: bookmarkprov.bookmarks.length,
                    itemBuilder: (context, index) {
                      Bookmark book = bookmarkprov.bookmarks[index];
                      return buildBookmarkCard(
                        bookmark: book,
                        title: book.title,
                        author: book.author,
                        pageNumber: book.totalPages,
                        context: context,
                        bookmarkId: book.id ?? "",
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
