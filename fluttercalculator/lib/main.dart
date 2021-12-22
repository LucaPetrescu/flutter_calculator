import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttercalculator/screens/home_screen.dart';
import 'package:fluttercalculator/screens/login_screen.dart';
import 'package:fluttercalculator/screens/registration_screen.dart';

/*void main() {
  runApp(const MyApp());
}*/

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
    apiKey: "AIzaSyBVNDUjzbDgZQIIT9hO1u9Cfs8n2uSAcLs ",
    appId: "1:718196670749:android:600ae5a9f44261f3efe1f4",
    messagingSenderId: "",
    projectId: "caloriecalculator-ecef5",
  ));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Email And Password Login',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
