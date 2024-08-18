import 'package:aplikasi_ekstraksi_file_gpt4/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  void _showDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userprov = Provider.of<UserProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xFF1C88BF),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.transparent,
                    child: Image.asset('assets/educraft_logo_finish.png'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userprov.username,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          userprov.email,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                            fontSize: 16,
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  // Text(
                  //   "Settings",
                  //   style: TextStyle(
                  //     fontSize: 22,
                  //     fontWeight: FontWeight.bold,
                  //     color: Theme.of(context).textTheme.bodyMedium?.color,
                  //   ),
                  // ),
                  // const SizedBox(height: 8),
                  // Text(
                  //   "Change Email",
                  //   style: TextStyle(
                  //     fontSize: 18,
                  //     color: Theme.of(context).textTheme.bodyLarge?.color,
                  //   ),
                  // ),
                  // const SizedBox(height: 4),
                  // Text(
                  //   "Change Password",
                  //   style: TextStyle(
                  //     fontSize: 18,
                  //     color: Theme.of(context).textTheme.bodyLarge?.color,
                  //   ),
                  // ),
                  // const SizedBox(height: 24),
                  // const Divider(thickness: 2),
                  // const SizedBox(height: 20),
                  Text(
                    "Help And Information",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      _showDialog(context, "Terms & Conditions",
                          "Thank you for using our application. Please read and understand the following terms and conditions before using our services:\n\n1. The use of this application is subject to the applicable terms and conditions.\n\n2.We respect your privacy and will protect personal data in accordance with our privacy policy.\n\n3. Any use that violates the terms may result in restricted access or termination of services.\n\nThank you for your attention.");
                    },
                    child: const Text(
                      "Terms & Conditions",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      _showDialog(context, "Help Center",
                          "Welcome to Our Help Center.\n\nWe are here to assist you with any questions or issues you may have regarding the use of our application.\n\nPlease look for answers to common questions in our FAQ section.\n\nIf you do not find the answer you are looking for, feel free to contact our support team via the email or phone number provided on the application's contact page.\n\nThank you.");
                    },
                    child: const Text(
                      "Help Center",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      _showDialog(context, "About",
                          "This application is designed to extract digital files into quizzes. The generated questions can be used for student practice and serve as a reference for teachers when preparing exams..");
                    },
                    child: const Text(
                      "About",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      _showDialog(context, "Contact Person",
                          "Here is our contact information for further inquiries:\n\nName: Examqz\nEmail: informatika@mikroskil.ac.id\nPhone: 082362246172\n\nPlease feel free to contact us if you have any questions or need further assistance.\n\nThankyou.");
                    },
                    child: const Text(
                      "Contact Person",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          print("Attempting to sign out...");
                          // Sign out the user
                          await FirebaseAuth.instance.signOut();
                          print(
                              "Sign out successful. Preparing to navigate...");

                          // Use context mounted after the sign out process
                          if (mounted) {
                            print("Navigating to login screen...");
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              '/login',
                              (Route<dynamic> route) => false,
                            );
                            print("Navigation successful.");

                            // Show a toast message indicating successful sign out
                            Fluttertoast.showToast(
                              msg: "Successfully Signed Out",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.white,
                              textColor: Colors.black,
                              fontSize: 16.0,
                            );
                          } else {
                            print(
                                "Context is not mounted, navigation skipped."); // Log jika context tidak valid
                          }
                        } catch (e) {
                          // Handle any errors during sign out
                          print("Error signing out: $e");
                          Fluttertoast.showToast(
                            msg: "Error signing out. Please try again.",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        }
                      },
                      child: const Text('Logout'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
