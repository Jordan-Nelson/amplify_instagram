import 'package:flutter/material.dart';

Color primaryColor = Colors.grey[900]!;

ThemeData getAppTheme() => ThemeData(
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: primaryColor,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: primaryColor),
        centerTitle: false,
        textTheme: TextTheme(
          headline6: TextStyle(
            color: primaryColor,
            fontSize: 20,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(primaryColor),
          side: MaterialStateProperty.all<BorderSide>(BorderSide(width: 1)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(primaryColor),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
        ),
      ),
    );
