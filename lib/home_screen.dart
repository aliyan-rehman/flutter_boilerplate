import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/sqlite/sqlite_screen.dart';
import 'package:flutter_boilerplate/widgets/custom_button.dart';

import 'firebase/auth/email_password/email_auth_screen.dart';
import 'firebase/auth/google_sign_in/google_auth_screen.dart';
import 'firebase/firestore/firestore_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter Boilerplate'), centerTitle: true),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Choose a Feature',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 40),

            CustomButton(
              text: "Email Auth",

              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => EmailAuthScreen()),
                );
              },
            ),

            SizedBox(height: 16),

            CustomButton(
              text: "Google Sign In",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => GoogleAuthScreen()),
                );
              },
            ),

            SizedBox(height: 16),

            CustomButton(
              text: "Firestore CRUD",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => FirestoreScreen()),
                );
              },
            ),

            SizedBox(height: 16),

            CustomButton(
              text: "SLite CRUD",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SqliteScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
