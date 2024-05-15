import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pie_chart/pie_chart.dart';
// import 'package:intl/intl.dart';
import 'package:mood_palette/widget/navbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mood_palette/main.dart';
// import 'package:jwt_decoder/jwt_decoder.dart';

class StatPage extends StatefulWidget {
  const StatPage({Key? key}) : super(key: key);

  @override
  _StatPageState createState() => _StatPageState();
}

class _StatPageState extends State<StatPage> {
  Map<String, double> moodData = {};
  bool dataFetched = false;

  Map<String, Color> moodColors = {
    'Angry': const Color.fromRGBO(255, 0, 34, 1),
    'Excited': const Color.fromRGBO(254, 105, 0, 1),
    'Happy': const Color.fromRGBO(255, 245, 0, 1),
    'Uncomfortable': const Color.fromRGBO(157, 156, 194, 1),
    'Confused': const Color.fromRGBO(0, 148, 122, 1),
    'Chill': const Color.fromRGBO(108, 217, 164, 1),
    'Calm': const Color.fromRGBO(89, 251, 234, 1),
    'Embarrassed': const Color.fromRGBO(252, 169, 255, 1),
    'Bored': const Color.fromRGBO(0, 153, 218, 1),
    'Sad': const Color.fromRGBO(0, 5, 133, 1),
    'Worried': const Color.fromRGBO(129, 58, 173, 1),
  };
  @override
  void initState() {
    super.initState();
    fetchMoodData();
  }

  void fetchMoodData() async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/getmood'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${GlobalVariables.instance.token}',
        },
        body: jsonEncode({'user_id': GlobalVariables.instance.token}),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);

        // Assuming mood data is under the key 'data'
        List<dynamic> moodDataList = data['data'];

        // Filter mood data for the current month
        DateTime now = DateTime.now();
        int currentYear = now.year;
        int currentMonth = now.month;
        int currentDay = now.day; // Current day

        moodDataList = moodDataList.where((item) {
          // Parse the date
          String dateString =
              item['date'].substring(0, 10); // Extract yyyy-MM-dd part
          DateTime date = DateTime.parse(dateString); // Parse date
          date = date.add(Duration(days: 1)); // Add one day to the date
          print('Processing date: $date');
          int itemYear = date.year;
          int itemMonth = date.month;
          int itemDay = date.day; // Day from fetched data

          // Compare dates without considering the time part
          return itemYear == currentYear &&
              itemMonth == currentMonth &&
              itemDay >= 1 &&
              itemDay <= DateTime(itemYear, itemMonth + 1, 0).day;
        }).toList();

        setState(() {
          moodData = {}; // Clear previous data
          moodDataList.forEach((item) {
            String mood = item['mood'];
            moodData[mood] = (moodData[mood] ?? 0) + 1;
          });

          dataFetched = true;
        });
      } else {
        print('Failed to fetch mood data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching mood data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!dataFetched) {
      return Scaffold(
        backgroundColor: const Color.fromRGBO(255, 254, 234, 1),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color.fromRGBO(255, 254, 234, 1),
          elevation: 0,
          title: Padding(
            padding: const EdgeInsets.only(top: 30),
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
                const Icon(Icons.calendar_today),
              ],
            ),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    double sum = moodData.isNotEmpty
        ? moodData.values.reduce((value, element) => value + element)
        : 0.0;
    final normalizedDataMap =
        moodData.map((key, value) => MapEntry(key, (value / sum) * 100));

    List<MapEntry<String, double>> sortedEntries = normalizedDataMap.entries
        .map((entry) => MapEntry<String, double>(entry.key, entry.value))
        .toList()
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
        backgroundColor: const Color.fromRGBO(255, 254, 234, 1),
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(top: 30),
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
              const Icon(Icons.calendar_today),
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
                        const SizedBox(height: 20),
                        if (moodData.isNotEmpty)
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              AspectRatio(
                                aspectRatio: 1,
                                child: PieChart(
                                  dataMap: Map<String, double>.fromEntries(
                                      sortedEntries),
                                  animationDuration:
                                      const Duration(milliseconds: 800),
                                  chartLegendSpacing: 1,
                                  chartRadius:
                                      MediaQuery.of(context).size.width / 2,
                                  colorList: moodData.keys
                                      .map((mood) =>
                                          moodColors[mood] ?? Colors.black)
                                      .toList(),
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
                                  fontFamily:
                                      GoogleFonts.singleDay().fontFamily,
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
                        if (moodData.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text(
                              'No mood data available.',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children:
                                List.generate(sortedEntries.length, (index) {
                              final entry = sortedEntries[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5.0),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      color:
                                          moodColors[entry.key] ?? Colors.black,
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
                                            backgroundColor: Colors.grey[300],
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              moodColors[entry.key] ??
                                                  Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      '${(entry.value * sum / 100).toStringAsFixed(0)}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 50),
                                  ],
                                ),
                              );
                            }),
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
