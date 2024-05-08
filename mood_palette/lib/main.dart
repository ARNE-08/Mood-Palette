import 'package:flutter/material.dart';
import 'package:mood_palette/screen/auth/login.dart';
import 'package:mood_palette/screen/home/home.dart';
import 'package:universal_html/html.dart' as html;
import 'package:mood_palette/screen/auth/signup.dart'; // Import universal_html for web compatibility

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Check for the presence of the userToken cookie
    String? userToken = html.window.document.cookie; // Get the cookies
    bool isLoggedIn = false;
    if (userToken != null) {
      bool isLoggedIn = true; // Extract the userToken value
    }

    return MaterialApp(
      title: 'Mood Palette',
      // Determine the initial route based on the presence of the userToken cookie
      initialRoute: isLoggedIn ? '/' : '/login',
      // Define route paths and corresponding widgets
      routes: {
        '/': (context) => HomePage(), // Default route when logged in
        '/login': (context) => LoginPage(), // Route for login page
        '/signup':(context) => SignupPage(), // Route for signup page
      },
    );
  }
}