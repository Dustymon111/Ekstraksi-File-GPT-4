import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:aplikasi_ekstraksi_file_gpt4/providers/theme_provider.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/user_provider.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/screen/bookmark_screen.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/screen/create_page.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/screen/login_screen.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/screen/profile_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

// import 'package:path/path.dart';
import 'package:provider/provider.dart';

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
  String? userId;
  StreamSubscription<User?>? _authSubscription;
  double progress = 0.0;
  int BookCount = 0;

  final color = [Colors.red, Colors.yellow, Colors.blue];
  List<String> assets = [
    'assets/carousel1.png',
    'assets/carousel2.png',
    'assets/carousel3.png',
  ];

  @override
  void initState() {
    super.initState();
    fetchBookCount();
    // userId = context.read<UserProvider>().userId;
    _authSubscription = auth.authStateChanges().listen((User? user) {
      if (user == null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        print('User is signed in!');
      }
    });
  }

  void fetchBookCount() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;

      // Mengambil data dari Firestore berdasarkan UID
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      List bookmarkIds = snapshot['bookmarkIds'];

      setState(() {
        BookCount = bookmarkIds.length;
      });
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _pageController.dispose();
    super.dispose();
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
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
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
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFF1C88BF), width: 2),
          borderRadius: BorderRadius.all(
            Radius.circular(30.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              spreadRadius: 0,
              blurRadius: 10,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(35.0),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _onTabTapped,
            backgroundColor:
                Theme.of(context).bottomNavigationBarTheme.backgroundColor,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            selectedItemColor:
                Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
            unselectedItemColor:
                Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).appBarTheme.backgroundColor,
                  borderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(50.0))),
              padding: EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal:
                    MediaQuery.of(context).size.width * 0.05, // Dynamic padding
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.white,
                        child: const Icon(Icons.school,
                            color: Color(0xFF1C88BF), size: 40),
                      ),
                      SizedBox(width: 20),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Welcome to EduCraft..",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            Text(
                              context.read<UserProvider>().username,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Knowledge Flows Freely with Practice",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Icon(Icons.subject, size: 30),
                    SizedBox(height: 5),
                    Text("$BookCount Book",
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        )),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.topic, size: 30),
                    SizedBox(height: 5),
                    Text("0 Exercise",
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        )),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _onTabTapped(1);
              },
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double screenWidth = MediaQuery.of(context).size.width;
                  double basePaddingHorizontal =
                      screenWidth * 0.1; // Basic padding based on screen width
                  double additionalPadding =
                      30.0; // Additional padding to increase left and right padding
                  double paddingHorizontal =
                      basePaddingHorizontal + additionalPadding;
                  double paddingVertical = 15.0; // Fixed vertical padding
                  double fontSize = screenWidth *
                      0.05; // Adjust font size based on screen width

                  return Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontal,
                        vertical: paddingVertical),
                    child: Text(
                      "Create New",
                      style: TextStyle(
                        fontSize: fontSize,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                  );
                },
              ),
              style: ElevatedButton.styleFrom(
                side: BorderSide(
                  color: Color(0xFF1C88BF),
                  width: 3,
                ),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                foregroundColor: Color(0xFF1C88BF),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Instructions",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.bodyLarge?.color)),
                  Text("For new users, follow these steps!",
                      style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).textTheme.bodyLarge?.color)),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    child: PageView.builder(
                      itemCount: assets.length,
                      padEnds: false,
                      pageSnapping: false,
                      reverse: true,
                      controller:
                          PageController(initialPage: 1, viewportFraction: 0.7),
                      itemBuilder: (context, index) {
                        return Container(
                          height: 500,
                          margin: EdgeInsets.all(8),
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: color[index],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Image.asset(
                            assets[index],
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text("See all",
                          style: TextStyle(color: Colors.blue)),
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

  Widget buildBookmarkPage(BuildContext context) {
    return const BookmarkScreen();
  }

  Widget buildCreatePage(BuildContext context) {
    return const CreateScreen();
  }

  Widget buildProfilePage(BuildContext context) {
    return const ProfileScreen();
  }
}
