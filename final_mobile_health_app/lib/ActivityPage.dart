import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'step_count_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage();

  static String id = "ActivityPage";

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  final _auth = FirebaseAuth.instance;
  User? loggedInUser;
  DateFormat dateFormat = DateFormat('dd-MM-yyyy');

  int myIndex = 1;
  String formatString = 'dd-MM-yyyy';
  DateTime _selectedDate = DateTime.now();
  String FF = DateFormat('dd-MM-yyyy').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  void initializeData() async {
    await getCurrentUser();
    String formatString = 'dd-MM-yyyy';

    setState(() {
      steps = 0;
      distance = 0.0;
      calories = 0.0;
    });

    String tt = DateFormat(formatString).format(DateTime.now());
    await fetchDataAndPrint(loggedInUser!.email, tt);
  }

  getCurrentUser() async {
    try {
      final user = await _auth.currentUser!;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser?.email);
      }
    } catch (e) {
      print(e);
    }
  }

  void _openCalendar() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          child: SingleChildScrollView(
            child: TableCalendar(
              firstDay: DateTime.utc(2021, 1, 1),
              lastDay: DateTime.utc(2023, 12, 31),
              focusedDay: DateTime.now(),
              calendarFormat: CalendarFormat.month,
              availableCalendarFormats: const {
                CalendarFormat.month: 'Month',
                CalendarFormat.week: 'Week',
              },
              selectedDayPredicate: (day) {
                return isSameDay(day, _selectedDate);
              },
              onDaySelected: (selectedDay, focusedDay) {
                Navigator.pop(context); // Close the bottom sheet when a date is selected
                String formatString = 'dd-MM-yyyy';
                setState(() {
                  _selectedDate = selectedDay;
                  FF = DateFormat(formatString).format(selectedDay);
                  String? formattedDate = DateFormat(formatString).format(_selectedDate);
                  fetchDataAndPrint(loggedInUser!.email, formattedDate);
                });
              },
            ),
          ),
        );
      },
    );
  }

  int? steps = 0;
  double? distance = 0.0;
  double? calories = 0.0;

  fetchDataAndPrint(String? userId, String formattedDate) async {
    try {
      User? user = await getCurrentUser();
      if (user != null) {
        userId = user.email;
      }

      Map<String, dynamic> activityData =
      await fetchDailyStepsData(userId, formattedDate);

      // Use the activityData map for your application logic or display
      print('Activity Data for $formattedDate: $activityData');

      double totalSteps = 0;
      double totalDistance = 0.0;
      double totalCalories = 0.0;

      // Iterate through the data to calculate the totals
      activityData.forEach((key, value) {
        totalSteps += value['Steps'] ?? 0;
        totalDistance += value['Distance'] ?? 0.0;
        totalCalories += value['Calories'] ?? 0.0;
      });

      // Update the variables used in the UI with the calculated totals
      setState(() {
        steps = totalSteps.toInt();
        distance = totalDistance/1000;
        calories = totalCalories/1000;
      });

      print('Total Steps: $totalSteps, Total Distance: $totalDistance, Total Calories: $totalCalories');
    } catch (e) {
      // Handle any errors that occur during the data fetch
      print('Error fetching activity data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Activity', style: GoogleFonts.montserrat(fontWeight: FontWeight.bold)),
        leading: null ,
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: _openCalendar, // Call _openCalendar() to show the calendar
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Total",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Montserrat'),
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Text("$steps", style: TextStyle(fontFamily: 'Montserrat',fontSize: 20,color: Colors.blueAccent,fontWeight: FontWeight.bold)),
                    Text("steps",style: TextStyle(fontFamily: 'Montserrat',fontSize: 16,color: Colors.blueAccent,fontWeight: FontWeight.bold))
                  ],
                ),
                SizedBox(height: 5),
                Text(
                  "$FF",
                  style: TextStyle(fontSize: 16, fontFamily: 'Montserrat'),
                ),
                SizedBox(height: 20),

                SizedBox(height: 20),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment:CrossAxisAlignment.start,
                      children: [
                        Text("Move",style: TextStyle(fontSize: 16,fontWeight:FontWeight.w500, fontFamily: 'Montserrat')),
                        Row(
                          children: [
                            Text("$calories", style: TextStyle(fontFamily: 'Montserrat',fontSize: 20,color: Colors.orange,fontWeight: FontWeight.bold)),
                            Text("KCAL",style: TextStyle(fontFamily: 'Montserrat',fontSize: 16,color: Colors.orange,fontWeight: FontWeight.bold))
                          ],
                        ),
                      ],
                    ),
                    SizedBox(width: 70,),
                    Column(
                      crossAxisAlignment:CrossAxisAlignment.start,
                      children: [
                        Text("Distance",style: TextStyle(fontSize: 16,fontWeight:FontWeight.w500, fontFamily: 'Montserrat')),
                        Row(
                          children: [
                            Text("$distance", style: TextStyle(fontFamily: 'Montserrat',fontSize: 20,fontWeight: FontWeight.bold,color: Colors.red,)),
                            Text("KM",style: TextStyle(fontFamily: 'Montserrat',fontSize: 16,fontWeight: FontWeight.bold,color: Colors.red))
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Divider(height: 2, thickness: 2),
                SizedBox(height: 30),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      Text(
                        "Highlights",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      Spacer(),
                      TextButton(
                        onPressed: () {
                          // Handle "Edit" button pressed
                        },
                        child: Text("Show All", style: TextStyle(fontFamily: 'Montserrat')),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 50),
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xffE3E3E3),
                  ),
                  height: 200,
                  child: Container(
                    child: Text(
                      "Step count is the number of steps you take throughout the day. Pedometers and digital activity "
                          "trackers can help you determine your step count. These devices count steps for any activity "
                          "that involves step-like movement, including walking, running, stair climbing, cross-country skiing, and "
                          "even movement as you go about your daily chores.",
                      style: TextStyle(fontSize: 16, fontFamily: 'Montserrat'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            myIndex = index;
          });
          if (myIndex == 0) {
            Navigator.pushNamed(context, HomePage.id);
          }
          if (myIndex == 1) {
            Navigator.pushNamed(context, ActivityPage.id);
          }
        },
        currentIndex: myIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_walk_sharp),
            label: "Activity",
          ),
        ],
      ),
    );
  }
}
