import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChangeThemData extends ChangeNotifier {
  ThemeData _themeData;
  ChangeThemData(this._themeData);
  getThem() => _themeData;
  setthem(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }
}
