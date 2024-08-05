import 'package:aplikasi_ekstraksi_file_gpt4/models/user_model.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _namaController = TextEditingController();
  String _role = 'Siswa'; // Default role

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1C88BF),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 60.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 70,
            ),
            Text(
              "Create Account",
              style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 40.0),
            _buildTextField(_namaController, 'Nama'),
            const SizedBox(height: 16.0),
            _buildTextField(_emailController, 'Email'),
            const SizedBox(height: 16.0),
            _buildTextField(_passwordController, 'Password', obscureText: true),
            const SizedBox(height: 16.0),
            _buildDropdown(),
            const SizedBox(height: 24.0),
            _buildRegisterButton(),
            const SizedBox(height: 16.0),
            _buildLoginLink(),

            // TAMBAHAN NANTI UTK AUTH LEWAT MEDSOS
            // const SizedBox(height: 20.0),
            // _buildSocialMediaIcons(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool obscureText = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(20.0)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      style: TextStyle(color: Colors.white),
      obscureText: obscureText,
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _role,
          dropdownColor: Color(0xFF1C88BF),
          icon: Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Icon(Icons.arrow_drop_down, color: Colors.white),
          ),
          isExpanded: true,
          items: ['Siswa', 'Guru'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(value, style: TextStyle(color: Colors.white)),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _role = newValue!;
            });
          },
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return Container(
      width: double
          .infinity, // Set lebar button sama dengan lebar input decoration
      margin:
          const EdgeInsets.symmetric(vertical: 16.0), // Margin top dan bottom
      child: ElevatedButton(
        onPressed: () async {
          final nama = _namaController.text.trim();
          final email = _emailController.text.trim();
          final password = _passwordController.text.trim();

          try {
            UserCredential userCredential =
                await _auth.createUserWithEmailAndPassword(
              email: email,
              password: password,
            );
            User? user = userCredential.user;
            user?.updateDisplayName(nama);

            UserModel userModel = UserModel(
              email: email,
              nama: nama,
              password: password,
              role: _role,
              bookmarkIds: [],
            );

            await Provider.of<UserProvider>(context, listen: false)
                .createOrUpdateUser(userModel);

            Fluttertoast.showToast(
              msg: "Successfully Signed Up",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0,
            );

            Navigator.pushReplacementNamed(context, '/login');
          } catch (e) {
            Fluttertoast.showToast(
              msg: "Failed to sign up: ${e.toString()}",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          }
        },
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
          'Register',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(context, '/login');
      },
      child: Text(
        'Already have an account? Login!',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  // WIDGET UTK AUTH LEWAT MEDSOS
  // Widget _buildSocialMediaIcons() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       IconButton(
  //         icon: Image.asset(
  //             'assets/facebook.png'), // Make sure you have the assets
  //         onPressed: () {},
  //       ),
  //       IconButton(
  //         icon: Image.asset('assets/google.png'),
  //         onPressed: () {},
  //       ),
  //       IconButton(
  //         icon: Image.asset('assets/apple.png'),
  //         onPressed: () {},
  //       ),
  //     ],
  //   );
  // }
}
