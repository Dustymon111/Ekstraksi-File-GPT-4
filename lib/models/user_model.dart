import 'package:aplikasi_ekstraksi_file_gpt4/models/bookmark_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String email;
  String nama;
  String password;
  String role;
  List<Bookmark> bookmark;

  UserModel({
    required this.email,
    required this.nama,
    required this.password,
    required this.role,
    required this.bookmark,
  });

  // Factory constructor to create a UserModel object from a Firestore document
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return UserModel(
      email: data['email'] ?? '',
      nama: data['nama'] ?? '',
      password: data['password'] ?? '',
      role: data['role'] ?? '',
      bookmark: data['bookmark'] ?? [],
    );
  }

  // Method to convert a UserModel object to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'nama': nama,
      'password': password,
      'role': role,
      'bookmarkId': bookmark,
    };
  }

  // Method to create a UserModel object from a Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] ?? '',
      nama: map['nama'] ?? '',
      password: map['password'] ?? '',
      role: map['role'] ?? '',
      bookmark: map['bookmark'] ?? [],
    );
  }
}
