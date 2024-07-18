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
  String bookmarkId = "book_${_auth.currentUser!.uid}";
  WidgetsBinding.instance.addPostFrameCallback((_) {
    context.read<BookmarkProvider>().fetchBookmarks(bookmarkId);
  });
  super.initState();
}

  @override
  Widget build(BuildContext context) {
    final bookmarkprov =  Provider.of<BookmarkProvider>(context);
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Search',
              ),
              onChanged: (value) {
                bookmarkprov.updateFilteredBookmarks(value);
              }
            )
          ),
          Expanded(
            child: StreamBuilder<List<Bookmark>>(
              stream: bookmarkprov.bookmarksStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No bookmarks available'));
                }
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return buildBookmarkCard(
                      bookmark: snapshot.data![index],
                      title: snapshot.data![index].title,
                      author: snapshot.data![index].author,
                      pageNumber: snapshot.data![index].pageNumber,
                      context: context,
                      bookIdx: index
                    );
                  },
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
