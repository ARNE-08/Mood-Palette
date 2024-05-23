import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mood_palette/screen/profile/profile.dart';
import 'package:mood_palette/screen/statistic/stat.dart';
import 'package:mood_palette/screen/home/home.dart';

class NavBar extends StatelessWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 110,
          // Add any content for the 110 height part here
          // For example, a background image or anything else you want to include
        ),
        Container(
          height: 80,
          color: Color(0xFFFFD1E3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StatPage()), // Navigate to the StatisticPage
                  );
                },
                child: Column(
                  children: [
                    const IconButton(
                      icon: Icon(Icons.stacked_bar_chart_rounded),
                      onPressed: null,
                      iconSize: 35,
                    ),
                    Text(
                      'STATISTIC', // Tiny text
                      style: GoogleFonts.poppins( // Use Google Fonts
                        fontSize: 12, // Adjust font size as needed
                      ),
                    ),
                  ],
                ),
              ),
              Transform.translate(
                offset: const Offset(0, -20), // Move the container 30 pixels up
                child: Container(
                  width: 90, // Diameter of the circle
                  height: 90, // Diameter of the circle
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF7EA1FF), // Color of the circle
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black87.withOpacity(0.2), // Shadow color
                        spreadRadius: 2, // Spread radius
                        blurRadius: 4, // Blur radius
                        offset: const Offset(0, 2), // Shadow offset
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.home),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()), // Navigate to the HomePage
                      );
                    },
                    color: Colors.white, // Color of the icon
                    iconSize: 45,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()), // Navigate to the ProfilePage
                  );
                },
                child: Column(
                  children: [
                    const IconButton(
                      icon: Icon(Icons.person),
                      onPressed: null,
                      iconSize: 35,
                    ), 
                    Text(
                      'INFO', // Tiny text
                      style: GoogleFonts.poppins( // Use Google Fonts
                        fontSize: 12, // Adjust font size as needed
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
