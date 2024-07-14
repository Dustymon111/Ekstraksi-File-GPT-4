import 'dart:async';
import 'package:aplikasi_ekstraksi_file_gpt4/models/bookmark_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BookmarkProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Bookmark> _bookmarks = []; // List of all bookmarks
  List<Bookmark> _filteredBookmarks = []; // Filtered bookmarks based on search/query

  // StreamController and Stream for exposing bookmarks
  final _bookmarksController = StreamController<List<Bookmark>>.broadcast();
  Stream<List<Bookmark>> get bookmarksStream => _bookmarksController.stream;

  // Getter for filtered bookmarks
  List<Bookmark> get filteredBookmarks => _filteredBookmarks;
  List<Bookmark> get bookmarks => _bookmarks;

  // Fetch bookmarks from a specific book document
  void fetchBookmarks(String bookId) async {
    try {
      // Fetch the existing bookmarks
      DocumentReference docRef = _firestore.collection('books').doc(bookId);
      DocumentSnapshot snapshot = await docRef.get();
      List<Bookmark> existingBookmarks = [];
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        // print(data['bookmarks']);
        existingBookmarks = (data['bookmarks'] as List<dynamic>? ?? [])
            .map((bookmark) => Bookmark.fromMap(bookmark as Map<String, dynamic>))
            .toList();
        _bookmarks = existingBookmarks;
        initiateBookmark();
      }
    } catch (e) {
      print('Error fetching bookmarks: $e');
    }
  }

  // Add bookmark to Firestore
   Future<void> addBookmark(String bookId, Bookmark bookmark) async {
    try {
      DocumentReference docRef = _firestore.collection('books').doc(bookId);
      DocumentSnapshot snapshot = await docRef.get();
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        List<dynamic> bookmarks = data['bookmarks'] ?? [];
        bookmarks.add(bookmark.toMap());
        await docRef.update({'bookmarks': bookmarks});
        fetchBookmarks(bookId); // Refresh the list after adding
      }
    } catch (e) {
      print('Error adding bookmark: $e');
    }
  }

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
    _filteredBookmarks = _bookmarks; // Assuming initial filtered is same as all bookmarks
    _notifyChanges();
  }
}
