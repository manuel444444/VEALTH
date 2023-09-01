import 'package:final_mobile_health_app/ActivityPage.dart';
import 'package:final_mobile_health_app/ForgotPasswordPage.dart';
import 'package:final_mobile_health_app/InviteFriendPage.dart';
import 'package:final_mobile_health_app/ResetPasswordPage.dart';
import 'package:final_mobile_health_app/SignupPage.dart';
import 'package:final_mobile_health_app/WelcomePage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'LoginPage.dart';
import 'HomePage.dart';
import 'ProfilePage.dart';



  void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    runApp(HealthApp());

  }


class HealthApp extends StatefulWidget {

  @override
  State<HealthApp> createState() => _HealthAppState();
}

class _HealthAppState extends State<HealthApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,

      initialRoute: LoginPage.id,
          routes: {
            ActivityPage.id :(context) => ActivityPage() ,
            WelcomePage.id :(context)=>WelcomePage(),
            HomePage.id :(context)=>HomePage(),
            ProfilePage.id :(context)=>ProfilePage(),
            LoginPage.id :(context)=> LoginPage(),
            SignupPage.id :(context)=>SignupPage(),
            ForgotPasswordPage.id :(context)=>ForgotPasswordPage(),
            ResetPasswordPage.id :(context)=>ResetPasswordPage(),
            InviteFriendPage.id :(context)=>InviteFriendPage(),

          },

    );
  }
}
