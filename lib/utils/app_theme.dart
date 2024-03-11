import 'package:face_swap/res/app_colors.dart';
import 'package:face_swap/res/app_constants.dart';
import 'package:flutter/material.dart';

class AppTheme {
  ThemeData lightTheme() {
    return ThemeData(
        scaffoldBackgroundColor: AppColors.whiteColor,
        primaryColor: AppColors.primaryColor,
        brightness: Brightness.light,
        fontFamily: AppFonts.quickSand);
  }
}
