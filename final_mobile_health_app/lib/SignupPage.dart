import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_mobile_health_app/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'HomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'step_count_model.dart';
import 'package:intl/intl.dart';

class SignupPage extends StatefulWidget {
  static String id = "SignupPage";

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _auth = FirebaseAuth.instance;

  void _submitForm() async {
    if (email.isEmpty || !isValidEmail(email)) {
      _showErrorSnackBar('Please enter a valid email.');
    } else if (password.isEmpty || password.length < 6) {
      _showErrorSnackBar('Please enter a valid password (at least 6 characters).');
    } else {
      if (_formKey.currentState?.validate() == true) {
        setState(() {
          showSpinner = true;
        });
        try {
          UserCredential newUser = await _auth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
          if (newUser != null) {
            Navigator.pushNamed(context, HomePage.id);
          }

          FirebaseFirestore.instance.collection('Users').doc(newUser.user!.email).set({
            'Email': email,
            'Name': FullName,
            'Calorie Goal': goal,
            'Weight': weight,
          });

          String formatString = 'dd-MM-yyyy';
          String Today = DateFormat(formatString).format(DateTime.now());
          FirebaseFirestore.instance.collection('UserData').doc(newUser.user!.email).collection("DailySteps").doc(Today).collection("Activity").doc("B0KqWSWPMSUrLqFPUsFb").set({
            "Calories": 0,
            "Distance": 0,
            "Steps": 0,
            "Last Update": 0,
          });

          setState(() {
            showSpinner = false;
          });
        } catch (e) {
          print(e);
        }
      }
    }
  }

  bool isValidEmail(String email) {
    // Add your email validation logic here
    // For simplicity, we're just checking if the email contains '@'
    return email.contains('@');
  }

  void _showErrorSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 2),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  bool showSpinner = false;

  String email = "";

  String password = "";

  String FullName = "";

  String DOB = "";

  String height = "";

  String weight = "";

  String goal = "";

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 50),
                    child: Image.asset(
                      "Images/vealth-high-resolution-logo-color-on-transparent-background.png",
                      height: 60,
                      width: 120,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 3,
                          spreadRadius: 0.1,
                          color: Colors.black,
                        ),
                      ],
                    ),
                    child: Card(
                      child: Container(
                        height: 500,
                        width: 350,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.all(35),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Text(
                                      "SIGNUP",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Montserrat',
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  TextFormField(
                                    onChanged: (value) {
                                      // Save the value to the FullName variable
                                      FullName = value;
                                    },
                                    decoration: InputDecoration(labelText: "Full Name",labelStyle: TextStyle(fontFamily: 'Montserrat',)),
                                    keyboardType: TextInputType.name,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your Full Name';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 10),
                                  TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    onChanged: (value) {
                                      // Save the value to the email variable
                                      email = value;
                                    },
                                    decoration: InputDecoration(labelText: "Email",labelStyle: TextStyle(fontFamily: 'Montserrat',)),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your Email';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 10),
                                  TextFormField(
                                    onChanged: (value) {
                                      // Save the value to the password variable
                                      password = value;
                                    },
                                    decoration: InputDecoration(labelText: "Password",labelStyle: TextStyle(fontFamily: 'Montserrat',)),
                                    obscureText: true,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your Password';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 10),
                                  TextFormField(
                                    onChanged: (value) {
                                      goal = value;
                                    },
                                    decoration:
                                    InputDecoration(labelText: "Calorie Goal(kcl)",labelStyle: TextStyle(fontFamily: 'Montserrat',)),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your Calorie Goal';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 10),
                                  TextFormField(
                                    onChanged: (value) {
                                      // Save the value to the weight variable
                                      weight = value;
                                    },
                                    decoration: InputDecoration(labelText: "Weight (kg)",labelStyle: TextStyle(fontFamily: 'Montserrat',)),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your Weight';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 24),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: _submitForm,
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.black),
                                          ),
                                          child: Container(
                                            child: Text("Sign Up",style: TextStyle(fontFamily: 'Montserrat',),),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                      height:
                          10), // Add some spacing between the Card and the "Go Back" button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.black),
                    ),
                    child: Container(
                      child: Text("Go Back",style: TextStyle(fontFamily: 'Montserrat',),),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

