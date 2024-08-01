import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/models/subject_model.dart';

class SubjectProvider with ChangeNotifier {
  Stream<List<Subject>> getSubjectsStream(String bookId) {
    return FirebaseFirestore.instance
        .collection('books')
        .doc(bookId)
        .collection('subjects')
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
