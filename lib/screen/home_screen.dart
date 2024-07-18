import 'dart:async';
import 'dart:io';

import 'package:aplikasi_ekstraksi_file_gpt4/components/custom_button.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/theme_provider.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/screen/bookmark_screen.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/screen/create_screen.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/screen/login_screen.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/screen/profile_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Import Firebase Storage
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final PageController _pageController = PageController();
  String fileName = "";
  PlatformFile? pickedFile;
  int _currentIndex = 0;
  User? user;
  String? userEmail;
  String? userName;
  late final StreamSubscription<User?> _authSubscription;

  @override
  void initState() {
    super.initState();
    _authSubscription = auth.authStateChanges().listen((User? user) {
      if (user == null) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false,
        );
      } else {
        print('User is signed in!');
      }
    });

    // getCurrentUser().then((user) {
    //   if (mounted) {
    //     setState(() {
    //       userEmail = user?.email;
    //       userName = user?.displayName;
    //     });
    //   }
    // });
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> pickFile() async {
    try {
      // Pick a file
      final result = await FilePicker.platform.pickFiles(type: FileType.any);

      if (result != null && result.files.isNotEmpty) {
        // Get the first file from the result
        final pickedFile = result.files.first;

        setState(() {
          // Update state with the picked file
          this.pickedFile = pickedFile;
          fileName = pickedFile.name;
        });
      } else {
        // No file picked, handle as needed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No file selected!')),
        );
      }
    } catch (e) {
      // Handle any errors during file picking
      print('Error picking file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick file: $e')),
      );
    }
  }

  Future<void> uploadFile() async {
    if (pickedFile != null) {
      try {
        final filePath = pickedFile!.path!;
        final fileName =
            filePath.split('/').last; // Extract file name from path

        // Create a reference to Firebase Storage
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('uploads/$fileName'); // Use the extracted file name

        // Upload the file to Firebase Storage
        final uploadTask = storageRef.putFile(File(filePath));

        // Show upload progress (optional)
        uploadTask.snapshotEvents.listen((event) {
          final progress = (event.bytesTransferred.toDouble() /
                  event.totalBytes.toDouble()) *
              100;
          print('Upload progress: $progress%');
        });

        // Wait for the upload to complete
        await uploadTask;

        // Get the download URL
        final downloadURL = await storageRef.getDownloadURL();
        print('File uploaded successfully! Download URL: $downloadURL');

        // Optionally, show a snackbar or dialog to notify the user of the upload
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File uploaded successfully!')),
        );
      } catch (e) {
        print('Error uploading file: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload file: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No file selected!')),
      );
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(index,
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    var themeprov = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          Switch(
            thumbIcon: themeprov.isDarkTheme
                ? WidgetStateProperty.all(const Icon(Icons.nights_stay))
                : WidgetStateProperty.all(const Icon(Icons.sunny)),
            activeColor: Colors.white,
            inactiveThumbColor: Colors.indigo,
            value: themeprov.isDarkTheme,
            onChanged: (bool value) {
              themeprov.toggleTheme();
            },
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              spreadRadius: 0,
              blurRadius: 10,
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 30),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline, size: 30),
              label: 'Create',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark, size: 30),
              label: 'Bookmarks',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 30),
              label: 'Profile',
            ),
          ],
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: <Widget>[
          buildHomePage(context),
          buildCreatePage(context),
          buildBookmarkPage(context),
          buildProfilePage(context),
        ],
      ),
    );
  }

  Widget buildHomePage(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          pickedFile != null
              ? Container(
                  width: MediaQuery.of(context).size.width / 1.5,
                  height: MediaQuery.of(context).size.height / 1.5,
                  alignment: Alignment.center,
                  child: SfPdfViewer.file(
                    scrollDirection: PdfScrollDirection.horizontal,
                    pageLayoutMode: PdfPageLayoutMode.single,
                    File(pickedFile!.path!),
                  ),
                )
              : Container(
                  child: const Text(
                    "Unggah file anda",
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
          Container(
            padding: const EdgeInsets.only(right: 10, left: 10),
            child: Text(
              fileName,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomElevatedButton(
                label: pickedFile != null ? "Ganti Berkas" : "Unggah Berkas",
                onPressed: pickFile,
              ),
              CustomElevatedButton(
                label: "Ekstrak Berkas",
                onPressed: pickedFile != null ? uploadFile : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildBookmarkPage(BuildContext context) {
    return BookmarkScreen();
  }

  Widget buildCreatePage(BuildContext context) {
    return CreateScreen();
  }

  Widget buildProfilePage(BuildContext context) {
    return ProfileScreen();
  }
}
