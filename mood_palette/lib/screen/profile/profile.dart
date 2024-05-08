import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts
import 'package:mood_palette/widget/navbar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Color Presets'),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'HAVE A NICE DAY!',
                  style: GoogleFonts.singleDay( // Use Google Fonts
                    fontSize: 30,
                  ),
                ),
                const Text(
                  ':D',
                  style: TextStyle(fontSize: 100),
                ),
                const SizedBox(height: 20),
                Text(
                  'Color Presets',
                  style: GoogleFonts.poppins( // Use Google Fonts
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildColorBlock(0xFFFF0022, 'Angry'),
                    _buildColorBlock(0xFFFE6900, 'Excited'),
                    _buildColorBlock(0xFFFFF500, 'Happy'),
                    _buildColorBlock(0xFF9D9CC2, 'Uncomfortable'),
                    _buildColorBlock(0xFF00947A, 'Confused'),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildColorBlock(0xFF6CD9A4, 'Chill'),
                    _buildColorBlock(0xFF59FBEA, 'Calm'),
                    _buildColorBlock(0xFFFCA9FF, 'Embarassed'),
                    _buildColorBlock(0xFF0099DA, 'Bored'),
                    _buildColorBlock(0xFF000585, 'Sad'),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildColorBlock(0xFF813AAD, 'Worried'),
                  ],
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    // Redirect to login page
                    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  child: const Text('Logout'),
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
      backgroundColor: Color(0xFFFFAB7),
    );
  }

  Widget _buildColorBlock(int colorValue, String text) {
  Color color = Color(colorValue);
  return Padding(
    padding: const EdgeInsets.all(8.0), // Add padding to create space between blocks
    child: Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(15), // Adjust the radius as needed
          ),
        ),
        const SizedBox(height: 10),
        Text(
          text,
          style: GoogleFonts.poppins( // Use Google Fonts
            fontSize: 12,
          ),
        ),
      ],
    ),
  );
}

}
