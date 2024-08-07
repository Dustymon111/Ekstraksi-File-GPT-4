import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/models/subject_model.dart';

class SubjectProvider with ChangeNotifier {
  List<Subject> _allSubjects = [];
  List<Subject> _filteredSubjects = [];

  List<Subject> get allSubjects => _allSubjects;
  List<Subject> get filteredSubjects => _filteredSubjects;

  Future<void> fetchAllSubjectsFromAllBooks() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collectionGroup('subjects')
          .orderBy('sortIndex')
          .get();

      _allSubjects = querySnapshot.docs.map((doc) {
        final subject = Subject.fromMap(doc.data() as Map<String, dynamic>);
        subject.id = doc.id;
        return subject;
      }).toList();
      notifyListeners();
    } catch (e) {
      print("Error fetching subjects: $e");
    }
  }

  void filterSubjectByBookId(String bookId) {
    try {
      _filteredSubjects = _allSubjects
          .where((subject) => subject.bookmarkId == bookId)
          .toList();
      notifyListeners();
    } catch (e) {
      print("Error filtering subjects for bookId $bookId: $e");
    }
  }

  Stream<List<Subject>> getSubjectsStream(String bookId) {
    return FirebaseFirestore.instance
        .collection('books')
        .doc(bookId)
        .collection('subjects')
        .orderBy('sortIndex')
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        final subject = Subject.fromMap(doc.data() as Map<String, dynamic>);
        subject.id = doc.id;
        return subject;
      }).toList();
    });
  }

  Stream<List<double>> getPointsStream(String bookId, String subjectId) {
    return FirebaseFirestore.instance
        .collection('books')
        .doc(bookId)
        .collection('subjects')
        .doc(subjectId)
        .collection('questionSets')
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return (data['point'] as num?)?.toDouble() ?? 0.0;
      }).toList();
    });
  }

  // This method can be removed or adjusted if needed
  Future<void> addSubjects(String bookId, List<Subject> newSubjects) async {
    try {
      final batch = FirebaseFirestore.instance.batch();

      for (var subject in newSubjects) {
        final subjectRef = FirebaseFirestore.instance
            .collection('books')
            .doc(bookId)
            .collection('subjects')
            .doc(); // Generate a new document ID

        batch.set(subjectRef, subject.toMap());
      }

      await batch.commit();
    } catch (error) {
      print("Error adding subjects: $error");
    }
  }
}
