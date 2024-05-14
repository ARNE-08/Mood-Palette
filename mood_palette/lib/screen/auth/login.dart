import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mood_palette/widget/loginbutton.dart';
import 'package:mood_palette/screen/auth/signup.dart';
import 'package:mood_palette/main.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cookie_jar/cookie_jar.dart';

class StringModifier {
  void updateString(String newValue) {
    GlobalVariables.instance.token = newValue;
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextEditingController _usernameController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    
    Future<void> _login(BuildContext context) async {
      final String username = _usernameController.text;
      final String password = _passwordController.text;

      void _showSnackBar(BuildContext context, String message) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
          ),
        );
      }

      // Make sure username and password are not empty
      if (username.isEmpty || password.isEmpty) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Username and password are required.'),
          ),
        );
        return;
      }

      // Make HTTP POST request to login endpoint
      final url = Uri.parse('http://localhost:3000/login');
      final response = await http.post(
        url,
        body: jsonEncode({'username': username, 'password': password}),
        headers: {'Content-Type': 'application/json'},  
      );

      final stringModifier = StringModifier();
      // stringModifier.updateString(${response.body['data']});
      // print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');
      // print('Response headers: ${response.headers.length}');
      // Extract cookies from response
      final cookiesString = response.headers['set-cookie'];
      if (cookiesString != null && cookiesString.isNotEmpty) {
        // Parse the string containing cookies into a list of Cookie objects
        final List<Cookie> cookies = [Cookie.fromSetCookieValue(cookiesString)];
        
        // Save cookies for future requests
        final cookieJar = CookieJar();
        final uri = Uri.parse('http://localhost:3000'); // Adjust this URL according to your backend URL
        cookieJar.saveFromResponse(uri, cookies);
      }
      // print(cookiesString?.isEmpty);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String data = responseData['data'];
        stringModifier.updateString(data);
        // Login successful
        _showSnackBar(context, 'Login successful. Redirecting to home page.');
        print("token: ${GlobalVariables.instance.token}");
        // Navigate to home page
        Navigator.pushNamed(context, '/');
      } else {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData.containsKey('message') &&
            responseData['message'] == 'Error comparing passwords') {
          // Show Snackbar for incorrect password
          _showSnackBar(context, 'Incorrect password. Please try again.');
        } else if (responseData.containsKey('message') &&
            responseData['message'] == 'user not found in the system') {
          // Show Snackbar for user not found
          _showSnackBar(context, 'This account does not exist. Please sign up.');
        } else {
          // Show generic error message
          _showSnackBar(context, 'Login failed. Please try again.');
        }
      }
    }

    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: Color.fromRGBO(255, 254, 234, 1),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'MoodPalette',
                      style: GoogleFonts.singleDay(
                        textStyle: TextStyle(
                          fontSize: 36,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.calendar_today), // Calendar icon
                  ],
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 7,
                          spreadRadius: 0,
                          offset: Offset(0, 10), // Bottom shadow
                        ),
                        BoxShadow(
                          color: Colors.transparent, // Set shadow color to transparent
                          blurRadius: 7,
                          spreadRadius: 0,
                          offset: Offset(3, 0), // Right shadow
                        ),
                        BoxShadow(
                          color: Colors.transparent, // Set shadow color to transparent
                          blurRadius: 7,
                          spreadRadius: 0,
                          offset: Offset(-3, 0), // Left shadow
                        ),
                      ],
                    ),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 20),
                          Text(
                            'Login',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: TextFormField(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                hintText: 'Username',
                                prefixIcon: Icon(Icons.person), // User icon
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: TextFormField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                hintText: 'Password',
                                prefixIcon: Icon(Icons.lock), // Lock icon
                              ),
                              obscureText: true,
                            ),
                          ),
                          SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: MyElevatedButton(
                              width: double.infinity,
                              onPressed: ()  => _login(context),
                              borderRadius: BorderRadius.circular(50),
                              child: Text(
                                'LOGIN',
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white
                                  ),
                              ),
                            ),
                            ),
                          ),
                          SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/signup');
                            },
                            child: Text(
                              'Don\'t have an account?',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontSize: 15,
                                ),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}