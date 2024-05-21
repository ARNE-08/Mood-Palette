import 'package:flutter/material.dart';
import 'package:mood_palette/screen/auth/login.dart';
import 'package:mood_palette/screen/home/home.dart';
import 'package:universal_html/html.dart' as html;
import 'package:mood_palette/screen/auth/signup.dart'; // Import universal_html for web compatibility
import 'package:mood_palette/screen/profile/profile.dart'; // Import the ProfilePage widget
import 'package:mood_palette/screen/statistic/stat.dart'; // Import the StatPage widget

void main() {
  runApp(MyApp());
}

class GlobalVariables {
  // Private constructor
  GlobalVariables._privateConstructor();

  // Singleton instance
  static final GlobalVariables _instance = GlobalVariables._privateConstructor();

  // Getter for the singleton instance
  static GlobalVariables get instance => _instance;

  // Global variables
  String token = "";
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Check for the presence of the userToken cookie
    bool isLoggedIn = GlobalVariables.instance.token.isNotEmpty;
    print("when login: ${isLoggedIn}");

    return MaterialApp(
      title: 'Mood Palette',
      // Determine the initial route based on the presence of the userToken cookie
      initialRoute: isLoggedIn ? '/' : '/login',
      // Define route paths and corresponding widgets
      routes: {
        '/': (context) => HomePage(), // Default route when logged in
        '/login': (context) => LoginPage(), // Route for login page
        '/signup':(context) => SignupPage(), // Route for signup page
        '/profile':(context) => ProfilePage(), // Route for profile page
        '/statistic':(context) => StatPage(), // Route for statistic page
      },
    );
  }
}