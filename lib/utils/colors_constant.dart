import 'package:flutter/material.dart';

class AppColors{

  static Color bgBlueColor = Colors.blue.shade900;
  static Color neonPinkColor = const Color.fromRGBO(253, 78, 245, 1);
  static Color neonBlueColor = const Color.fromRGBO(16, 202, 255, 1);
  static Color neonYellowColor = const Color.fromRGBO(255, 193, 71, 1);
  static Color neonAquaColor = const Color.fromRGBO(0, 255, 240, 1);
  static Color greenColor = Colors.green;
}

class AppGradients{
  static LinearGradient neonPinkBlueGradient({List<double>? stops}) => LinearGradient(
      stops: stops,
      colors: [
        AppColors.neonPinkColor,
        AppColors.neonBlueColor,
      ]);
}