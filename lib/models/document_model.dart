import 'dart:convert'; // For JSON encoding/decoding
import 'package:cloud_firestore/cloud_firestore.dart';

class DocumentModel {
  final String pageContent;
  final Map<String, dynamic> metadata; // Metadata as JSON object
  final List<double> embedding; // Embedding as a list of doubles

  DocumentModel({
    required this.pageContent,
    required this.metadata,
    required this.embedding,
  });

  // Convert Firestore document to DocumentModel
  factory DocumentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return DocumentModel(
      pageContent: data['pageContent'] ?? '',
      metadata: jsonDecode(data['metadata'] ?? '{}'), // Parse JSON
      embedding:
          List<double>.from(data['embedding'] ?? []), // Convert list of numbers
    );
  }

  // Convert Firestore document map to DocumentModel
  factory DocumentModel.fromMap(Map<String, dynamic> data) {
    return DocumentModel(
      pageContent: data['pageContent'] ?? '',
      metadata: jsonDecode(data['metadata'] ?? '{}'), // Parse JSON
      embedding:
          List<double>.from(data['embedding'] ?? []), // Convert list of numbers
    );
  }

  // Convert DocumentModel to Firestore document map
  Map<String, dynamic> toMap() {
    return {
      'pageContent': pageContent,
      'metadata': jsonEncode(metadata), // Convert JSON object to string
      'embedding': embedding, // Vector store as list of doubles
    };
  }
}
