import 'dart:async';
import 'package:aplikasi_ekstraksi_file_gpt4/models/bookmark_model.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/models/subject_model.dart';
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
  void fetchBookmarks(String userId) {
    try {
      // Listen for real-time updates on books where the userId matches the current user
      _firestore
          .collection('books')
          .where('userId', isEqualTo: userId)
          .snapshots()
          .listen((QuerySnapshot bookSnapshot) {
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
      });
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

  Future<void> addBookmarkAndSubjects(
      Bookmark bookmark, List<Subject> newSubjects) async {
    try {
      // Create a WriteBatch
      WriteBatch batch = FirebaseFirestore.instance.batch();

      // Fetch books for the current user
      QuerySnapshot bookSnapshot = await FirebaseFirestore.instance
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
        DocumentReference newBookRef = FirebaseFirestore.instance
            .collection('books')
            .doc(); // Create a new document reference
        batch.set(newBookRef, bookmark.toMap());

        // Add a new document in the 'subjects' subcollection
        for (int i = 0; i < newSubjects.length; i++) {
          final subject = newSubjects[i];
          final updatedSubject = Subject(
            title: subject.title,
            description: subject.description,
            questionSetIds: subject.questionSetIds,
            bookmarkId: newBookRef.id,
            sortIndex: i, // Set sortIndex based on position
          );
          final subjectRef = newBookRef
              .collection('subjects')
              .doc(); // Generate a new document ID
          batch.set(subjectRef, updatedSubject.toMap());
        }

        // Commit the batch
        await batch.commit();

        print("Bookmark and subjects added successfully");
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
            bookmark.author.contains(query))
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
