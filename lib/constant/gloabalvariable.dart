import 'package:flutter/material.dart';

class GlobalVariables {
  static final appBarColor = Colors.teal.shade400;
  static const backgroundColor = Color.fromARGB(255, 223, 246, 244);
  static const mainColor = Color.fromARGB(255, 224, 124, 52);
  static const secondaryColor = Color.fromARGB(255, 246, 215, 193);
  static const Color greyBackgroundCOlor = Color(0xffebecee);
  static const selectedNavBarColor = Color.fromARGB(255, 73, 125, 89);
  static const unselectedNavBarColor = Colors.black87;
  static const cardColor = Color.fromARGB(255, 247, 188, 149);
  static const grad = LinearGradient(
    colors: [
      Color.fromARGB(255, 238, 171, 64),
      Color.fromARGB(255, 239, 98, 63),
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
