import 'package:face_swap/providers/google_sign_in.dart';
import 'package:face_swap/res/app_colors.dart';
import 'package:face_swap/res/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Card(
              elevation: 8,
              color: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Container(
                height: 320,
                width: 320,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Image.asset(
                    'assets/images/sign_in.png',
                  ),
                ),
              ),
            ),
            Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 8,
                    minimumSize: const Size(50, 64),
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    final provider = Provider.of<GoogleSignInProvider>(context,
                        listen: false);
                    provider.login(context);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 0, right: 14 // 6.0,
                                ),
                        child: CircleAvatar(
                            backgroundColor:
                                Colors.white, //Colors.orange.withOpacity(0.65),
                            radius: 20,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.asset(
                                'assets/images/google.png',
                                height: 38,
                                width: 38,
                              ),
                            )),
                      ),
                      const Text(
                        AppConstants.googleSignin,
                        style: TextStyle(
                            color: Colors.white, //Color(0xff4a4a4a),
                            fontWeight: FontWeight.w500,
                            fontSize: 17),
                      ),
                      SizedBox(
                        width: 2,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
