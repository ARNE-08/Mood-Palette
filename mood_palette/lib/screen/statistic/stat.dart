import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:intl/intl.dart';
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
  final PageController _pageController =
      PageController(initialPage: DateTime.now().month - 1);

  DateTime _currentMonth = DateTime.now().subtract(const Duration(days: 1));
  bool selectedcurrentyear = false;

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
    fetchMoodData(_currentMonth.year, _currentMonth.month);
  }

  void fetchMoodData(int year, int month) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/getmood'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${GlobalVariables.instance.token}',
        },
        body: jsonEncode({
          'user_id': GlobalVariables.instance.token,
          'year': year,
          'month': month,
        }),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);

        // Assuming mood data is under the key 'data'
        List<dynamic> moodDataList = data['data'];

        setState(() {
          moodData = {}; // Clear previous data

          if (moodDataList.isEmpty) {
            // Set all mood values to 0 if no data is available
            moodColors.keys.forEach((mood) {
              moodData[mood] = 0;
            });
          } else {
            moodDataList = moodDataList.where((item) {
              DateTime date = DateTime.parse(item['date']).toLocal();
              return date.year == year && date.month == month;
            }).toList();

            moodDataList.forEach((item) {
              String mood = item['mood'];
              moodData[mood] = (moodData[mood] ?? 0) + 1;
            });
          }

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
    double sum = moodData.isNotEmpty
        ? moodData.values.reduce((value, element) => value + element)
        : 0.0;
    final normalizedDataMap =
        moodData.map((key, value) => MapEntry(key, (value / sum) * 100));

    List<MapEntry<String, double>> sortedEntries = normalizedDataMap.entries
        .map((entry) => MapEntry<String, double>(entry.key, entry.value))
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));

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
                                aspectRatio: 0.8,
                                child: PieChart(
                                  dataMap: Map<String, double>.fromEntries(
                                      sortedEntries), // Use sortedEntries to populate dataMap
                                  colorList: sortedEntries
                                      .map((entry) =>
                                          moodColors[entry.key] ?? Colors.black)
                                      .toList(), // Use moodColors for colorList
                                  chartType: ChartType.ring,
                                  ringStrokeWidth: 60,
                                  chartRadius:
                                      MediaQuery.of(context).size.width * 0.6,
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
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Render pie chart with value 0
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  AspectRatio(
                                    aspectRatio: 0.8,
                                    child: PieChart(
                                      dataMap: moodColors.map((key, value) =>
                                          MapEntry(
                                              key, 0)), // Set all values to 0
                                      colorList: moodColors.values
                                          .toList(), // Use moodColors for colors
                                      chartType: ChartType.ring,
                                      ringStrokeWidth: 60,
                                      chartRadius:
                                          MediaQuery.of(context).size.width *
                                              0.6,
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
                              // Render progress bars with value 0 for each mood
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: moodColors.entries.map((entry) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 20,
                                            height: 20,
                                            color:
                                                entry.value, // Use mood color
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
                                                Stack(
                                                  children: [
                                                    Container(
                                                      height: 10,
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey[300],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                    ),
                                                    FractionallySizedBox(
                                                      widthFactor:
                                                          0, // Set width factor to 0
                                                      child: Container(
                                                        height: 10,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: entry
                                                              .value, // Use mood color
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      '0', // Set count to 0
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      '0%', // Set percentage to 0
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children:
                                List.generate(sortedEntries.length, (index) {
                              final entry = sortedEntries[index];
                              final double percentage = entry.value;
                              final int count =
                                  (percentage * sum / 100).toInt();
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
                                          Stack(
                                            children: [
                                              Container(
                                                height: 10,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[300],
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                              ),
                                              FractionallySizedBox(
                                                widthFactor: percentage / 100,
                                                child: Container(
                                                  height: 10,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        moodColors[entry.key] ??
                                                            Colors.black,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '$count',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Text(
                                                '${percentage.toStringAsFixed(0)}%',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
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
          _buildHeader(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    bool isLastMonthOfYear = _currentMonth.month == 12;

    return Center(
      child: Column(
        children: [
          const SizedBox(height: 70),
          Container(
            width: 215,
            height: 35,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(91, 188, 255, 1),
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  color: Colors.white,
                  iconSize: 12,
                  onPressed: () {
                    setState(() {
                      _currentMonth = DateTime(
                          _currentMonth.year, _currentMonth.month - 1, 1);
                      fetchMoodData(_currentMonth.year, _currentMonth.month);
                      int monthIndex = _currentMonth.month - 1;
                      _pageController.jumpToPage(monthIndex);
                    });
                  },
                ),
                DropdownButton<int>(
                  underline: const SizedBox(),
                  dropdownColor: Colors.grey[700],
                  iconSize: 0.0,
                  style: const TextStyle(color: Colors.white),
                  value: _currentMonth.month,
                  onChanged: (int? selectedMonth) {
                    if (selectedMonth != null) {
                      setState(() {
                        _currentMonth =
                            DateTime(_currentMonth.year, selectedMonth, 1);
                        fetchMoodData(_currentMonth.year, selectedMonth);
                        int monthIndex = selectedMonth - 1;
                        _pageController.jumpToPage(monthIndex);
                      });
                    }
                  },
                  items: [
                    for (int month = 1; month <= 12; month++)
                      DropdownMenuItem<int>(
                        value: month,
                        child: Text(
                          DateFormat('MMMM')
                              .format(DateTime(_currentMonth.year, month, 1)),
                        ),
                      ),
                  ],
                ),
                DropdownButton<int>(
                  underline: const SizedBox(),
                  style: const TextStyle(color: Colors.white),
                  dropdownColor: Colors.grey[700],
                  iconSize: 0.0,
                  value: _currentMonth.year,
                  onChanged: (int? year) {
                    if (year != null) {
                      setState(() {
                        _currentMonth = DateTime(year, 1, 1);
                        fetchMoodData(year, _currentMonth.month);
                        int yearDiff = DateTime.now().year - year;
                        int monthIndex =
                            12 * yearDiff + _currentMonth.month - 1;
                        _pageController.jumpToPage(monthIndex);
                      });
                    }
                  },
                  items: [
                    for (int year = DateTime.now().year;
                        year <= DateTime.now().year + 10;
                        year++)
                      DropdownMenuItem<int>(
                        value: year,
                        child: Text(
                          year.toString(),
                        ),
                      ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  color: Colors.white,
                  iconSize: 12,
                  onPressed: () {
                    setState(() {
                      _currentMonth = DateTime(
                          _currentMonth.year, _currentMonth.month + 1, 1);
                      fetchMoodData(_currentMonth.year, _currentMonth.month);
                      int monthIndex = _currentMonth.month - 1;
                      _pageController.jumpToPage(monthIndex);
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
