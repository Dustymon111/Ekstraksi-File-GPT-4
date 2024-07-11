import 'dart:async';
import 'package:aplikasi_ekstraksi_file_gpt4/models/bookmark_model.dart';
import 'package:flutter/material.dart';

class BookmarkProvider extends ChangeNotifier {
  List<Bookmark> _bookmarks =  [
      Bookmark(
        title: 'What is your favorite color?',
        author: 'Mr.A',
        pageNumber: 100 
      ),
      Bookmark(
        title: 'Artificial Intelligence',
        author: 'Mr.B',
        pageNumber: 50
      ),
      // Add more questions as needed
    ];// List of all bookmarks
  List<Bookmark> _filteredBookmarks = []; // Filtered bookmarks based on search/query

  // StreamController and Stream for exposing bookmarks
  final _bookmarksController = StreamController<List<Bookmark>>.broadcast();
  Stream<List<Bookmark>> get bookmarksStream => _bookmarksController.stream;

  // Getter for filtered bookmarks
  List<Bookmark> get filteredBookmarks => _filteredBookmarks;
  List<Bookmark> get bookmarks => _bookmarks;
  
  // Function to add bookmarks
  void addBookmark(Bookmark bookmark) {
    _bookmarks.add(bookmark);
    initiateBookmark();
    _notifyChanges();
  }

  // Function to fetch bookmarks (replace with actual data fetch logic)
  // void fetchBookmarks() {
  //   // Replace with your actual logic to fetch bookmarks (e.g., from a database or API)
  //   // Example:
  //   _bookmarks = [
  //     Bookmark(
  //       title: 'What is your favorite color?',
  //       author: 'Mr.A',
  //       pageNumber: 100
  //     ),
  //     Bookmark(
  //       title: 'Artificial Intelligence',
  //       author: 'Mr.B',
  //       pageNumber: 50
  //     ),
  //     // Add more questions as needed
  //   ];
  //   _updateFilteredBookmarks();
  //   _notifyChanges();
  // }

  // Function to update filtered bookmarks based on search/query
  void updateFilteredBookmarks(String query) {
    _filteredBookmarks = _bookmarks.where((bookmark) =>
        bookmark.title.toLowerCase().contains(query.toLowerCase()) ||
        bookmark.author.toLowerCase().contains(query.toLowerCase())).toList();
    _notifyChanges();
  }

  // Internal method to notify listeners
  void _notifyChanges() {
    _bookmarksController.sink.add(_filteredBookmarks);
    notifyListeners();
  }

  // Dispose method to close StreamController
  @override
  void dispose() {
    _bookmarksController.close();
    super.dispose();
  }

  // Utility method to update filtered bookmarks
  void initiateBookmark() {
    _filteredBookmarks = List.from(_bookmarks); // Assuming initial filtered is same as all bookmarks
    _notifyChanges();
  }
}