import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mood_palette/main.dart';
import 'package:mood_palette/screen/auth/login.dart';
import 'package:mood_palette/widget/navbar.dart';
import 'package:mood_palette/widget/loginbutton.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// Define a class to hold global variables
class GlobalVariables {
  static final instance = GlobalVariables._internal();
  String token;

  GlobalVariables._internal() : token = ''; // Initialize token with empty string
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController _usernameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String currentUsername = '';
  bool _isEditing = false; // Include _isEditing variable

  @override
  void initState() {
    super.initState();
    _fetchUsername();
  }

  // Future<void> _fetchUsername() async {
  //   try {
  //     final apiUrl = 'http://localhost:3000/getusername';
  //     final userId = GlobalVariables.instance.token;

  //     final response = await http.post(
  //       Uri.parse(apiUrl),
  //       body: {'user_id': userId},
  //     );

  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);
  //       final username = data['data'][0]['username'];
  //       setState(() {
  //         currentUsername = username;
  //         _usernameController.text = username;
  //       });
  //     } else {
  //       print('Failed to fetch username: ${response.body}');
  //     }
  //   } catch (error) {
  //     print('Error fetching username: $error');
  //   }
  // }

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
      final Map<String, dynamic> responseData = json.decode(response.body);
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xFFFFD1E3),
          flexibleSpace: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Form( // Wrap the TextField with a Form widget
              key: _formKey, // Assign the _formKey
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
                  const SizedBox(width: 16),
                  Expanded(
                    child: _isEditing
                        ? TextField(
                            controller: _usernameController,
                            maxLines: null,
                            style: GoogleFonts.singleDay(
                              textStyle: const TextStyle(
                                fontSize: 36,
                              ),
                            ),
                            decoration: const InputDecoration(
                              hintText: 'Enter username',
                            ),
                            onChanged: (value) {
                              setState(() {});
                            },
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
                  ),
                  if (!_isEditing)
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
            ),
          ),
        ),
      ),

      body: Stack(
        children: [
          Center(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Text(
                  'HAVE A NICE DAY!',
                  style: GoogleFonts.singleDay(
                    // Use Google Fonts
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
                    // Use Google Fonts
                    fontSize: 20,
                  ),
                ),
                const Divider(
                  // Add a divider
                  color: Colors.black,
                  thickness: 1,
                  height: 20,
                  indent: 40, // Adjust the indentation as needed
                  endIndent: 40,
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40), // Add horizontal padding
                  child: Container(
                    decoration: const BoxDecoration(),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment
                              .spaceBetween, // Align blocks to start and end
                          children: [
                            _buildColorBlock(0xFFFF0022, 'Angry'),
                            _buildColorBlock(0xFFFE6900, 'Excited'),
                            _buildColorBlock(0xFFFFF500, 'Happy'),
                            _buildlongColorBlock(0xFF9D9CC2, 'Uncomfortable'),
                            _buildColorBlock(0xFF00947A, 'Confused'),
                          ]
                              .map((widget) => Expanded(child: widget))
                              .toList(), // Use Expanded for equal spacing
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment
                              .spaceBetween, // Align blocks to start and end
                          children: [
                            _buildColorBlock(0xFF6CD9A4, 'Chill'),
                            _buildColorBlock(0xFF59FBEA, 'Calm'),
                            _buildlongColorBlock(0xFFFCA9FF, 'Embarassed'),
                            _buildColorBlock(0xFF0099DA, 'Bored'),
                            _buildColorBlock(0xFF000585, 'Sad'),
                          ]
                              .map((widget) => Expanded(child: widget))
                              .toList(), // Use Expanded for equal spacing
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildColorBlock(0xFF813AAD, 'Worried'),
                            _buildInvisibleColorBlock(),
                            _buildInvisibleColorBlock(),
                            _buildInvisibleColorBlock(),
                            _buildInvisibleColorBlock(),
                          ].map((widget) => Expanded(child: widget)).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: MyElevatedButton(
                    width: double.infinity,
                    onPressed: () {
                      // Navigate to the HomePage
                      Navigator.pushNamed(
                          context, '/login'); // Navigate to the HomePage
                    },
                    borderRadius: BorderRadius.circular(50),
                    child: Text(
                      'LOGOUT',
                      style: GoogleFonts.poppins(
                        textStyle:
                            const TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
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
              fontSize: 12,
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
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}