import 'package:face_swap/res/app_constants.dart';
import 'package:face_swap/utils/app_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  bool? _isSigningIn;

  GoogleSignInProvider() {
    _isSigningIn = false;
  }

  bool? get isSigningIn => _isSigningIn;

  set isSigningIn(bool? isSigningIn) {
    _isSigningIn = isSigningIn;
    notifyListeners();
  }
  Future login(BuildContext context) async {
    isSigningIn = true;
    final user = await googleSignIn.signIn();
    if (user == null) {
      isSigningIn = false;
      return;
    } else {
      final googleAuth = await user.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
     UserCredential result = await FirebaseAuth.instance.signInWithCredential(credential);
       if (result.user != null) {
        AppPreferences.userLoggedIn();
        Navigator.pushNamed(context, AppRoutes.home);
      }
      isSigningIn = false;
    }
  }

  void logout() async {
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }
}
