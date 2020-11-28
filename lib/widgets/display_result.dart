import 'package:flutter/material.dart';

class ViewResult extends StatelessWidget {
  String text;
  String value;

  ViewResult(this.text, this.value);

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(6),
          child: Container(
            color: Colors.white,
            height: h * .12,
            width: w * .3,
            child: Column(
              children: [
                Container(
                  height: h * .06,
                  width: w * .3,
                  color: Colors.blue,
                  child: Center(
                    child: Text(
                      text,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: h * .06,
                  width: w * .3,
                  color: Colors.white,
                  child: Center(
                    child: Text(
                      value,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
