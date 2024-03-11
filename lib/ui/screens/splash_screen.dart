import 'package:face_swap/res/app_colors.dart';
import 'package:face_swap/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    splashScreenTimer(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Neumorphic(
          style: const NeumorphicStyle(
              shape: NeumorphicShape.concave,
              boxShape: NeumorphicBoxShape.circle(),
              depth: 8,
              lightSource: LightSource.topLeft,
              color: AppColors.whiteColor),
          child: Container(
            color: AppColors.primaryColor.withOpacity(0.08),
            child: const Icon(Icons.face_outlined,
                size: 180.0, color: AppColors.primaryColor),
          ),
        ),
      ),
    );
  }
}
