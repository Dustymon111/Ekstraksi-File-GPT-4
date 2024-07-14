import 'package:aplikasi_ekstraksi_file_gpt4/components/bookmark_card.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/models/bookmark_model.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/bookmark_provider.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/utils/page_animation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/theme_provider.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  TextEditingController searchController = TextEditingController();

  @override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    context.read<BookmarkProvider>().fetchBookmarks('book1');
  });
}

  @override
  Widget build(BuildContext context) {
    final themeprov = Provider.of<ThemeNotifier>(context);
    final bookmarkprov =  Provider.of<BookmarkProvider>(context);
    final theme = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
        title: const Text("Bookmark"),
        actions: [
           IconButton(
            icon: const Icon(Icons.home_work),
            onPressed: (){
              Navigator.pushNamed(context, '/questions');
            }
          ),
          Switch(
            thumbIcon: themeprov.isDarkTheme? WidgetStateProperty.all(const Icon(Icons.nights_stay)) :WidgetStateProperty.all(const Icon(Icons.sunny)) ,
            activeColor: Colors.white,
            inactiveThumbColor: Colors.indigo,
            value: themeprov.isDarkTheme, 
            onChanged: (bool value){
              themeprov.toggleTheme();
            },
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
            icon: const Icon(Icons.home),
            onPressed: (){
              Navigator.of(context).pushReplacement(bookmarkHomeRoute());

            }
          ),
          IconButton(
            icon: const Icon(Icons.book_outlined),
            onPressed: (){},
            color: theme.colorScheme.primary,
          ),
          ]
        ,),
      ),
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
