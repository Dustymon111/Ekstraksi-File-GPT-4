import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _userName = "Loading...";
  String _email = "Loading...";

  @override
  void initState() {
    super.initState();
    _getUserName();
    getCurrentUser();
  }

  void getCurrentUser() {
    final user_mail = FirebaseAuth.instance.currentUser;
    setState(() {});
  }

  Future<void> _getUserName() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (userDoc.exists && userDoc.data() != null) {
          setState(() {
            _userName = userDoc.get('nama') ?? "Unknown";
            _email = userDoc.get('email') ?? "Unknown";
          });
        } else {
          setState(() {
            _userName = "Unknown";
            _email = "Unknown";
          });
        }
      } catch (e) {
        print("Error fetching user data: $e");
        setState(() {
          _userName = "Unknown";
          _email = "Unknown";
        });
      }
    }
  }

  void _showDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 16),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
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
                    backgroundColor: Color(0xFF1C88BF),
                    child: Text(
                      "TS",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _userName,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _email,
                        _email,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24),
                  Text(
                    "Pengaturan",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyMedium?.color),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Ubah Email",
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Ubah Password",
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  SizedBox(height: 24),
                  const Divider(thickness: 2),
                  const SizedBox(height: 20),
                  Text(
                    "Bantuan & Informasi",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge?.color),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      _showDialog(context, "Syarat dan Ketentuan",
                          "Terima kasih telah menggunakan aplikasi kami. Harap dibaca dan pahami syarat dan ketentuan berikut sebelum menggunakan layanan kami:\n\n1. Penggunaan aplikasi ini tunduk pada syarat dan ketentuan yang berlaku.\n\n2. Kami menghargai privasi Anda dan akan melindungi data pribadi sesuai dengan kebijakan privasi kami.\n\n3. Setiap penggunaan yang melanggar ketentuan dapat mengakibatkan pembatasan akses atau penghentian layanan.\n\nTerima kasih atas perhatian Anda.");
                    },
                    child: const Text(
                      "Syarat Dan Ketentuan",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      _showDialog(context, "Pusat Bantuan",
                          "Selamat datang di Pusat Bantuan kami.\n\nKami siap membantu Anda dengan segala pertanyaan atau masalah yang Anda miliki terkait penggunaan aplikasi kami.\n\nSilakan cari jawaban untuk pertanyaan umum di bagian FAQ kami.\n\nJika Anda tidak menemukan jawaban yang Anda cari, jangan ragu untuk menghubungi tim dukungan kami melalui email atau telepon yang tertera di halaman kontak aplikasi.\n\nTerima kasih.");
                    },
                    child: const Text(
                      "Pusat Bantuan",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      _showDialog(context, "Tentang Aplikasi",
                          "Aplikasi ini merupakan aplikasi ekstraksi file digital menjadi beberapa soal dalam bentuk quis. Soal yang dihasilkan dapat menjadi latihan untuk siswa belajar dan referensi untuk ujian siswa bagi guru");
                    },
                    child: const Text(
                      "Tentang Aplikasi",
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
                          "Berikut adalah informasi kontak kami untuk pertanyaan lebih lanjut:\n\nNama: TIM L\nEmail: informatika@mikroskil.ac.id\nTelepon: 082362246172\n\nJangan ragu untuk menghubungi kami jika Anda memiliki pertanyaan atau membutuhkan bantuan lebih lanjut.\n\nTerima kasih.");
                    },
                    child: const Text(
                      "Contact Person",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          // Sign out the user
                          await FirebaseAuth.instance.signOut();

                          // Navigate to the login screen and remove all previous routes
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            '/login',
                            (Route<dynamic> route) => false,
                          );

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
                      child: Text('Keluar'),
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
