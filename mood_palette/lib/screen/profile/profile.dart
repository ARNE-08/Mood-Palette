import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mood_palette/main.dart';
import 'package:mood_palette/screen/auth/login.dart';
import 'package:mood_palette/widget/navbar.dart';
import 'package:mood_palette/widget/loginbutton.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String currentUsername = '';
  bool _isEditing = false; // Include _isEditing variable

  @override
  void initState() {
    super.initState();
    _fetchUsername();
  }

  void _fetchUsername() async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/getusername'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${GlobalVariables.instance.token}',
        },
        body: jsonEncode({
          'user_id': GlobalVariables.instance.token,
        }),
      );

      if (response.statusCode == 200) {
        print('Succeed to fetch usrname data: ${response.statusCode}');
        final Map<String, dynamic> responseData = json.decode(response.body);
        // print('fetched usrname: ${responseData['data']}');

        final String fetchedUsername = responseData['data'][0]['username'];

        setState(() {
          currentUsername = fetchedUsername;
        });
      } else {
        print('Failed to fetch username: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching username: $error');
    }
  }

  Future<void> updateUsername(String newUsername) async {
    try {
      final apiUrl = 'http://localhost:3000/editusername';
      final userId = GlobalVariables.instance.token;

      final data = {'username': newUsername, 'user_id': userId};

      final response = await http.post(
        Uri.parse(apiUrl),
        body: json.encode(data),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print('Username updated successfully');
        setState(() {
          currentUsername = newUsername;
          _isEditing = false; // Change _isEditing back to false
        });
      } else {
        print('Failed to update username: ${response.body}');
        // Handle error
      }
    } catch (error) {
      print('Error updating username: $error');
      // Handle error
    }
  }

  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Logout of MoodPalette?',
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 24.0,
              ),
            ),
          ),
          content: Text(
            'You can always log back in at any time',
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                  // fontSize: 36,
                  ),
            ),
          ),
          actions: <Widget>[
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      // primary: Colors.black,
                    ),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFF7EA1FF),
                    ),
                    child: Text(
                      'Logout',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                      Navigator.pushNamed(
                          context, '/login'); // Navigate to the login page
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xFFFFD1E3),
          flexibleSpace: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Form(
              key: _formKey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_isEditing)
                    IconButton(
                      icon: const Icon(Icons.check),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          updateUsername(_usernameController.text);
                        }
                      },
                    ),
                  const SizedBox(width: 8), // Adjust spacing as needed
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _isEditing
                            ? Expanded(
                                child: TextField(
                                  controller: _usernameController,
                                  maxLines: null,
                                  style: GoogleFonts.singleDay(
                                    textStyle: const TextStyle(
                                      fontSize: 36,
                                    ),
                                  ),
                                  decoration: InputDecoration(
                                    hintText: '$currentUsername',
                                  ),
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                ),
                              )
                            : Text(
                                currentUsername,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.singleDay(
                                  textStyle: const TextStyle(
                                    fontSize: 36,
                                  ),
                                ),
                              ),
                        if (!_isEditing)
                          Row(
                            children: [
                              const SizedBox(
                                  width:
                                      10), // Space between username and edit icon
                              IconButton(
                                icon: const Icon(Icons.edit_outlined),
                                onPressed: () {
                                  setState(() {
                                    _isEditing = true;
                                  });
                                },
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  if (_isEditing)
                    const SizedBox(width: 8), // Adjust spacing as needed
                ],
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Text(
                    'HAVE A NICE DAY!',
                    style: GoogleFonts.singleDay(
                      fontSize: 27,
                    ),
                  ),
                  const Text(
                    ':-D',
                    style: TextStyle(fontSize: 100),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Color Presets',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                    ),
                  ),
                  const Divider(
                    color: Colors.black,
                    thickness: 1,
                    height: 20,
                    indent: 40,
                    endIndent: 40,
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Container(
                      decoration: const BoxDecoration(),
                      child: Column(
                        children: [
                          Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _buildColorBlock(0xFFFF0022, 'Angry'),
                                        _buildColorBlock(0xFFFE6900, 'Excited'),
                                        _buildColorBlock(0xFFFFF500, 'Happy'),
                                        _buildlongColorBlock(
                                            0xFF9D9CC2, 'Uncomfortable'),
                                        _buildColorBlock(
                                            0xFF00947A, 'Confused'),
                                      ]
                                          .map((widget) =>
                                              Expanded(child: widget))
                                          .toList(),
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _buildColorBlock(0xFF6CD9A4, 'Chill'),
                                        _buildColorBlock(0xFF59FBEA, 'Calm'),
                                        _buildlongColorBlock(
                                            0xFFFCA9FF, 'Embarassed'),
                                        _buildColorBlock(0xFF0099DA, 'Bored'),
                                        _buildColorBlock(0xFF000585, 'Sad'),
                                      ]
                                          .map((widget) =>
                                              Expanded(child: widget))
                                          .toList(),
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _buildColorBlock(0xFF813AAD, 'Worried'),
                                        _buildInvisibleColorBlock(),
                                        _buildInvisibleColorBlock(),
                                        _buildInvisibleColorBlock(),
                                        _buildInvisibleColorBlock(),
                                      ]
                                          .map((widget) =>
                                              Expanded(child: widget))
                                          .toList(),
                                    ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: MyElevatedButton(
                      width: double.infinity,
                      onPressed:
                          _showLogoutConfirmationDialog, // Show the confirmation dialog
                      borderRadius: BorderRadius.circular(50),
                      child: Text(
                        'LOGOUT',
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                              fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: NavBar(), // Add the custom navigation bar at the bottom
          ),
        ],
      ),
      backgroundColor: const Color.fromRGBO(255, 254, 234, 1),
    );
  }

  Widget _buildColorBlock(int colorValue, String text) {
    Color color = Color(colorValue);
    return Padding(
      padding: const EdgeInsets.all(
          6.0), // Add padding to create space between blocks
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius:
                  BorderRadius.circular(15), // Adjust the radius as needed
            ),
          ),
          const SizedBox(height: 10),
          Text(
            text,
            style: GoogleFonts.poppins(
              // Use Google Fonts
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvisibleColorBlock() {
    return const SizedBox(
      width: 40, // Adjust width as needed
      height: 40, // Adjust height as needed
    );
  }

  Widget _buildlongColorBlock(int colorValue, String text) {
    Color color = Color(colorValue);
    return Padding(
      padding: const EdgeInsets.all(
          6.0), // Add padding to create space between blocks
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(15), // Adjust the radius
            ),
          ),
          const SizedBox(height: 10),
          Text(
            text,
            style: GoogleFonts.poppins(
              // Use Google Fonts
              fontSize: 8,
            ),
          ),
        ],
      ),
    );
  }
}
