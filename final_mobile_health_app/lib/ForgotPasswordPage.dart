import 'package:final_mobile_health_app/ResetPasswordPage.dart';
import 'package:flutter/material.dart';
import 'HomePage.dart';

class ForgotPasswordPage extends StatelessWidget {
  static String id = "ForgotPasswordPage";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 50),
                  child: Image.asset(
                    "Images/vealth-high-resolution-logo-color-on-transparent-background.png",
                    height: 100,
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
                      height: 300,
                      width: 300,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.all(35),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  "Forgot Password",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              TextField(
                                onChanged: (value) {},
                                decoration: InputDecoration(labelText: "Email"),
                              ),
                              SizedBox(height: 24),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, ResetPasswordPage.id);
                                  // Implement your forgot password logic here
                                  // Send a password reset email to the provided email address
                                  // Show a confirmation message to the user
                                  // Optionally, navigate back to the login page after successful reset
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                  MaterialStateProperty.all(Colors.black),
                                ),
                                child: Container(
                                  child: Text("Reset Password"),
                                ),
                              ),
                              SizedBox(height: 10), // Add some spacing below the button
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("Go Back to Login"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

