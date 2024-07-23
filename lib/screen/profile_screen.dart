import 'package:aplikasi_ekstraksi_file_gpt4/components/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Text(
                  'User Email:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8),
                Text(
                  user?.displayName ?? 'No name available',
                  style: TextStyle(fontSize: 18),
                ),
              ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Text(
                  'User Email:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8),
                Text(
                  user?.email ?? 'No email available',
                  style: TextStyle(fontSize: 18),
                ),
              ],
              ),
              SizedBox(height: 24),
              CustomElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  if (Navigator.canPop(context)) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/login',
                      (Route<dynamic> route) => false,
                    );
                    Fluttertoast.showToast(
                        msg: "Successfully Signed Out",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                },
                label: 'Sign Out',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
