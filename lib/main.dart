import 'package:calc_age/provider/change_app_them.dart';
import 'package:calc_age/screens/app_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ChangeThemData>(
      create: (context) => ChangeThemData(
        ThemeData.light(),
      ),
      child: MaterialThem(),
    );
  }
}

class MaterialThem extends StatefulWidget {
  @override
  _MaterialThemState createState() => _MaterialThemState();
}

class _MaterialThemState extends State<MaterialThem> {
  @override
  Widget build(BuildContext context) {
    ChangeThemData changeThemData = Provider.of(context);
    return MaterialApp(
      theme: changeThemData.getThem(),
      home: AppScreen(),
    );
  }
}
