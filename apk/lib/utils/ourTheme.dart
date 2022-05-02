import 'package:flutter/material.dart';

class OurTheme {
  Color _lightRed = Color(0xFF66BB6A);
  Color _lightGrey = Color(0xFFE8F5E9);
  Color _darkerGrey = Color.fromARGB(255, 119, 124, 135);

  ThemeData buildTheme() {
    return ThemeData(
        canvasColor: _lightGrey,
        primaryColor: _lightGrey,
        accentColor: _lightGrey,
        secondaryHeaderColor: _darkerGrey,
        hintColor: _darkerGrey,
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
    color: _lightGrey,
    ),
        ),
        ),
      buttonTheme: ButtonThemeData(
        buttonColor: _lightRed,
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        minWidth: 150,
        height: 40.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: _lightRed
      ),


    );
  }
}
