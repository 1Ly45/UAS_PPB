// This widget listens to authentication state and navigates accordingly
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uas_pbb/pages/dashboard_page.dart';
import 'package:uas_pbb/pages/login/login_register_page.dart';

class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      // Listen to auth state changes
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // If authentication data is available, navigate to home
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // Show loading spinner while checking auth state
        }

        if (snapshot.hasData) {
          // User is logged in, show HomePage
          return HomePage();
        } else {
          // User is not logged in, show LoginPage
          return LoginPage();
        }
      },
    );
  }
}