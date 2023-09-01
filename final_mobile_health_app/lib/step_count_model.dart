import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static Future<double?> fetchUserData(String? userId) async {
    try {
      // Get the Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Reference to the document in the 'Users' collection for the specific user
      DocumentReference userRef = firestore.collection('Users').doc(userId);

      // Get the user document
      DocumentSnapshot doc = await userRef.get();

      if (doc.exists) {
        // 'doc.data()' contains the document data as a Map
        Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;

        // Access the 'weight' field
        dynamic weight = userData['Weight'];

        if (weight != null) {
          // Handle different data types of the 'weight' field
          if (weight is int) {
            return weight.toDouble();
          } else if (weight is double) {
            return weight;
          } else if (weight is String) {
            return double.tryParse(weight);
          }
        } else {
          // If the 'Weight' field is not available or is null
          print(
              'User weight not available in Firestore for the specified user.');
          return null;
        }

      } else {
        // If the user document does not exist in Firestore
        print('User document not found in Firestore.');
        return null;
      }
    } catch (e) {
      // Error handling
      print('Error getting user document: $e');
      return null;
    }
  }


  static Future<String?> fetchUserName(String? userId) async {
    try {
      // Get the Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Reference to the document in the 'Users' collection for the specific user
      DocumentReference userRef = firestore.collection('Users').doc(userId);

      // Get the user document
      DocumentSnapshot doc = await userRef.get();

      if (doc.exists) {
        // 'doc.data()' contains the document data as a Map
        Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;

        // Access the 'Calorie Goal' field
        dynamic name = userData['Name'];

        if (name != null) {
          // Handle different data types of the 'Calorie Goal' field
          return name;
        } else {
          // If the 'Calorie Goal' field is not available or is null
          print(
              'User Name not available in Firestore for the specified user.');
          return null;
        }
      } else {
        // If the user document does not exist in Firestore
        print('User Name not found in Firestore.');
        return null;
      }
    } catch (e) {
      // Error handling
      print('Error getting user document: $e');
      return null;
    }
  }



  static Future<double?> fetchUserCalorieGoal(String? userId) async {
    try {
      // Get the Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Reference to the document in the 'Users' collection for the specific user
      DocumentReference userRef = firestore.collection('Users').doc(userId);

      // Get the user document
      DocumentSnapshot doc = await userRef.get();

      if (doc.exists) {
        // 'doc.data()' contains the document data as a Map
        Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;

        // Access the 'Calorie Goal' field
        dynamic calorieGoal = userData['Calorie Goal'];

        if (calorieGoal != null) {
          // Handle different data types of the 'Calorie Goal' field
          if (calorieGoal is int) {
            return calorieGoal.toDouble();
          } else if (calorieGoal is double) {
            return calorieGoal;
          } else if (calorieGoal is String) {
            return double.tryParse(calorieGoal);
          }
        } else {
          // If the 'Calorie Goal' field is not available or is null
          print(
              'User Calorie Goal not available in Firestore for the specified user.');
          return null;
        }
      } else {
        // If the user document does not exist in Firestore
        print('User document not found in Firestore.');
        return null;
      }
    } catch (e) {
      // Error handling
      print('Error getting user document: $e');
      return null;
    }
  }
}


Future<Map<String, dynamic>> fetchDailyStepsData(String? userId, String formattedDate) async {
  try {
    // Reference to the 'Activity' subcollection for the specific user's date
    CollectionReference dailyStepsRef = FirebaseFirestore.instance
        .collection('UserData')
        .doc(userId)
        .collection('DailySteps')
        .doc(formattedDate) // Assuming formattedDate is the date in 'MM-dd-yyyy' format
        .collection('Activity'); // Access the 'Activity' subcollection

    // Query to get all documents in the 'Activity' subcollection
    QuerySnapshot activityQuerySnapshot = await dailyStepsRef.get();

    // Initialize a map to store all the activity data
    Map<String, dynamic> allActivityData = {};

    // Loop through all the documents and add their data to the map
    for (QueryDocumentSnapshot activityDocumentSnapshot in activityQuerySnapshot.docs) {
      // Extract the data fields from the document and explicitly cast to Map<String, dynamic>
      Map<String, dynamic> activityData = activityDocumentSnapshot.data() as Map<String, dynamic>;
      // Add the activity data to the map using the document ID as the key
      allActivityData[activityDocumentSnapshot.id] = activityData;
    }

    // Return the map containing all the activity data for the selected date
    return allActivityData;
  } catch (e) {
    // Handle any errors that might occur during the data fetch
    print('Error fetching dailySteps data: $e');
    return {};
  }
}


