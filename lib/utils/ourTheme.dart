import 'package:flutter/material.dart';

class OurTheme {
  Color _lightRed = Color.fromARGB(255, 213, 235, 220);
  Color _lightGrey = Color.fromARGB(255, 164, 164, 164);
  Color _darkerGrey = Color.fromARGB(255, 119, 124, 135);

  ThemeData buildTheme() {
    return ThemeData(
        canvasColor: _lightRed,
        primaryColor: _lightRed,
        accentColor: _lightGrey,
        secondaryHeaderColor: _darkerGrey,
        hintColor: _lightGrey,
        inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: BorderSide(
                  color: _lightGrey,
                ),
            ),
          focusedBorder:
            OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
    borderSide: BorderSide(
    color: _lightRed,
    ),
        ),
        ),
      buttonTheme: ButtonThemeData(
        buttonColor: _darkerGrey,
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        minWidth: 150,
        height: 40.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
    );
  }
}
