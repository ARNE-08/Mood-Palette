import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:intl/intl.dart';
import 'package:mood_palette/widget/navbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mood_palette/main.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class StatPage extends StatefulWidget {
  const StatPage({Key? key}) : super(key: key);

  @override
  _StatPageState createState() => _StatPageState();
}

class _StatPageState extends State<StatPage> {
  late Map<String, double> dataMap = {};
  late String token = ""; // Declare and initialize the token variable
  late int userId; // Declare userId variable

  @override
  void initState() {
    super.initState();
    token =
        GlobalVariables.instance.token; // Get the token from GlobalVariables
    userId = GlobalVariables.instance
        .userId; // Get the user ID directly from GlobalVariables // Get the user ID from GlobalVariables
    fetchMoodData(); // Fetch mood data when the widget is initialized
  }

 Future<void> fetchMoodData() async {
  final url = Uri.parse('http://localhost:3000/getmood?user_id=$userId');
  print('Fetching mood data for user_id: $userId');
  try {
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final Map<String, double> moodData = {};
      responseData.forEach((key, value) {
        if (value is num) {
          moodData[key] = value.toDouble(); // Parse value as double
        }
      });
      setState(() {
        dataMap = moodData;
      });
    } else {
      print('Failed to load mood data: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (e) {
    print('Error fetching mood data: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    // Check if dataMap is empty
    if (dataMap.isEmpty) {
      // Show a loading indicator or some placeholder widget
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(), // Show a loading indicator
        ),
      );
    }

    double sum = dataMap.values.reduce((value, element) => value + element);
    final normalizedDataMap =
        dataMap.map((key, value) => MapEntry(key, (value / sum) * 100));

    // Sort the normalizedDataMap entries by value in descending order
    var sortedEntries = normalizedDataMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

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
      backgroundColor: const Color.fromRGBO(255, 254, 234, 1),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromRGBO(
            255, 254, 234, 1), // Set background color to match the container
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
                  textStyle: const TextStyle(
                    fontSize: 36,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.calendar_today), // Calendar icon
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 7,
                          spreadRadius: 0,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        //_buildHeader(), // Add month selection header
                        const SizedBox(height: 20),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            AspectRatio(
                              aspectRatio: 1,
                              child: PieChart(
                                dataMap: Map.fromEntries(sortedEntries),
                                animationDuration:
                                    const Duration(milliseconds: 800),
                                chartLegendSpacing: 1,
                                chartRadius:
                                    MediaQuery.of(context).size.width / 2,
                                colorList: colorList,
                                initialAngleInDegree: 0,
                                chartType: ChartType.ring,
                                ringStrokeWidth: 60,
                                chartValuesOptions: ChartValuesOptions(
                                  showChartValues: false,
                                  showChartValuesInPercentage: true,
                                  showChartValueBackground: true,
                                  showChartValuesOutside: true,
                                  decimalPlaces: 0,
                                  chartValueStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                  ),
                                ),
                                legendOptions: LegendOptions(
                                  showLegends: false,
                                  legendPosition: LegendPosition.bottom,
                                  legendShape: BoxShape.circle,
                                  legendTextStyle: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              '${sum.toStringAsFixed(0)}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 36,
                                fontFamily: GoogleFonts.singleDay().fontFamily,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              '\n \n total count',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: sortedEntries
                                .map(
                                  (entry) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 20,
                                          height: 20,
                                          color: colorList[sortedEntries
                                              .map((e) => e.key)
                                              .toList()
                                              .indexOf(entry.key)],
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                entry.key,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              LinearProgressIndicator(
                                                value: entry.value / 100,
                                                backgroundColor:
                                                    Colors.grey[300],
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(
                                                  colorList[sortedEntries
                                                      .map((e) => e.key)
                                                      .toList()
                                                      .indexOf(entry.key)],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          '${dataMap[entry.key]?.toInt() ?? 0} / ${entry.value.toInt()}%',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 50),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: NavBar(),
          ),
        ],
      ),
    );
  }
}
