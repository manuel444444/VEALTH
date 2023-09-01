import 'package:final_mobile_health_app/LoginPage.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  static String id = "WelcomeScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('Images/lorin-both-vU5r_zo1vnY-unsplash.jpg'), // Replace with the correct path to your image file
            fit: BoxFit.cover, // Use BoxFit to determine how the image should be resized
          ),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent, // Top color (completely transparent)
              Colors.black.withOpacity(0.8), // Bottom color (darker with opacity)
            ],
          ),
        ),
        child: Container(
          margin: EdgeInsets.only(top: 400),
          child: Center(
            // Your app's content goes here
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                   Image.asset("Images/vealth-high-resolution-logo-color-on-transparent-background.png",width: 150,height: 50),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.only(left: 20,right: 20),
                  child: Text(
                    "Welcome to VEALTH – Your Personal Health Tracker!Track. Progress. Achieve. Get started on your health journey today!",
                    textAlign: TextAlign.center, // Center the text horizontally within the column
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ),
                SizedBox(height: 40,),
                Container(
                  width: 280, // Adjust the width as needed
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, LoginPage.id);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15), // Rounded edges
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0), // Adjust the padding as needed
                      child: Text(
                        "Get Started",
                        style: TextStyle(fontSize: 18, color: Colors.white),
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
