import 'package:aplikasi_ekstraksi_file_gpt4/screen/home_screen.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthStateListener extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Check if the snapshot has data (user is logged in)
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;

          if (user == null) {
            // If the user is not logged in, navigate to the login page
            return SplashScreen();
          } else {
            // If the user is logged in, navigate to the home page
            return Home();
          }
        } else {
          // Show a loading spinner while checking the authentication state
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
