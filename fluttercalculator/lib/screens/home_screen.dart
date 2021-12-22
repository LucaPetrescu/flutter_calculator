import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttercalculator/model/user_model.dart';

import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  int currentIndex = 0;
  String result = "";
  late double height;
  late double weight;

  TextEditingController heightController = new TextEditingController();
  TextEditingController weightController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.blue,
            ),
            onPressed: () {
              logout(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${loggedInUser.firstName} ${loggedInUser.lastName}"),
                Row(
                  children: [
                    radioButton("Male", Colors.blue, 0),
                    radioButton("Female", Colors.pink, 1),
                  ],
                ),
                Padding(padding: EdgeInsets.all(12)),
                Text(
                  "Height:",
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                Padding(padding: EdgeInsets.all(6)),
                TextField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  controller: heightController,
                  decoration: InputDecoration(
                    hintText: "Ex: 175 cm",
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.all(6)),
                Text(
                  "Weight:",
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                Padding(padding: EdgeInsets.all(6)),
                TextField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  controller: weightController,
                  decoration: InputDecoration(
                    hintText: "Ex: 54 kg",
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(12),
                ),
                Container(
                  width: double.infinity,
                  height: 50.0,
                  child: Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.blueAccent,
                    child: MaterialButton(
                      minWidth: MediaQuery.of(context).size.width,
                      onPressed: () {
                        setState(() {
                          height = double.parse(heightController.value.text);
                          weight = double.parse(weightController.value.text);
                        });
                        calculateBmi(height, weight);
                      },
                      child: Text(
                        "Calculate",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(12),
                ),
                Container(
                  width: double.infinity,
                  child: Text(
                    "Your BMI is: ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(12),
                ),
                Container(
                  width: double.infinity,
                  child: Text(
                    "$result",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ActionChip(
                    label: Text("Logout"),
                    onPressed: () {
                      logout(context);
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  void calculateBmi(double height, double weight) {
    double finalresult = weight / (height * height / 10000);
    String bmi = finalresult.toStringAsFixed(2);
    setState(() {
      result = bmi;
    });
  }

  void changeIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  Widget radioButton(String value, Color color, int index) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12.0),
        height: 80.0,
        child: FlatButton(
          color: currentIndex == index ? color : Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          onPressed: () {
            changeIndex(index);
          },
          child: Text(
            value,
            style: TextStyle(
              color: currentIndex == index ? Colors.white : color,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
