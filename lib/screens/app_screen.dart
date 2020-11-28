import 'package:age/age.dart';
import 'package:calc_age/provider/change_app_them.dart';
import 'package:calc_age/widgets/display_result.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppScreen extends StatefulWidget {
  @override
  _AppScreenState createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  DateTime _startdateTime = DateTime.now();
  DateTime _enddateTime = DateTime.now();
  AgeDuration age;
  final _dateOfBirthTextEditing = TextEditingController();
  final _currentDateTextEditing = TextEditingController();
  int years = 0;
  int months = 0;
  int days = 0;
  int nextYears = 0;
  int nextMonths = 0;
  int nextDays = 0;
  String initialDrobDownValue = 'Light Mode';
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  Future<void> config() {
    _firebaseMessaging.configure(onMessage: (message) async {
      print("onMessage : $message");
    }, onResume: (message) async {
      print("onResume : $message");
    }, onLaunch: (message) async {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AppScreen()),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    config();
  }

  @override
  Widget build(BuildContext context) {
    ChangeThemData changeThemData = Provider.of(context);
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.fromLTRB(15, 5, 15, 0),
            child: DropdownButton<String>(
              onChanged: (newValue) {
                setState(() {
                  initialDrobDownValue = newValue;
                });
              },
              items: <String>["Ligt Mode", "Dark Mode"]
                  .map<DropdownMenuItem<String>>(
                    (String value) => DropdownMenuItem<String>(
                      value: value,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (value == "Dark Mode") {
                              changeThemData.setthem(ThemeData.dark());
                              initialDrobDownValue = "Dark Mode";
                              Navigator.pop(context);
                            } else {
                              changeThemData.setthem(ThemeData.light());
                              initialDrobDownValue = "Light Mode";
                              Navigator.pop(context);
                            }
                          });
                        },
                        child: Text(value,
                            style: TextStyle(
                                color: initialDrobDownValue == "Dark Mode"
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20)),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
        title: Text(
          "Age Calculator",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(120, 20, 30, 0),
            child: Text(
              "Date Of Birth",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: initialDrobDownValue == "Dark Mode"
                      ? Colors.white
                      : Colors.black),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          TextField(
            controller: _dateOfBirthTextEditing,
            onTap: () async {
              DateTime date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1940),
                  lastDate: DateTime.now());
              setState(() {
                _startdateTime = date;
                _dateOfBirthTextEditing.text = date.toLocal().toString();
              });
              debugPrint("the selected end date is ${_startdateTime}");
            },
            readOnly: true,
            decoration: InputDecoration(
              hintText: " Select Your Birth Date ",
              suffixIcon: Icon(
                Icons.date_range,
              ),
              fillColor: Colors.white70,
              filled: true,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: Colors.blue),
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(120, 20, 30, 0),
            child: Text(
              "Today Date",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: initialDrobDownValue == "Dark Mode"
                      ? Colors.white
                      : Colors.black),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          TextField(
            controller: _currentDateTextEditing,
            onTap: () async {
              DateTime date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1940),
                  lastDate: DateTime.now());
              setState(() {
                _enddateTime = date;
                _currentDateTextEditing.text = date.toLocal().toString();
                debugPrint("the selected end date is ${_enddateTime}");
              });
            },
            readOnly: true,
            decoration: InputDecoration(
              hintText: "Select Current Date",
              suffixIcon: Icon(
                Icons.date_range,
              ),
              fillColor: Colors.white70,
              filled: true,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: Colors.blue),
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: 70,
                width: 120,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  color: Colors.blue,
                  onPressed: () {
                    setState(() {
                      age = Age.dateDifference(
                          fromDate: _startdateTime,
                          toDate: _enddateTime,
                          includeToDate: false);
                      print(age);
                      DateTime tempData = DateTime(_enddateTime.year,
                          _startdateTime.month, _startdateTime.day);
                      DateTime nextBirthDate = tempData.isBefore(_enddateTime)
                          ? Age.add(
                              date: tempData, duration: AgeDuration(years: 1))
                          : tempData;
                      AgeDuration nextBirthDay = Age.dateDifference(
                          fromDate: _enddateTime, toDate: nextBirthDate);
                      print(nextBirthDay);
                      years = age.years;
                      months = age.months;
                      days = age.days;
                      nextYears = nextBirthDay.years;
                      nextMonths = nextBirthDay.months;
                      nextDays = nextBirthDay.days;
                      if (_startdateTime.month == _enddateTime.month &&
                          _startdateTime.day == _enddateTime.day) {
                        AlertDialog alert = AlertDialog(
                          title: Text("Today Is Your Birth Day "),
                          content: Text("Happy Birth Day :) :) "),
                          backgroundColor: Colors.blue,
                          contentTextStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.white),
                          actions: [
                            FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "OK",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                          titleTextStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: Colors.black),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          contentPadding: EdgeInsets.fromLTRB(10, 30, 10, 0),
                        );
                        return showDialog(
                            context: context, builder: (context) => alert);
                      }
                    });
                  },
                  child: Text(
                    "Calculate",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                height: 70,
                width: 130,
                child: RaisedButton(
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  onPressed: () {
                    setState(() {
                      years = 0;
                      months = 0;
                      days = 0;
                      nextDays = 0;
                      nextYears = 0;
                      nextMonths = 0;
                    });
                  },
                  child: Text(
                    "Clear Data",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(120, 20, 30, 0),
            child: Text("Your Age is",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: initialDrobDownValue == "Dark Mode"
                      ? Colors.white
                      : Colors.black,
                )),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              ViewResult("Years", years.toString()),
              ViewResult("Months", months.toString()),
              ViewResult("Days", days.toString()),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(70, 20, 30, 0),
            child: Text(
              "Your Next Birth Date After",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: initialDrobDownValue == "Dark Mode"
                      ? Colors.white
                      : Colors.black),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              ViewResult("Years", nextYears.toString()),
              ViewResult("Months", nextMonths.toString()),
              ViewResult("Days", nextDays.toString()),
            ],
          ),
        ],
      ),
    );
  }
}
