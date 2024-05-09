import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:intl/intl.dart'; // Import DateFormat
import 'package:mood_palette/widget/navbar.dart';

class StatPage extends StatefulWidget {
  const StatPage({Key? key}) : super(key: key);

  @override
  _StatPageState createState() => _StatPageState();
}

class _StatPageState extends State<StatPage> {
  late DateTime _currentMonth; // Add current month variable
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime.now(); // Initialize current month
    _pageController = PageController(
      initialPage: _currentMonth.month - 1,
    );
  }

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
                        _buildHeader(), // Add month selection header
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

  Widget _buildHeader() {
    // Checks if the current month is the last month of the year (December)
    bool isLastMonthOfYear = _currentMonth.month == 12;

    return Column(
      children: [
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
                  // Moves to the previous page if the current page index is greater than 0
                  if (_pageController.page! > 0) {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
              ),
              DropdownButton<String>(
                // Dropdown for selecting a month
                underline: const SizedBox(),
                dropdownColor: Colors.grey[700],
                iconSize: 0.0,
                style: const TextStyle(color: Colors.white),
                value: DateFormat('MMMM').format(_currentMonth),
                onChanged: (String? selectedMonth) {
                  if (selectedMonth != null) {
                    setState(() {
                      // Updates the current month based on the selected month
                      _currentMonth = DateTime.parse(
                          '${DateTime.now().year}-$selectedMonth-01');

                      // Calculates the month index based on the selected month and sets the page
                      int monthIndex = _currentMonth.month - 1;
                      _pageController.jumpToPage(monthIndex);
                    });
                  }
                },
                items: [
                  // Generates DropdownMenuItems for each month
                  for (int month = 1; month <= 12; month++)
                    DropdownMenuItem<String>(
                      value: DateFormat('MMMM')
                          .format(DateTime(DateTime.now().year, month, 1)),
                      child: Text(DateFormat('MMMM')
                          .format(DateTime(DateTime.now().year, month, 1))),
                    ),
                ],
              ),
              DropdownButton<int>(
                // Dropdown for selecting a year
                underline: const SizedBox(),
                style: const TextStyle(color: Colors.white),
                dropdownColor: Colors.grey[700],
                iconSize: 0.0,
                value: _currentMonth.year,
                onChanged: (int? year) {
                  if (year != null) {
                    setState(() {
                      // Sets the current month to January of the selected year
                      _currentMonth = DateTime(year, 1, 1);

                      // Calculates the month index based on the selected year and sets the page
                      int yearDiff = DateTime.now().year - year;
                      int monthIndex = 12 * yearDiff + _currentMonth.month - 1;
                      _pageController.jumpToPage(monthIndex);
                    });
                  }
                },
                items: [
                  // Generates DropdownMenuItems for a range of years from current year to 10 years ahead
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
                  // Moves to the next page if it's not the last month of the year
                  if (!isLastMonthOfYear) {
                    setState(() {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
