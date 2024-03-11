import 'package:face_swap/providers/google_sign_in.dart';
import 'package:face_swap/res/app_constants.dart';
import 'package:face_swap/utils/app_route_generator.dart';
import 'package:face_swap/utils/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GoogleSignInProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppConstants.appName,
        theme: AppTheme().lightTheme(),
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRouteGenerator.generateRoute,
      ),
    );
  }
}
