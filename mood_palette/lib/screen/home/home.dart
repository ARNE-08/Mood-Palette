import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mood_palette/widget/navbar.dart';
import 'dart:math';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ignore: prefer_final_fields
  PageController _pageController =
      PageController(initialPage: DateTime.now().month - 1);

  DateTime _currentMonth = DateTime.now();
  bool selectedcurrentyear = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
      body: Column(
        children: [
          _buildHeader(),
          _buildWeeks(),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentMonth = DateTime(_currentMonth.year, index + 1, 1);
                });
              },
              itemCount: 12 * 10, // Show 10 years, adjust this count as needed
              itemBuilder: (context, pageIndex) {
                DateTime month =
                    DateTime(_currentMonth.year, (pageIndex % 12) + 1, 1);
                return buildCalendar(month);
              },
            ),
          ),
          const NavBar(),
        ],
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
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  //  Widget _buildCalendar() {--}
  // This widget builds the detailed calendar grid for the chosen month.
  Widget buildCalendar(DateTime month) {
    // Calculating various details for the month's display
    int daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    DateTime firstDayOfMonth = DateTime(month.year, month.month, 1);
    int weekdayOfFirstDay = firstDayOfMonth.weekday;

    DateTime lastDayOfPreviousMonth =
        firstDayOfMonth.subtract(const Duration(days: 1));
    int daysInPreviousMonth = lastDayOfPreviousMonth.day;
    List<Color> randomColors = [
      const Color.fromRGBO(225, 0, 34, 1),
      const Color.fromRGBO(0, 5, 133, 1),
      const Color.fromRGBO(89, 251, 234, 1),
      const Color.fromRGBO(129, 58, 173, 1),
      const Color.fromRGBO(252, 169, 255, 1),
      const Color.fromRGBO(157, 156, 194, 1),
      const Color.fromRGBO(0, 148, 122, 1),
      const Color.fromRGBO(254, 105, 0, 1),
      const Color.fromRGBO(255, 245, 0, 1),
      const Color.fromRGBO(0, 153, 218, 1),
      const Color.fromRGBO(108, 217, 164, 1),
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
      ),
      // Calculating the total number of cells required in the grid
      itemCount: daysInMonth + weekdayOfFirstDay - 1,
      itemBuilder: (context, index) {
        if (index < weekdayOfFirstDay - 1) {
          // Displaying dates from the previous month in grey
          int previousMonthDay =
              daysInPreviousMonth - (weekdayOfFirstDay - index) + 2;
          DateTime date =
              DateTime(month.year, month.month, index - weekdayOfFirstDay + 2);

          return buildDayContainer(
              previousMonthDay,
              const Color.fromRGBO(217, 217, 217, 1),
              date); // Function to build day container
        } else {
          // Displaying the current month's days
          DateTime date =
              DateTime(month.year, month.month, index - weekdayOfFirstDay + 2);
          Color dayColor = date.isBefore(DateTime.now())
              ? randomColors[Random().nextInt(randomColors.length)]
              : const Color.fromRGBO(
                  217, 217, 217, 1); // Check if the date is before today
          String text = date.day.toString();

          return InkWell(
            onTap: () {
              // Handle tap on a date cell
            },
            child: buildDayContainer(
                text, dayColor, date), // Function to build day container
          );
        }
      },
    );
  }

  Widget buildDayContainer(dynamic content, Color color, DateTime date) {
    // Check if the date is today
    bool isToday = date.year == DateTime.now().year &&
        date.month == DateTime.now().month &&
        date.day == DateTime.now().day;

    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: GestureDetector(
        onTap: () {
          if (isToday) {
            // Handle tap to show bottom sheet
            showModalBottomSheet(
              context: context,
              builder: (context) {
                // Replace this with your bottom sheet widget
                return ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  child: Container(
                    color: Color.fromRGBO(255, 209, 227, 1),
                    height: 500,
                    width: double.infinity,
                    child: Column(
                      children: [
                        SizedBox(height: 20),
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
                                // Use Google Fonts
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20), // Add space between the header and the blocks
                        Wrap(
                          alignment: WrapAlignment.spaceEvenly,
                          children: [
                            _buildColorBlock(0xFFFF0022, 'Angry'),
                            _buildColorBlock(0xFFFE6900, 'Excited'),
                            _buildColorBlock(0xFFFFF500, 'Happy'),
                            _buildColorBlock(0xFF9D9CC2, 'Uncomfortable'),
                            _buildColorBlock(0xFF00947A, 'Confused'),
                            _buildColorBlock(0xFF6CD9A4, 'Chill'),
                            _buildColorBlock(0xFF59FBEA, 'Calm'),
                            _buildColorBlock(0xFFFCA9FF, 'Embarassed'),
                            _buildColorBlock(0xFF0099DA, 'Bored'),
                            _buildColorBlock(0xFF000585, 'Sad'),
                            _buildColorBlock(0xFF813AAD, 'Worried'),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: color,
                ),
                child: Center(
                  child: isToday ? Icon(Icons.add, color: Colors.white) : null,
                ),
              ),
            ),
            const SizedBox(
                height: 2), // Adjust spacing between the box and the text
            Text(
              content.toString(),
              style: TextStyle(
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
          8.0), // Add padding to create space between blocks
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color,
              borderRadius:
                  BorderRadius.circular(8), // Adjust the radius as needed
            ),
          ),
          const SizedBox(height: 10),
          Text(
            text,
            style: GoogleFonts.poppins(
              // Use Google Fonts
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}