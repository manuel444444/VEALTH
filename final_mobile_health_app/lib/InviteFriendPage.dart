import 'package:flutter/material.dart';

class InviteFriendPage extends StatelessWidget {

  static String id = "InviteFriendPage";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Invite Friends'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_add,
              size: 80,
              color: Colors.green,
            ),
            SizedBox(height: 20),
            Text(
              'Invite Friends',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Invite your friends to join you on this fitness journey.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Handle invite friends button pressed
              },
              child: Text('Invite Now'),
            ),
          ],
        ),
      ),
    );
  }
}