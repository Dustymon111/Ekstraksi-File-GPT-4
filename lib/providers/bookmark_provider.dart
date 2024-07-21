import 'dart:async';
import 'package:aplikasi_ekstraksi_file_gpt4/models/bookmark_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

  Future<void> addBookmark(String bookId, Bookmark bookmark) async {
  try {
    DocumentReference docRef = _firestore.collection('books').doc(bookId);
    DocumentSnapshot snapshot = await docRef.get();
    
    if (snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;
      List<dynamic> bookmarks = data['bookmarks'] ?? [];
      
      // Check for duplicates
      bool isDuplicate = bookmarks.any((b) {
        final existingBookmark = Bookmark.fromMap(b as Map<String, dynamic>);
        return existingBookmark.author == bookmark.author &&
               existingBookmark.totalPages == bookmark.totalPages &&
               existingBookmark.title == bookmark.title;
      });

      if (!isDuplicate) {
        bookmarks.add(bookmark.toMap());
        await docRef.update({'bookmarks': bookmarks});
        print("Bookmark Added");
        Fluttertoast.showToast(
          msg: "Book successfully uploaded",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0
        );
      } else {
        print("Bookmark already exists");
        Fluttertoast.showToast(
          msg: "Bookmark already exists",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0
        );
      }
    } else {
      // If the document does not exist, create a new document with the bookmarks array
      List<Map<String, dynamic>> bookmarks = [bookmark.toMap()];
      await docRef.set({'bookmarks': bookmarks});
      print("New Bookmark Created");
    }
    
    fetchBookmarks(bookId); // Refresh the list after adding
  } catch (e) {
    print('Error adding bookmark: $e');
     Fluttertoast.showToast(
      msg: "Error adding bookmark: $e",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0
    );
  }
}


  Future<void> updateBookUrl(String bookId, String newBookUrl, String newFilePath, int bookmarkIndex) async {
  try {
    // Reference to the specific document in the 'books' collection
    DocumentReference bookRef = FirebaseFirestore.instance.collection('books').doc(bookId);
    
    // Update only the 'bookUrl' field
    await bookRef.update({'bookUrl': newBookUrl, 'localFilePath': newFilePath});
    
    print("Book URL updated successfully");
  } catch (error) {
    print("Error updating book URL: $error");
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
