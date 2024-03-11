import 'package:face_swap/res/app_constants.dart';
import 'package:face_swap/ui/screens/home_screen.dart';
import 'package:face_swap/ui/screens/signin_screen.dart';
import 'package:face_swap/ui/screens/splash_screen.dart';
import 'package:flutter/material.dart';

class AppRouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    //final args = settings.arguments;
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case AppRoutes.signin:
        return MaterialPageRoute(builder: (_) => const SignInScreen());
      default:
        return MaterialPageRoute(builder: (_) => const SignInScreen());
    }
  }
}
