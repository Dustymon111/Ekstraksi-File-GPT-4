import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/bookmark_provider.dart';

class SelectBookScreen extends StatefulWidget {
  const SelectBookScreen({Key? key}) : super(key: key);

  @override
  State<SelectBookScreen> createState() => _SelectBookScreenState();
}

class _SelectBookScreenState extends State<SelectBookScreen> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    final bookProv = Provider.of<BookmarkProvider>(context);

    // Filter buku berdasarkan query pencarian
    final filteredBooks = bookProv.bookmarks
        .where((book) => book.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Book'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Book...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  query = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredBooks.length,
              itemBuilder: (context, index) {
                final book = filteredBooks[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 6.0),
                  child: Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    shadowColor: Theme.of(context).cardColor,
                    child: ListTile(
                      title: Text(
                        book.title,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        Navigator.pop(context,
                            book.id); // Mengembalikan ID buku yang dipilih
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
} 
