import 'dart:async';
import 'dart:io';

import 'package:aplikasi_ekstraksi_file_gpt4/components/circular_progress.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/components/custom_button.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/models/bookmark_model.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/bookmark_provider.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/theme_provider.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/screen/login_screen.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/utils/openai_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Import Firebase Storage
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

// Halaman ini adalah halaman membuat subject / halaman upload file yang akan di ekstrak ( sebelumnya halaman ini  berada di dihalaman utama yg Bang Dustin Buat )
class CreateSubject extends StatefulWidget {
  const CreateSubject({super.key});

  @override
  State<CreateSubject> createState() => _CreateSubjectState();
}

class _CreateSubjectState extends State<CreateSubject> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final PageController _pageController = PageController();
  String fileName = "";
  PlatformFile? pickedFile;
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
      body: PageView(
        children: <Widget>[buildSubjectPage(context)],
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
}
