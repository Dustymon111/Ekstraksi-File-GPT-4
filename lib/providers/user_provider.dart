import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final String _username;
  late final String _email;

  User? get currentUser => _auth.currentUser;
  String get username => _username;
  String get email => _email;

  void setUsername(value) {
    _username = value;
  }

  void setEmail(value) {
    _email = value;
  }

  // Create or Update User
  Future<void> createOrUpdateUser(UserModel userModel) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('No user is logged in');
      }

      // Set or update user document in Firestore
      await _firestore.collection('users').doc(userId).set(userModel.toMap());
      notifyListeners(); // Notify listeners if needed
    } catch (e) {
      print('Error creating/updating user: $e');
    }
  }

  // Get User
  Future<UserModel?> getUser() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('No user is logged in');
      }

      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data()!);
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching user: $e');
      return null;
    }
  }

  // Delete User
  Future<void> deleteUser() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('No user is logged in');
      }

      // Delete user document from Firestore
      await _firestore.collection('users').doc(userId).delete();
      notifyListeners(); // Notify listeners if needed
    } catch (e) {
      print('Error deleting user: $e');
    }
  }
}
