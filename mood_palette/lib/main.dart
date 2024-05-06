import 'package:flutter/material.dart';
import 'package:mood_palette/screen/auth/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // var colorScheme = Color.fromRGBO(255, 254, 234, 1);
    return MaterialApp(
      title: 'Mood Palette',
      theme: ThemeData(
        //   colorScheme: ColorScheme.fromSwatch(
        //     backgroundColor: colorScheme, // Set the background color
        //   // Add more properties such as secondarySwatch, errorColor, etc. if needed
        // ),
      ),
      home: LoginPage(), // Open the login page when the app starts
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:mood_palette/screen/login/login.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     var colorScheme = Color.fromRGBO(255, 254, 234, 1);
//     return MaterialApp(
//       title: 'Mood Palette',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSwatch(
//           backgroundColor: colorScheme, // Set the background color
//           // Add more properties such as secondarySwatch, errorColor, etc. if needed
//         ),
//         // Define other theme properties here
//       ),
//       home: LoginPage(), // Open the login page when the app starts
//     );
//   }
// }
