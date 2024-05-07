import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pie_chart/pie_chart.dart';

class StatPage extends StatelessWidget {
  const StatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, double> dataMap = {
      "Angry": 1,
      "Excited": 2,
      "Happy": 3,
      "Uncomfortable": 4,
      "Confused": 5,
      "Chill": 6,
      "Calm": 7,
      "Embarrassed": 8,
      "Bored": 9,
      "Sad": 10,
      "Worried": 11,
    };

    final List<Color> colorList = [
      const Color.fromRGBO(255, 0, 34, 1),
      const Color.fromRGBO(254, 105, 0, 1),
      const Color.fromRGBO(255, 245, 0, 1),
      const Color.fromRGBO(157, 156, 194, 1),
      const Color.fromRGBO(0, 148, 122, 1),
      const Color.fromRGBO(108, 217, 164, 1),
      const Color.fromRGBO(89, 251, 234, 1),
      const Color.fromRGBO(252, 169, 255, 1),
      const Color.fromRGBO(0, 153, 218, 1),
      const Color.fromRGBO(0, 5, 133, 1),
      const Color.fromRGBO(129, 58, 173, 1),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 254, 234, 1), // Set background color to match the container
        elevation: 0, // Remove the elevation
        title: Padding(
          padding: const EdgeInsets.only(top: 30), // Adjust top padding to move the text down
          child: Row(
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
        ),
      ),
      body: Container(
        color: Color.fromRGBO(255, 254, 234, 1),
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: PieChart(
                        dataMap: dataMap,
                        colorList: colorList,
                        chartType: ChartType.ring,
                        chartValuesOptions: ChartValuesOptions(
                          showChartValues: true,
                          showChartValuesInPercentage: true,
                          showChartValueBackground: false,
                          showChartValuesOutside: true,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
