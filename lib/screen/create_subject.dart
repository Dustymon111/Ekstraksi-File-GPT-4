import 'dart:async';
import 'dart:io';
import 'package:aplikasi_ekstraksi_file_gpt4/components/custom_button.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/models/subject_model.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/bookmark_provider.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/theme_provider.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/user_provider.dart';
// import 'package:aplikasi_ekstraksi_file_gpt4/providers/user_provider.dart';
// import 'package:aplikasi_ekstraksi_file_gpt4/screen/login_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Import Firebase Storage
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:http/http.dart' as http;
// import 'package:flutter_dotenv/flutter_dotenv.dart';

// Halaman ini adalah halaman membuat subject / halaman upload file yang akan di ekstrak ( sebelumnya halaman ini  berada di dihalaman utama yg Bang Dustin Buat )
class CreateSubject extends StatefulWidget {
  const CreateSubject({super.key});

  @override
  State<CreateSubject> createState() => _CreateSubjectState();
}

class _CreateSubjectState extends State<CreateSubject> {
  // final String localhost = dotenv.env["LOCALHOST"]!;
  // final String port = dotenv.env["PORT"]!;
  final String serverUrl =
      'https://ekstraksi-file-gpt-4-server-xzcbfs2fqq-et.a.run.app';

  final FirebaseAuth auth = FirebaseAuth.instance;
  final PageController _pageController = PageController();
  String fileName = "";
  PlatformFile? pickedFile;
  User? user;
  String? userEmail;
  String? userName;
  String? userId;
  // late final StreamSubscription<User?> _authSubscription;
  double progress = 0.0;

  @override
  void initState() {
    super.initState();
    userId = context.read<UserProvider>().userId;
  }

  @override
  void dispose() {
    // _authSubscription.cancel();
    _pageController.dispose();
    super.dispose();
  }

  List<Subject> parseSubjects(List<dynamic> subjectsJson) {
    return subjectsJson
        .map((json) => Subject.fromMap(json as Map<String, dynamic>))
        .toList();
  }

  List<String> parseAuthors(dynamic authorData) {
    if (authorData is List) {
      return List<String>.from(authorData.map((item) => item.toString()));
    }
    return [];
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

  Future<void> uploadFile(BuildContext context) async {
    if (pickedFile != null) {
      try {
        final filePath = pickedFile!.path!;
        final fileName = path.basename(filePath.split('/').last);

        // Create a reference to Firebase Storage
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('uploads/${auth.currentUser!.uid}/$fileName');

        // Show the initial dialog with loading animation
        showDialog(
          context: context,
          barrierDismissible: false, // Prevents dismissal by tapping outside
          builder: (BuildContext context) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LoadingAnimationWidget.discreteCircle(
                      color: Colors.blue,
                      size: MediaQuery.of(context).size.width * 0.25,
                      secondRingColor: Colors.lightBlue,
                      thirdRingColor: Colors.grey),
                  SizedBox(width: 20),
                  Text('Extracting file...'),
                ],
              ),
            );
          },
        );

        // Upload the file to Firebase Storage
        final uploadTask = storageRef.putFile(File(filePath));

        // Wait for the upload to complete
        await uploadTask;

        // Get the download URL
        final bookUrl = await storageRef.getDownloadURL();
        PdfDocument document =
            PdfDocument(inputBytes: File(filePath).readAsBytesSync());

        // Send file to Python backend
        var uri = Uri.parse('$serverUrl/ekstrak-info');
        var request = http.MultipartRequest('POST', uri)
          ..files.add(
            http.MultipartFile(
              'file',
              File(filePath).readAsBytes().asStream(),
              File(filePath).lengthSync(),
              filename: fileName,
            ),
          )
          ..fields['userId'] = auth.currentUser!.uid
          ..fields['totalPages'] = document.pages.count.toString()
          ..fields['bookUrl'] = bookUrl;

        var response = await request.send();

        Navigator.of(context).pop(); // Close the loading dialog

        if (response.statusCode == 200) {
          final responseBody = await response.stream.bytesToString();
          print('response: $responseBody');
          print('File uploaded successfully! Download URL: $bookUrl');
          context.read<BookmarkProvider>().fetchBookmarks(userId!);

          // Show success dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Upload Complete'),
                content:
                    Text('File uploaded successfully! Check your bookmarks.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the success dialog
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          // Handle non-200 response from the backend
          print("status code: ${response.statusCode}");
          Fluttertoast.showToast(
            msg: "Gagal mengekstrak modul, mohon coba kembali",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      } catch (e) {
        print("error: $e");
        Navigator.of(context)
            .pop(); // Ensure dialog is closed if an error occurs
        Fluttertoast.showToast(
          msg: "Gagal mengekstrak modul, mohon coba kembali",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
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
                onPressed: pickedFile != null
                    ? () async {
                        await uploadFile(context);
                      }
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
