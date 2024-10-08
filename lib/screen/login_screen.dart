import 'package:aplikasi_ekstraksi_file_gpt4/providers/bookmark_provider.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Ensure you have Firebase Auth set up
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1C88BF),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome Back",
              style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(
              height: 25,
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(20.0)),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(20.0)),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24.0),
            Container(
              width: double
                  .infinity, // Set lebar button sama dengan lebar input decoration
              margin: const EdgeInsets.symmetric(
                  vertical: 16.0), // Margin top dan bottom
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shadowColor: Color.fromARGB(255, 47, 45, 42),
                    foregroundColor: Color(0xFF1C88BF),
                    backgroundColor: Colors.white, // Warna teks biru
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0), // Padding vertikal untuk ukuran tombol
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          20.0), // Border radius sama dengan input decoration
                    ),
                    textStyle: TextStyle(
                      fontSize: 18.0, // Ukuran font
                      fontWeight: FontWeight.bold, // Tebal font
                    ),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () async {
                    showDialog(
                      context: context,
                      barrierDismissible:
                          false, // Prevents dismissal by tapping outside
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              LoadingAnimationWidget.discreteCircle(
                                  color: Colors.blue,
                                  size: MediaQuery.of(context).size.width * 0.2,
                                  secondRingColor: Colors.lightBlue,
                                  thirdRingColor: Colors.grey),
                              SizedBox(height: 20),
                              Text('Signin In...'),
                            ],
                          ),
                        );
                      },
                    );
                    final email = _emailController.text.trim();
                    final password = _passwordController.text.trim();
                    try {
                      await _auth.signInWithEmailAndPassword(
                          email: email, password: password);
                      final SharedPreferencesAsync prefs =
                          SharedPreferencesAsync();
                      // Show success message
                      Navigator.pop(context);
                      Fluttertoast.showToast(
                          msg: "Successfully Signed In",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      // Navigate to the home screen or any other screen after successful login
                      if (mounted) {
                        await prefs.setStringList('userinfo', [
                          _auth.currentUser?.displayName as String,
                          _auth.currentUser?.email as String
                        ]);
                        List<String>? userinfo =
                            await prefs.getStringList('userinfo');
                        if (userinfo != null) {
                          context.read<UserProvider>().setUsername(userinfo[0]);
                          context.read<UserProvider>().setEmail(userinfo[1]);
                        }
                        context
                            .read<UserProvider>()
                            .setUserId(_auth.currentUser!.uid);
                        context
                            .read<BookmarkProvider>()
                            .fetchBookmarks(_auth.currentUser!.uid);
                        Navigator.pushReplacementNamed(context, '/home');
                      }
                    } catch (e) {
                      // Handle errors (e.g., show error message)
                      Fluttertoast.showToast(
                          msg: "Failed to sign in: ${e.toString()}",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  }),
            ),
            const SizedBox(height: 16.0),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(context, '/register');
              },
              child: const Text('Don\'t have an account? Sign Up',
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
