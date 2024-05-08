import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pie_chart/pie_chart.dart';

class StatPage extends StatefulWidget {
  const StatPage({Key? key}) : super(key: key);

  @override
  _StatPageState createState() => _StatPageState();
}

class _StatPageState extends State<StatPage> {
  int currentMonthIndex = 0;
  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  @override
  Widget build(BuildContext context) {
    final Map<String, double> dataMap = {
      "Angry": 3,
      "Excited": 1,
      "Happy": 2,
      "Uncomfortable": 3,
      "Confused": 4,
      "Chill": 5,
      "Calm": 6,
      "Embarrassed": 7,
      "Bored": 8,
      "Sad": 11,
      "Worried": 10,
    };

    double sum = dataMap.values.reduce((value, element) => value + element);
    final normalizedDataMap = dataMap.map((key, value) => MapEntry(key, (value / sum) * 100));

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
          padding: const EdgeInsets.only(
              top: 30), // Adjust top padding to move the text down
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
        color: Color.fromRGBO(255, 254, 234, 1), // Set background color here
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      currentMonthIndex = (currentMonthIndex - 1) % months.length;
                    });
                  },
                  icon: Icon(Icons.arrow_back_ios),
                ),
                Text(
                  months[currentMonthIndex],
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      currentMonthIndex = (currentMonthIndex + 1) % months.length;
                    });
                  },
                  icon: Icon(Icons.arrow_forward_ios),
                ),
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
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: AspectRatio(
                    aspectRatio: 0.6,
                    child: PieChart(
                      dataMap: normalizedDataMap,
                      animationDuration: Duration(milliseconds: 800),
                      chartLegendSpacing: 50,
                      chartRadius: MediaQuery.of(context).size.width / 2,
                      colorList: colorList,
                      initialAngleInDegree: 0,
                      chartType: ChartType.ring,
                      ringStrokeWidth: 70,
                      chartValuesOptions: ChartValuesOptions(
                        showChartValues: true,
                        showChartValuesInPercentage: true,
                        showChartValueBackground: false,
                        showChartValuesOutside: true,
                        decimalPlaces: 0,
                        chartValueStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                        ),
                      ),
                      legendOptions: LegendOptions(
                        showLegends: true,
                        legendPosition: LegendPosition.bottom,
                        legendShape: BoxShape.circle,
                        legendTextStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
