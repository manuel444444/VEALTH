import 'dart:ffi';
import 'package:final_mobile_health_app/LoginPage.dart';
import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ActivityPage.dart';

class ProfilePage extends StatefulWidget {
  static String id = "ProfilePage";

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  HomePageHelper homePageHelper = HomePageHelper();
  final _auth = FirebaseAuth.instance;
  User? loggedInUser;
  bool textFieldState = false;
  int myIndex = 0;
  double weight = 0.0;
  double calorieGoal = 0.0;
  String name ="";
  TextEditingController nameController = TextEditingController();
  TextEditingController calorieGoalController = TextEditingController();
  TextEditingController weightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    homePageHelper.getCurrentUser();
    initialize();
  }

  Future initialize() async {
    loggedInUser = await _auth.currentUser;
    name = await  homePageHelper.fetchUserName(loggedInUser!.email);
    weight = await homePageHelper.fetchUserWeight(loggedInUser!.email);
    calorieGoal = await homePageHelper.fetchUserCalorieGoal(loggedInUser!.email);

    // Set the fetched values in the text controllers
    nameController.text = name.toString() ?? '';
    calorieGoalController.text = calorieGoal.toString();
    weightController.text = weight.toString();

  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('Profile', style: TextStyle(fontFamily: 'Montserrat')),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                return HomePage();
              }));
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  saveUserDetails();
                });
              },
              child: Text(
                "Save",
                style: TextStyle(fontSize: 17, fontFamily: 'Montserrat'),
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                SizedBox(height: 40),
                Center(
                  child: Image.asset(
                    "Images/bitmoji2.png",
                    width: 98,
                    height: 98,
                  ),
                ),
                Center(
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Users')
                        .doc(_auth.currentUser!.email)
                        .snapshots(),
                    builder: (context, snapshot) {
                      final fullName =
                      snapshot.data!.data() as Map<String, dynamic>;
                      return Text(
                        fullName['Name'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          fontFamily: 'Montserrat',
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    children: [
                      Text(
                        "User Details",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      Spacer(),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            textFieldState = true;
                          });
                        },
                        child: Text("Edit", style: TextStyle(fontFamily: 'Montserrat')),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xffE3E3E3),
                  ),
                  height: 235,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Text(
                              "Full Name",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                            Spacer(),
                            Expanded(
                              child: TextField(
                                enabled: textFieldState,
                                textAlign: TextAlign.right,
                                maxLines: 1,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  // Remove the border/underline
                                ),
                                controller: nameController,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat',
                                ),

                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 1, color: Colors.white, thickness: 1),
                      Row(
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Text(
                                  "Weight",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          Expanded(
                            child: TextField(
                              controller: weightController,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat',
                              ),
                              keyboardType: TextInputType.number,
                              enabled: textFieldState,
                              textAlign: TextAlign.right,
                              maxLines: 1,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                // Remove the border/underline
                              ),
                            ),
                          ),
                        ],
                      ),
                      Divider(height: 1, color: Colors.white, thickness: 1),
                      Container(
                        child: Row(
                          children: [
                            Text(
                              "Calorie Goal",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                            Spacer(),
                            Expanded(
                              child: TextField(
                                keyboardType: TextInputType.number,
                                enabled: textFieldState,
                                textAlign: TextAlign.right,
                                maxLines: 1,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  // Remove the border/underline
                                ),
                                controller: calorieGoalController,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Spacer(),
                    Visibility(
                      visible: textFieldState,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            textFieldState = false;
                          });
                        },
                        child: Text(
                          "Done",
                          style: TextStyle(fontFamily: 'Montserrat'),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    _auth.signOut();
                    Navigator.pushNamed(context, LoginPage.id);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          15), // Rounded edges
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    // Adjust the padding as needed
                    child: Text(
                      "Log out",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),
                ),
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

  void saveUserDetails() {
    if (nameController.text.isEmpty || calorieGoalController.text.isEmpty || weightController.text.isEmpty) {
      // Show a dialog if any of the fields are empty
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text("Please fill in all the fields."),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        ),
      );
    } else {
      // Save the user details to Firebase
      FirebaseFirestore.instance
          .collection('Users')
          .doc(loggedInUser!.email)
          .update({
        'Name': nameController.text,
        'Weight': double.parse(weightController.text),
        'Calorie Goal': double.parse(calorieGoalController.text),
      }).then((_) {
        // Show a success dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Success"),
            content: Text("User details saved successfully."),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          ),
        );
      }).catchError((error) {
        // Show an error dialog if the update fails
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Error"),
            content: Text("Failed to save user details. Please try again."),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    calorieGoalController.dispose();
    weightController.dispose(); // Don't forget to dispose the controllers
    super.dispose();
  }
}
