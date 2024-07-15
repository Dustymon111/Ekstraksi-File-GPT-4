import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String bookmarkId;
  String email;
  String nama;
  String password;
  String role;

  UserModel({
    required this.bookmarkId,
    required this.email,
    required this.nama,
    required this.password,
    required this.role,
  });

  // Factory constructor to create a UserModel object from a Firestore document
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return UserModel(
      bookmarkId: data['bookmarkId'] ?? '',
      email: data['email'] ?? '',
      nama: data['nama'] ?? '',
      password: data['password'] ?? '',
      role: data['role'] ?? '',
    );
  }

  // Method to convert a UserModel object to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'bookmarkId': bookmarkId,
      'email': email,
      'nama': nama,
      'password': password,
      'role': role,
    };
  }

  // Method to create a UserModel object from a Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      bookmarkId: map['bookmarkId'] ?? '',
      email: map['email'] ?? '',
      nama: map['nama'] ?? '',
      password: map['password'] ?? '',
      role: map['role'] ?? '',
    );
  }
}
