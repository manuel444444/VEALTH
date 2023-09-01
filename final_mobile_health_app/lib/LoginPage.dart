import 'package:final_mobile_health_app/ForgotPasswordPage.dart';
import 'package:final_mobile_health_app/SignupPage.dart';
import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginPage extends StatefulWidget {
  static String id = "LoginPage";

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = FirebaseAuth.instance;

  bool showSpinner = false;

  String email="";

  String password="";

  int myIndex =0;


  void _submitForm() {
    if (email.isEmpty || !isValidEmail(email)) {
      _showErrorSnackBar('Please enter a valid email.');
    } else if (password.isEmpty || password.length < 6) {
      _showErrorSnackBar('Please enter a valid password (at least 6 characters).');
    } else {
      setState(() {
        showSpinner = true;
      });
      // Perform your login logic here
      _performLogin();
    }
  }

  String errorMessage = ""; // Add this variable to hold the error message

  void _performLogin() async {
    setState(() {
      showSpinner = true; // Show the loading spinner
    });

    try {
      final user = await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (user != null) {
        Navigator.pushNamed(context, HomePage.id);
      }
    } catch (e) {
      print(e);
      setState(() {
        errorMessage = e.toString(); // Convert the exception to a string for display
      });
      // Handle the error and display a relevant error message to the user
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(errorMessage),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
    } finally {
      setState(() {
        showSpinner = false; // Hide the loading spinner
      });
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(

      child: Scaffold(
        backgroundColor: Colors.white,
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Container(
                      margin: EdgeInsets.only(top: 100),
                      child:Image.asset("Images/vealth-high-resolution-logo-color-on-transparent-background.png",height: 100,width: 120) ,),
                  Container(
                    decoration: BoxDecoration(boxShadow: [BoxShadow(blurRadius: 3,spreadRadius: 0.1,color: Colors.black,),]),
                    child: Card(

                        child: Container(
                      height: 420,
                      width: 300,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.all(35),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Center(
                              child: Text("LOGIN",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,fontFamily: 'Montserrat',)),
                            ),
                            SizedBox(height: 10,),
                                //
                                TextField(
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (value) {
                                email = value;
                              },
                              decoration: InputDecoration(labelText: "Email",labelStyle: TextStyle(fontFamily: 'Montserrat',)),
                            ),

                                SizedBox(height: 10,),

                                TextField( onChanged: (value) {
                                  password = value;
                                },
                                  decoration: InputDecoration(labelText: "Password",labelStyle: TextStyle(fontFamily: 'Montserrat',)),
                                  obscureText: true,
                                ),
                                SizedBox(height: 50,),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(

                                        onPressed:
                                        _submitForm,

                                        style: ButtonStyle(backgroundColor:MaterialStatePropertyAll(Colors.black) ),
                                        child: Container(
                                        child: Text("Login",style: TextStyle(fontFamily: 'Montserrat',),)

                                      ),),
                                    ),
                                  ],
                                ),

                                  Row(
                                    children: [
                                      Text("Need an account?",style: TextStyle(fontFamily: 'Montserrat',),),
                                      TextButton(onPressed: () {
                                                Navigator.pushNamed(context, SignupPage.id);
                                      }, child: Text("SIGN UP",style: TextStyle(fontFamily: 'Montserrat',),),
                                      ),
                                    ],
                                  ),],),
                        ),
                      ),
                    )),
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
