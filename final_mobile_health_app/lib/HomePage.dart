import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_mobile_health_app/ActivityPage.dart';
import 'package:final_mobile_health_app/LoginPage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ProfilePage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pedometer/pedometer.dart';
import 'step_count_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

//String formatDate(DateTime d) {
 // return d.toString().substring(0, 19);
//}

class HomePage extends StatefulWidget {
  static String id = "HomePage";


  @override
  State<HomePage> createState() => _HomePageState();

}

class HomePageHelper {
  User? loggedInUser;
  final _auth = FirebaseAuth.instance;
  double userWeight = 0.0;
  double userCalorieGoal =0.0;
  dynamic userName ="";
  fetchUserName(String? email) async {
    dynamic Name =  await FirebaseService.fetchUserName(loggedInUser?.email);

    if (Name != null) {
      // Check if userrWeight is not null and is of type double
      userName = Name;
      print('userName: $userName');
      return userName;
    } else {
      print('User Name not available or nvalid.');
    }
  }


  fetchUserCalorieGoal(String? email) async {
    dynamic CalorieGoal = await  FirebaseService.fetchUserCalorieGoal(loggedInUser?.email);

    if (CalorieGoal != null && CalorieGoal is double) {
      // Check if userrWeight is not null and is of type double
      userCalorieGoal = CalorieGoal;
      print('User CalorieGoal: $userCalorieGoal');
      return userCalorieGoal;
    } else {
      print('User CalorieGoal not available or invalid.');
    }
  }
  fetchUserWeight(String? email) async {
    dynamic userrWeight = await FirebaseService.fetchUserData(loggedInUser?.email);
    if (userrWeight != null && userrWeight is double) {
      // Check if userrWeight is not null and is of type double
      userWeight = userrWeight;
      print('Userr weight: $userWeight');
      return userWeight;
    }
    else {
      print('User weight not available or nvalid.');
    }
  }

  void getCurrentUser() async{
    try {
      final user = await _auth.currentUser!;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser?.email);
        // Fetch user's weight from Firebase
        fetchUserWeight(loggedInUser?.email);
        fetchUserCalorieGoal(loggedInUser!.email);
      }
    } catch (e) {
      print(e);
    }
  }
}

class _HomePageState extends State<HomePage> {
  final _auth = FirebaseAuth.instance;
  HomePageHelper _helper = HomePageHelper();
  User? loggedInUser;
  int steps = 0;
  String status = "";
  double distance = 0.0;
  double calories = 0.0;
  double userWeight = 0.0;
  double userCalorieGoal =0.0;

  String get statuss => status;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
    initPlatformState();
  }

  getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser?.email);
        // Fetch user's weight and calorie goal from Firebase
        await fetchUserWeight(loggedInUser?.email);
        await fetchUserCalorieGoal(loggedInUser?.email);
      } else {
        Navigator.pushReplacementNamed(context, LoginPage.id);
      }
    } catch (e) {
      print(e);
    }
  }

  fetchUserCalorieGoal(String? email) async {
    // ...

      dynamic CalorieGoal =  await FirebaseService.fetchUserCalorieGoal(loggedInUser?.email);

      if (CalorieGoal != null && CalorieGoal is double) {
        // Check if userrWeight is not null and is of type double

        setState(() {
          userCalorieGoal = CalorieGoal ?? 0.0;
        });
        print('User CalorieGoal: $userCalorieGoal');
        return userCalorieGoal;
      } else {
        print('User CalorieGoal not available or invalid.');
      }


  }

  fetchUserWeight(String? email) async {
    // ...

      dynamic userrWeight = await FirebaseService.fetchUserData(loggedInUser?.email);
      if (userrWeight != null && userrWeight is double) {
        // Check if userrWeight is not null and is of type double

        setState(() {
          userWeight = userrWeight;
        });

        print('Userr weight: $userWeight');
        return userWeight;
      } else {
        print('User weight not available or invalid.');
      }


  }



  void initPlatformState() {
    if (loggedInUser != null) {
      Pedometer.stepCountStream.listen(onStepCount).onError(onStepCountError);
      Pedometer.pedestrianStatusStream.listen(onPedestrianStatusChanged).onError(onPedestrianStatusError);
    } else {
      // Handle the case where loggedInUser is null
    }
  }



  void onStepCount(StepCount event) {
    setState(() {
      steps = event.steps;
      distance = steps * 0.762; // Assuming average step length is 0.762 meters
      calories = calculateCaloriesBurnt();

      if (loggedInUser != null) {

        storeUserData();
        fetchDataAndPrint(loggedInUser!.email, DateTime.now().toString());
      }
    });
  }


  void onPedestrianStatusChanged(PedestrianStatus event) {
    print(event);
    setState(() {
      status = event.status;
    });
  }


  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      steps = 0;
      distance = 0.0;
      calories = 0.0;
    });
  }
  void onPedestrianStatusError(error) {
    print('onPedestrianStatusError: $error');
    setState(() {
      status = 'Pedestrian Status not available';
    });
    print(status);
  }


  double calculateCaloriesBurnt() {
    // Replace this with your actual formula to calculate calories
    // You can use the user's weight, steps, and other factors in your formula
    if (userWeight != null) {
      double calories = steps * 0.035 * userWeight;
      print(calories);
      return calories;
    } else {
      // Handle the case where userWeight is null
      return 0.0;
    }
  }


  void storeUserData() {
    String formatString = 'dd-MM-yyyy';
    if (loggedInUser != null) {

      String? userId = loggedInUser!.email; // Assuming you have a unique user ID for the logged-in user
      double updatedCalories = calculateCaloriesBurnt(); // Calculate updated calories (you can use your calculation function)
      double updatedDistance = distance; // Calculate updated distance if needed

      // Get the current date as a timestamp
      Timestamp now = Timestamp.now();
      String currentDate = DateFormat(formatString).format(DateTime.now());

      // Reference to the 'UserData' collection for the specific user
      CollectionReference userDataRef = FirebaseFirestore.instance.collection('UserData');

      // Reference to the 'DailySteps' subcollection under the user's document
      // Since the subcollection name is based on the date, use the specific date for the subcollection name
      String formattedDate = currentDate; // You can replace this with the actual formatted date
      CollectionReference dailyStepsRef = userDataRef.doc(userId).collection('DailySteps').doc(formattedDate).collection('Activity');

      // Create a new document in the 'Steps' subcollection with the current timestamp as the document ID
      dailyStepsRef.doc(now.toDate().toString()).set({
        'Steps': steps,
        'Calories': updatedCalories,
        'Distance': updatedDistance,
        'timestamp': now,
      });

      // Update the user's main data in the 'UserData' collection (you can add other fields as needed)
      userDataRef.doc(userId).update({
        'Steps': steps,
        'Calories': updatedCalories,
        'Distance': updatedDistance,
        'Last Update': now,
      });
    }
  }


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
        distance = totalDistance;
        calories = totalCalories;
      });

      print('Total Steps: $totalSteps, Total Distance: $totalDistance, Total Calories: $totalCalories');
    } catch (e) {
      // Handle any errors that occur during the data fetch
      print('Error fetching activity data: $e');
    }
  }


  int myIndex = 0;
  String step = 'N/A';
  late Stream<StepCount> stepCountStream;


   // Update this value with your actual goal

  // ... Your existing code ...
  IconData currentIcon = Icons.directions_walk;

  void changeIcon() {
    setState(() {
      if (currentIcon == Icons.directions_walk) {
        currentIcon = Icons.run_circle;
      } else {
        currentIcon = Icons.directions_walk;
      }
    });
  }
  void showNotificationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Goal Achieved'),
          content: Text('Congratulations! You have reached your calorie goal.'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }


  double calculateCaloriesPercentage() {

    double percentage = ((calculateCaloriesBurnt() / 1000) / userCalorieGoal).clamp(0.0, 1.0);

    return percentage;
  }

  Widget buildCaloriesContainer() {
    if (userCalorieGoal == null) {
      // Handle the case where userCalorieGoal is null (e.g., show a loading indicator)
      return CircularProgressIndicator();
    } else {
      // Rest of the code to build the calories container



    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Color.fromRGBO(0, 0, 0, 0.85),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.no_food_rounded, color: Colors.orange),
                SizedBox(width: 10),
                Text(
                  "Calories",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Row(
                children: [
                  SizedBox(width: 10),
                  Text(
                    '${(calculateCaloriesBurnt()/1000).toStringAsFixed(2)} kcl',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                      fontFamily: 'Montserrat',
                      color: Colors.orange,
                    ),
                  ),

                  Spacer(),
                  Container(
                    width: 60,
                    height: 60,
                    child: Stack(
                      children: [
                        Center(
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: CircularProgressIndicator(

                              value: calculateCaloriesPercentage(),
                              strokeWidth: 6,
                              backgroundColor: Colors.grey[600],
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            '${(calculateCaloriesPercentage() * 100).toInt()}%',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );}
  }


  @override
  Widget build(BuildContext context) {
    String userEmail = loggedInUser?.email ?? 'N/A';

    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('Home', style: GoogleFonts.montserrat(fontWeight: FontWeight.bold)),
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              // Handle menu button pressed
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.notifications_outlined),
              onPressed: () {
                // Handle search button pressed
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 40),
                    child: Image.asset(
                      "Images/vealth-high-resolution-logo-color-on-transparent-background.png",
                      height: 60,
                      width: 140,
                    ),
                  ),
                ),

                SizedBox(height: 10),
                 Container(
                   child: Row(
                     children: [
                       GestureDetector(
                         child: Container(
                           child: Image.asset("Images/bitmoji2.png"),
                           width: 100,
                           height: 100,
                         ),
                         onTap: () {
                           Navigator.pushNamed(context, ProfilePage.id);
                         },
                       ),
                       SizedBox(width: 15),
                       Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Text(
                             "Hello",
                             style: TextStyle(
                               fontSize: 18,
                               color: Colors.grey[600],
                             ),
                           ),
                           StreamBuilder<DocumentSnapshot>(
                             stream: FirebaseFirestore.instance.collection('Users').doc(loggedInUser!.email).snapshots(),
                             builder: (context, snapshot) {
                               if (snapshot.connectionState == ConnectionState.waiting) {
                                 // If the data is still loading, you can display a loading indicator or return a placeholder widget.
                               }

                               if (snapshot.hasError) {
                                 // Handle any errors that occur while fetching the data.
                                 return Text('Error loading data');
                               }

                               final fullName = snapshot.data?.data() as Map<String, dynamic>;
                               if (fullName == null) {
                                 // If the data is null or empty, you can display a placeholder or handle the case accordingly.
                                 return Text('Full Name not available');
                               }

                               return Text(
                                 fullName['Name'] ?? 'Full Name not available',
                                 style: TextStyle(
                                   fontWeight: FontWeight.bold,
                                   fontSize: 18,
                                 ),
                               );
                             },
                           ),


                         ],
                       )
                     ],
                   ),
                 ),

                SizedBox(height: 30),
                buildCaloriesContainer(),
                SizedBox(height: 20),
                Container(
                    height: 110,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(0, 0, 0, 0.85),
                      borderRadius: BorderRadius.circular(20),

                    ),
                    child:
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.directions_walk,color: Colors.blue,),
                              SizedBox(width: 10),
                              Text('Steps',style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, fontFamily: 'Montserrat',color: Colors.white)),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(

                            children: [
                              SizedBox(width: 10,),
                              Text('$steps steps',style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22, fontFamily: 'Montserrat',color: Colors.blue)),
                              Spacer(),
                              Icon(
                                status == 'walking'
                                    ? Icons.run_circle
                                    : status == 'stopped'
                                    ? Icons.accessibility_new
                                    : Icons.error,
                                size: 30,
                                color: Colors.blue,
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                ),
                SizedBox(height: 20),
                Container(
                    height: 110,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(0, 0, 0, 0.85),
                      borderRadius: BorderRadius.circular(20),

                    ),
                    child:
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.speed,color: Colors.red,),
                              SizedBox(width: 10),
                              Text("Distance",style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, fontFamily: 'Montserrat',color: Colors.white)),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(

                            children: [
                              SizedBox(width: 10,),
                              Text('${distance.toStringAsFixed(2)} km',style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22, fontFamily: 'Montserrat',color: Colors.red)),
                            ],
                          ),
                        ],
                      ),
                    )
                ),
                SizedBox(height: 20),

              ],
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
      ),
    );
  }


}