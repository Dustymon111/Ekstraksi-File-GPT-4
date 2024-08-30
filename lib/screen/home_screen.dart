import 'package:aplikasi_ekstraksi_file_gpt4/models/question_set_model.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/question_provider.dart';
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
import 'package:intl/intl.dart';

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
  int bookCount = 0;
  int exerciseCount = 0;

  // final color = [Colors.red, Colors.yellow, Colors.blue];
  List<String> assets = [
    'assets/carousel_Pertama.png',
    'assets/carousel_Kedua.png',
    'assets/carousel_Ketiga.png',
    'assets/carousel_Keempat.png',
    'assets/carousel_Kelima.png',
    'assets/carousel_Keenam.png',
  ];

  @override
  void initState() {
    super.initState();
    fetchb();
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

  void fetchb() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;

      // Mengambil data dari Firestore berdasarkan UID
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      List bookmarkIds = snapshot['bookmarkIds'];
      List questionSetIds = snapshot['questionSetIds'];

      setState(() {
        bookCount = bookmarkIds.length;
        exerciseCount = questionSetIds.length;
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
    final questionProv = Provider.of<QuestionProvider>(context);

    // Sort exercises dan ambil yang terbaru
    List<QuestionSet> latestExercises = List.from(questionProv.questionSets)
      ..sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

    // Memastikan hanya 3 exercise yang ditampilkan jika lebih dari 3
    if (latestExercises.length > 3) {
      latestExercises = latestExercises.take(3).toList();
    }

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding:
                  EdgeInsets.only(top: 160.0), // Sesuaikan dengan tinggi header
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.subject, size: 30),
                          SizedBox(height: 5),
                          Text(
                            "$bookCount Book",
                            style: TextStyle(
                              fontSize: 18,
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.topic, size: 30),
                          SizedBox(height: 5),
                          Text(
                            "$exerciseCount Exercise",
                            style: TextStyle(
                              fontSize: 18,
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        _onTabTapped(1);
                      },
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          double screenWidth =
                              MediaQuery.of(context).size.width;
                          double basePaddingHorizontal = screenWidth * 0.1;
                          double additionalPadding = 30.0;
                          double paddingHorizontal =
                              basePaddingHorizontal + additionalPadding;
                          double paddingVertical = 15.0;
                          double fontSize = screenWidth * 0.05;

                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: paddingHorizontal,
                                vertical: paddingVertical),
                            child: Text(
                              "Create New",
                              style: TextStyle(
                                fontSize: fontSize,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.color,
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
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        foregroundColor: Color(0xFF1C88BF),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Instruksi dan carousel jika exercise <= 3
                  if (exerciseCount <= 3) ...[
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.06,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Instructions",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                          Text(
                            "For new users, please follow these steps",
                            style: TextStyle(
                              fontSize: 16,
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 300,
                      width: MediaQuery.of(context).size.width,
                      child: PageView.builder(
                        itemCount: assets.length,
                        controller: PageController(
                          initialPage: 0,
                          viewportFraction: 1,
                        ),
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 6.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Image.asset(
                                  assets[index],
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ]
                  // Daftar exercise jika lebih dari 3
                  else ...[
                    Padding(
                      padding: EdgeInsets.only(
                          left: 16.0), // Atur margin kiri di sini
                      child: Text(
                        "Latest Exercise",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: latestExercises.length,
                      itemBuilder: (context, index) {
                        print("index : $index");
                        QuestionSet questionSet = latestExercises[index];

                        return Card(
                          margin: const EdgeInsets.all(14.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: Colors.blue, // border color
                              width: 1, // border width
                            ),
                          ),
                          elevation: 3,
                          child: Padding(
                            padding:
                                const EdgeInsets.all(12.0), // Adjust padding
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              title: Text(
                                questionSet.title ??
                                    'Question Set ${index + 1}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.color,
                                    overflow: TextOverflow.ellipsis),
                                maxLines: 1,
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Number of Questions: ${questionSet.questionCount}',
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Created At: ${questionSet.createdAt != null ? DateFormat('yyyy MMMM dd').format(questionSet.createdAt!) : 'Not Available'}',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.color,
                                    ),
                                  ),
                                  Text(
                                    'Finished At: ${questionSet.finishedAt != null ? DateFormat('yyyy MMMM dd').format(questionSet.finishedAt!) : 'Not Finished'}',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.color,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Text(
                                questionSet.status == "Selesai"
                                    ? "${questionSet.point}/100"
                                    : "Not Finished",
                                style: TextStyle(
                                  color: questionSet.status == "Selesai"
                                      ? Colors.green
                                      : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onTap: () {
                                // Implementasi navigasi ke halaman detail exercise
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).appBarTheme.backgroundColor,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(50.0),
                  ),
                  border: Border(
                      bottom: BorderSide(
                    color: Color(0xFF1C88BF),
                    width: 2.0,
                  ))),
              padding: EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: MediaQuery.of(context).size.width * 0.05,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.transparent,
                        child: Image.asset("assets/educraft_logo_finish.png"),
                      ),
                      SizedBox(width: 10),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Welcome to EduCraft",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  height: 1.3),
                            ),
                            Text(
                              context.read<UserProvider>().username,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  height: 0.9),
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
          ),
        ],
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
