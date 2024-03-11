import 'package:face_swap/res/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static userLoggedIn() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool(AppSharedPreferences.userLoggedIn, true);
  }

  static userLoggedOut() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool(AppSharedPreferences.userLoggedIn, false);
  }

  

  
}
