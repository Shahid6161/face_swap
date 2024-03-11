abstract class AppConstants {
  static const String appName = "Face Swap";
    static const String appBarTitle = "FaceSwap";
  static const String googleSignin = "Sign in with Google";
  static const String signinScreenText1 = 'Welcome';
  static const String signinScreenText2 = 'to Face Swapping!';
}

abstract class AppFonts {
  static const String quickSand = "QuickSand";
  //static const String openSans = "OpenSans";
}

abstract class AppRoutes {
  static const String splash = '/';
  static const String signin = "/signin";
  static const String home = "/home";
  static const String personalinfo = "/personalinfo";
}

abstract class AppSharedPreferences {
  static const String userLoggedIn = "userLoggedIn";
}
