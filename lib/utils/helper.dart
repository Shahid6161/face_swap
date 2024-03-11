import 'dart:async';

import 'package:face_swap/res/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void splashScreenTimer(BuildContext context) {
  Timer(const Duration(seconds: 3), () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? login = prefs.getBool(AppSharedPreferences.userLoggedIn);
    if (login == true) {
      Navigator.pushNamed(context, AppRoutes.home);
    } else {
      Navigator.pushNamed(context, AppRoutes.signin);
    }
  });
}
