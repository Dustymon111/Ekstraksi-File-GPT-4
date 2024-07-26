import 'dart:async';
import 'dart:io';

import 'package:aplikasi_ekstraksi_file_gpt4/components/circular_progress.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/components/custom_button.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/models/bookmark_model.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/bookmark_provider.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/theme_provider.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/screen/bookmark_screen.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/screen/create_page.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/screen/login_screen.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/screen/profile_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Import Firebase Storage
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
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
  double progress = 0.0;

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
        final storageRef = FirebaseStorage.instance.ref().child(
            'uploads/${auth.currentUser!.uid}/$fileName'); // Use the extracted file name

        // Upload the file to Firebase Storage
        final uploadTask = storageRef.putFile(File(filePath));

        // Wait for the upload to complete
        await uploadTask;

        // Get the download URL
        final bookUrl = await storageRef.getDownloadURL();
        print('File uploaded successfully! Download URL: $bookUrl');
        PdfDocument document =
            PdfDocument(inputBytes: File(filePath).readAsBytesSync());
        if (mounted) {
          context.read<BookmarkProvider>().addBookmark(
              "book_${auth.currentUser?.uid}",
              Bookmark(
                  title: fileName,
                  bookUrl: bookUrl,
                  author: "author",
                  totalPages: document.pages.count,
                  subjects: [],
                  localFilePath: filePath));
        }

        showDialog(
          context: context,
          barrierDismissible:
              false, // Prevent dialog from being dismissed by tapping outside
          builder: (context) {
            return UploadProgressDialog(
              progressStream: uploadTask.snapshotEvents,
              onClose: () {
                Navigator.of(context).pop();
              },
            );
          },
        );
        // await FileProcessor().testFunction();
        // await FileProcessor().listModel();

        //  Map<String, dynamic> tableOfContents = await FileProcessor().extractTableOfContents(filePath);
        //   print("Title: ${tableOfContents['title']}");
        //   print("Total Pages: ${tableOfContents['totalPages']}");
        //   print("Author: ${tableOfContents['author']}");
        //   print("Contents: ${tableOfContents['contents']}");

        // Optionally, show a snackbar or dialog to notify the user of the upload
      } catch (e) {
        Fluttertoast.showToast(
            msg: "Upload failed, error: $e",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
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
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF1C88BF),
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
          selectedItemColor: Color(0xFF1C88BF),
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                  color: Color(0xFF1C88BF),
                  borderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(50.0))),
              padding: const EdgeInsets.all(16.0),
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
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Welcome to ExamEase..",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          Text(
                            "Peter Fomas Hia",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Where Knowledge Flows Freely",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: const [
                    Icon(Icons.subject, size: 30),
                    Text(
                      "1 Subjects",
                    ),
                  ],
                ),
                Column(
                  children: const [
                    Icon(Icons.topic, size: 30),
                    Text(
                      "3 Topics",
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _onTabTapped(1);
              },
              child: const Text("Create New"),
              style: ElevatedButton.styleFrom(
                  foregroundColor: Color(0xFF1C88BF),
                  backgroundColor: Colors.white),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Instructions",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const Text("For new users, please follow these steps"),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 2.5,
                        height: 150,
                        decoration: BoxDecoration(
                            color: Color(0xFF1C88BF),
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2.5,
                        height: 150,
                        decoration: BoxDecoration(
                            color: Color(0xFF1C88BF),
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ],
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

  Widget buildSubjectPage(BuildContext context) {
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
