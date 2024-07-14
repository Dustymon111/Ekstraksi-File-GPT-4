import 'dart:io';

import 'package:aplikasi_ekstraksi_file_gpt4/providers/theme_provider.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/screen/bookmark_screen.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/screen/login_screen.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/screen/profile_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../components/custom_button.dart';
import '../utils/file_picker_service.dart';

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


  Future<void> uploadFile() async {
    pickedFile = await pickFile();
    if (pickedFile != null) {
      print(pickedFile?.name);
      setState(() {
        fileName = pickedFile!.name;
      });
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(index,
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }


Future<User?> getCurrentUser() async {
    return auth.currentUser;
}

  @override
  void initState() {
    super.initState();
    auth.authStateChanges().listen((User? user) {
    if (user == null) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
    } else {
      print('User is signed in!');
    }
  });
    getCurrentUser().then((user) {
      setState(() {
        userEmail = user?.email;
        userName = user?.displayName;
      });
    });
    
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.book_outlined), label: 'Bookmarks'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
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
                  onPressed: uploadFile),
              CustomElevatedButton(
                label: "Ekstrak Berkas",
                onPressed: pickedFile != null
                    ? () {
                        print("proses ekstraksi dimulai");
                      }
                    : null,
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget buildBookmarkPage(BuildContext context) {
    return BookmarkScreen();
  }

  Widget buildProfilePage(BuildContext context) {
    return ProfileScreen();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
