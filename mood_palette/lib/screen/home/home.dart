import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mood_palette/widget/navbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mood_palette/main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ignore: prefer_final_fields
  PageController _pageController =
      PageController(initialPage: DateTime.now().month - 1);

  DateTime _currentMonth = DateTime.now().subtract(const Duration(days: 1));
  bool selectedcurrentyear = false;
  List<dynamic> moodData = [];

  @override
  void initState() {
    super.initState();
    fetchMoodData();
  }

  void fetchMoodData() async {
    try {
      // Make the HTTP POST request
      final response = await http.post(
        Uri.parse('http://localhost:3000/getmood'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${GlobalVariables.instance.token}',
        },
        body: jsonEncode({
          'user_id': GlobalVariables.instance.token
        }), // Empty body or pass any required data
      );

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // Parse the JSON response directly into a list of maps
        print('Succeed to fetch mood data: ${response.statusCode}');
        final Map<String, dynamic> fetchedMoodData = json.decode(response.body);
        print('fetchedd mood data: ${fetchedMoodData['data']}');
        // Store the fetched mood data in the moodData list
        setState(() {
          moodData = fetchedMoodData['data'];
          // print(moodData);
        });
      } else {
        // Handle other status codes (e.g., 400, 401, etc.)
        print('Failed to fetch mood data: ${response.statusCode}');
      }
    } catch (error) {
      // Handle any errors that occur during the process
      print('Error fetching mood data: $error');
    }
  }

  bool hasLoggedMoodForToday() {
    DateTime today = DateTime.now();
    return moodData.any((mood) {
      DateTime moodDate = DateTime.parse(mood['date']);
      return moodDate.year == today.year &&
          moodDate.month == today.month &&
          moodDate.day == today.day;
    });
  }

  void addMood(String mood) async {
    Navigator.of(context).pop();
    if (hasLoggedMoodForToday()) {
      // Show a message that the user has already logged a mood today
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You have already logged your mood today.'),
        ),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/addmood'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${GlobalVariables.instance.token}',
        },
        body: jsonEncode({
          'user_id': GlobalVariables.instance.token,
          'mood': mood,
          'log_date': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        print('Mood added successfully: ${response.statusCode}');
        fetchMoodData();
        setState(() {});
      } else {
        print('Failed to add mood: ${response.statusCode}');
      }
    } catch (error) {
      print('Error adding mood: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
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
      body: Center(
        child: Column(
          children: [
            Container(
              constraints: BoxConstraints(
                  minWidth: 200.0,
                  maxWidth: 800.0,
                  minHeight: 200,
                  maxHeight: screenHeight - 246),
              child: Column(
                children: [
                  _buildHeader(),
                  const SizedBox(
                      height: 20), // Add space between the header and the weeks
                  _buildWeeks(),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentMonth =
                              DateTime(_currentMonth.year, index + 1, 1);
                        });
                      },
                      itemCount:
                          12 * 10, // Show 10 years, adjust this count as needed
                      itemBuilder: (context, pageIndex) {
                        DateTime month = DateTime(
                            _currentMonth.year, (pageIndex % 12) + 1, 1);
                        return buildCalendar(month, moodData);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const NavBar(),
          ],
        ),
      ),
    );
  }

  // Write a Widget code from here
  // Widget _buildHeader() {--}
  Widget _buildHeader() {
    // Checks if the current month is the last month of the year (December)
    bool isLastMonthOfYear = _currentMonth.month == 12;

    return Column(
      children: [
        const SizedBox(height: 30),
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
              DropdownButton<int>(
                // Dropdown for selecting a month
                underline: const SizedBox(),
                dropdownColor: Colors.grey[700],
                iconSize: 0.0,
                style: const TextStyle(color: Colors.white),
                value: _currentMonth.month,
                onChanged: (int? selectedMonth) {
                  if (selectedMonth != null) {
                    setState(() {
                      // Updates the current month based on the selected month
                      _currentMonth =
                          DateTime(_currentMonth.year, selectedMonth, 1);

                      // Calculates the month index based on the selected month and sets the page
                      int monthIndex = selectedMonth - 1;
                      _pageController.jumpToPage(monthIndex);
                    });
                  }
                },
                items: [
                  // Generates DropdownMenuItems for each month
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

  //  Widget _buildWeeks() {--}
  Widget _buildWeeks() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildWeekDay('Mon'),
          _buildWeekDay('Tue'),
          _buildWeekDay('Wed'),
          _buildWeekDay('Thu'),
          _buildWeekDay('Fri'),
          _buildWeekDay('Sat'),
          _buildWeekDay('Sun'),
        ],
      ),
    );
  }

  Widget _buildWeekDay(String day) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Text(
        day,
        style: GoogleFonts.poppins(
          // Use Google Fonts
          fontSize: 15,
        ),
      ),
    );
  }

  // Modify the _buildCalendar method to accept mood data
  Widget buildCalendar(DateTime month, List<dynamic> moodData) {
    // Calculating various details for the month's display
    int daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    DateTime firstDayOfMonth = DateTime(month.year, month.month, 1);
    int weekdayOfFirstDay = firstDayOfMonth.weekday;

    DateTime lastDayOfPreviousMonth =
        firstDayOfMonth.subtract(const Duration(days: 1));

    int daysInPreviousMonth = lastDayOfPreviousMonth.day;

    bool checkMoodDataForToday() {
      DateTime today = DateTime.now();
      return moodData.any((mood) {
        DateTime moodDate = DateTime.parse(mood['date']);
        return moodDate.year == today.year &&
            moodDate.month == today.month &&
            moodDate.day == today.day;
      });
    }

    // Store the result in the hasMoodDataForToday variable
    bool hasMoodDataForToday = checkMoodDataForToday();

    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
      ),
      itemCount: daysInMonth + weekdayOfFirstDay - 1,
      itemBuilder: (context, index) {
        if (index < weekdayOfFirstDay - 1) {
          // Calculate the day from the previous month
          int previousMonthDay =
              daysInPreviousMonth - (weekdayOfFirstDay - 1) + index;
          DateTime date =
              DateTime(month.year, month.month - 1, previousMonthDay);

          return buildDayContainer(
              previousMonthDay,
              const Color.fromRGBO(217, 217, 217, 1),
              date,
              hasMoodDataForToday);
        } else {
          // Calculate the day within the current month
          DateTime date =
              DateTime(month.year, month.month, index - weekdayOfFirstDay + 2);
          Color dayColor = const Color.fromRGBO(217, 217, 217, 1);

          // Check if the mood data contains a mood for the current date
          Map<String, dynamic>? mood = moodData.firstWhere(
            (mood) =>
                DateTime.parse(mood['date']).year == date.year &&
                DateTime.parse(mood['date']).month == date.month &&
                DateTime.parse(mood['date']).day == date.day,
            orElse: () =>
                <String, dynamic>{}, // return an empty map instead of null
          );
          // If mood data exists, determine the color based on the mood
          if (mood != null) {
            // print('Mood: ${mood['mood']}');
            switch (mood['mood']) {
              case 'Angry':
                dayColor = const Color.fromRGBO(255, 0, 34, 1);
                break;
              case 'Sad':
                dayColor = const Color.fromRGBO(0, 5, 133, 1);
                break;
              case 'Calm':
                dayColor = const Color.fromRGBO(89, 251, 234, 1);
                break;
              case 'Worried':
                dayColor = const Color.fromRGBO(129, 58, 173, 1);
                break;
              case 'Embarrassed':
                dayColor = const Color.fromRGBO(252, 169, 255, 1);
                break;
              case 'Uncomfortable':
                dayColor = const Color.fromRGBO(157, 156, 194, 1);
                break;
              case 'Confused':
                dayColor = const Color.fromRGBO(0, 148, 122, 1);
                break;
              case 'Excited':
                dayColor = const Color.fromRGBO(254, 105, 0, 1);
                break;
              case 'Happy':
                dayColor = const Color.fromRGBO(255, 245, 0, 1);
                break;
              case 'Bored':
                dayColor = const Color.fromRGBO(0, 153, 218, 1);
                break;
              case 'Chill':
                dayColor = const Color.fromRGBO(108, 217, 164, 1);
                break;
              default:
                // Handle unknown mood
                dayColor = const Color.fromRGBO(217, 217, 217, 1);
                break;
            }
          }

          return InkWell(
            child: buildDayContainer(
                date.day, dayColor, date, hasMoodDataForToday),
          );
        }
      },
    );
  }

  Widget buildDayContainer(
      dynamic content, Color color, DateTime date, bool hasMoodDataForToday) {
    // Check if the date is today
    bool isToday = date.year == DateTime.now().year &&
        date.month == DateTime.now().month &&
        date.day == DateTime.now().day;

    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: GestureDetector(
        onTap: () {
          if (isToday) {
            showModalBottomSheet(
              context: context,
              backgroundColor: const Color.fromRGBO(255, 209, 227, 1),
              isScrollControlled: true,
              builder: (context) {
                return SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Container(
                    // constraints: BoxConstraints(
                    //   maxHeight: MediaQuery.of(context).size.height * 0.6,
                    // ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(45),
                        topRight: Radius.circular(45),
                      ),
                      child: Container(
                        color: const Color.fromRGBO(255, 209, 227, 1),
                        width: double.infinity,
                        padding: const EdgeInsets.all(5),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              width: 305,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: Center(
                                child: Text(
                                  'How are you feeling today?',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Container(
                                decoration: const BoxDecoration(),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _buildColorBlock(0xFFFF0022, 'Angry'),
                                        _buildColorBlock(0xFFFE6900, 'Excited'),
                                        _buildColorBlock(0xFFFFF500, 'Happy'),
                                        _buildlongColorBlock(
                                            0xFF9D9CC2, 'Uncomfortable'),
                                        _buildColorBlock(
                                            0xFF00947A, 'Confused'),
                                      ]
                                          .map((widget) =>
                                              Expanded(child: widget))
                                          .toList(),
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _buildColorBlock(0xFF6CD9A4, 'Chill'),
                                        _buildColorBlock(0xFF59FBEA, 'Calm'),
                                        _buildlongColorBlock(
                                            0xFFFCA9FF, 'Embarassed'),
                                        _buildColorBlock(0xFF0099DA, 'Bored'),
                                        _buildColorBlock(0xFF000585, 'Sad'),
                                      ]
                                          .map((widget) =>
                                              Expanded(child: widget))
                                          .toList(),
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _buildColorBlock(0xFF813AAD, 'Worried'),
                                        _buildInvisibleColorBlock(),
                                        _buildInvisibleColorBlock(),
                                        _buildInvisibleColorBlock(),
                                        _buildInvisibleColorBlock(),
                                      ]
                                          .map((widget) =>
                                              Expanded(child: widget))
                                          .toList(),
                                    ),
                                    const SizedBox(
                                      height: 40,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
        child: Column(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                double screenWidth = MediaQuery.of(context).size.width;
                double size = screenWidth * 0.066;
                if (screenWidth >= 1000) {
                  size = 1000 * 0.066;
                } else if (screenWidth >= 600) {
                  size = screenWidth * 0.066;
                } else if (screenWidth >= 450) {
                  size = 40;
                } else if (screenWidth >= 400) {
                  size = 35;
                } else {
                  size = 30;
                }
                return Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0),
                    color: color,
                  ),
                  child: Center(
                    child: (() {
                      if ((date.year == DateTime.now().year &&
                              date.month == DateTime.now().month &&
                              date.day == DateTime.now().day + 1) &&
                          hasMoodDataForToday) {
                        return const Icon(Icons.add, color: Colors.white);
                      } else if ((date.year == DateTime.now().year &&
                              date.month == DateTime.now().month &&
                              date.day == DateTime.now().day) &&
                          !hasMoodDataForToday) {
                        return const Icon(Icons.add,
                            color: Color.fromRGBO(126, 161, 255, 1));
                      } else {
                        return null;
                      }
                    })(),
                  ),
                );
              },
            ),
            const SizedBox(
                height: 3), // Adjust spacing between the box and the text
            Text(
              content.toString(),
              style: const TextStyle(
                fontSize: 10.0,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
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
              fontSize: 10,
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
              fontSize: 8,
            ),
          ),
        ],
      ),
    );
  }
}