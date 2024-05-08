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

  final Map<String, double> dataMap = {
    "Angry": 3,
    "Excited": 1,
    "Happy": 2,
    "Uncomfortable": 3,
    "Confused": 4,
    "Chill": 5,
    "Calm": 2,
    "Embarrassed": 0,
    "Bored": 3,
    "Sad": 1,
    "Worried": 1,
  };

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 80),
            Row(
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
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 0), // Adjust padding here
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
                    Container(
                      width: 215,
                      height: 35,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(91, 188, 255, 1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 1, vertical: 1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                currentMonthIndex =
                                    (currentMonthIndex - 1) % months.length;
                              });
                            },
                            icon: const Icon(Icons.arrow_back_ios),
                            color: Colors.white,
                            iconSize: 16,
                          ),
                          Text(
                            months[currentMonthIndex],
                            style: TextStyle(
                              fontSize: 24,
                              fontFamily: GoogleFonts.singleDay().fontFamily,
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                currentMonthIndex =
                                    (currentMonthIndex + 1) % months.length;
                              });
                            },
                            icon: const Icon(Icons.arrow_forward_ios),
                            color: Colors.white,
                            iconSize: 16,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20), // Adjust spacing here
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
                            chartRadius: MediaQuery.of(context).size.width / 2,
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
                                fontFamily: GoogleFonts.poppins().fontFamily,
                              ),
                            ),
                            legendOptions: LegendOptions(
                              showLegends: false,
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
                        Text(
                          'Total: ${sum.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 36,
                            fontFamily: GoogleFonts.singleDay().fontFamily,
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5.0),
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
                                            value: entry.value /
                                                100, // assuming entry.value represents the percentage
                                            backgroundColor: Colors.grey[300],
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
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
          ],
        ),
      ),
    );
  }
}
