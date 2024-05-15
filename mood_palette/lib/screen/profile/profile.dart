import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts
import 'package:mood_palette/screen/auth/login.dart';
import 'package:mood_palette/widget/navbar.dart';
import 'package:mood_palette/widget/loginbutton.dart';

class ProfilePage extends StatelessWidget {
  // const ProfilePage({super.key});
  TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80), // Set preferred height
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xFFFFD1E3), // Set AppBar color
          flexibleSpace: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                Text(
                  'USERNAME',
                  style: GoogleFonts.singleDay(
                    textStyle: TextStyle(
                      fontSize: 36,
                    ),
                  ),
                ),
              ],
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
                SizedBox(height: 40),
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
                      Navigator.pushNamed(context, '/login'); // Navigate to the HomePage
                    },
                    borderRadius: BorderRadius.circular(50),
                    child: Text(
                      'LOGOUT',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(fontSize: 20, color: Colors.white),
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
              borderRadius:
                  BorderRadius.circular(15), // Adjust the radius as needed
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
