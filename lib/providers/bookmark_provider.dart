import 'dart:async';
import 'package:aplikasi_ekstraksi_file_gpt4/models/bookmark_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BookmarkProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Bookmark> _bookmarks = []; // List of all bookmarks
  List<Bookmark> _filteredBookmarks =
      []; // Filtered bookmarks based on search/query

  // StreamController and Stream for exposing bookmarks
  final _bookmarksController = StreamController<List<Bookmark>>.broadcast();
  Stream<List<Bookmark>> get bookmarksStream => _bookmarksController.stream;

  // Getter for filtered bookmarks
  List<Bookmark> get filteredBookmarks => _filteredBookmarks;
  List<Bookmark> get bookmarks => _bookmarks;

  // Fetch bookmarks from a specific book document
  Future<void> fetchBookmarks(String userId) async {
    try {
      // Fetch the books where the userId matches the current user
      QuerySnapshot bookSnapshot = await _firestore
          .collection('books')
          .where('userId', isEqualTo: userId)
          .get();

      if (bookSnapshot.docs.isNotEmpty) {
        // Clear the existing bookmarks
        _bookmarks.clear();

        // Map each document to a Bookmark object
        _bookmarks = bookSnapshot.docs.map((bookDoc) {
          final data = bookDoc.data() as Map<String, dynamic>;
          final bookmark = Bookmark.fromMap(data);
          bookmark.id = bookDoc.id;
          return bookmark;
        }).toList();

        // Notify listeners about changes
        initiateBookmark();
      } else {
        print('No book found for the current user.');
        _bookmarks = [];
        _notifyChanges();
      }
    } catch (e) {
      print('Error fetching bookmarks: $e');
      Fluttertoast.showToast(
          msg: "Error fetching bookmarks: $e",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<void> addBookmark(Bookmark bookmark) async {
    try {
      // Fetch books for the current user
      QuerySnapshot bookSnapshot = await _firestore
          .collection('books')
          .where('userId', isEqualTo: bookmark.userId)
          .get();

      // Check for duplicates
      bool isDuplicate = bookSnapshot.docs.any((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final existingBookmark = Bookmark.fromMap(data);
        return existingBookmark.title == bookmark.title &&
            existingBookmark.author == bookmark.author;
      });

      if (!isDuplicate) {
        // Add the new book as a new document in the 'books' collection
        await _firestore.collection('books').add(bookmark.toMap());
        print("Bookmark Added");
        Fluttertoast.showToast(
            msg: "Book successfully uploaded",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        print("Bookmark already exists");
        Fluttertoast.showToast(
            msg: "Bookmark already exists",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
      }

      // Refresh the list after adding
      fetchBookmarks(bookmark.userId);
    } catch (e) {
      print('Error adding bookmark: $e');
      Fluttertoast.showToast(
          msg: "Error adding bookmark: $e",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  // Function to update filtered bookmarks based on search/query
  void updateFilteredBookmarks(String query) {
    _filteredBookmarks = _bookmarks
        .where((bookmark) =>
            bookmark.title.toLowerCase().contains(query.toLowerCase()) ||
            bookmark.author.toLowerCase().contains(query.toLowerCase()))
        .toList();
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
    _filteredBookmarks =
        _bookmarks; // Assuming initial filtered is same as all bookmarks
    _notifyChanges();
  }
}
