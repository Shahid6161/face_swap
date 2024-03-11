import 'package:camera/camera.dart';
import 'package:face_swap/res/app_colors.dart';
import 'package:face_swap/res/app_constants.dart';
import 'package:face_swap/ui/screens/camera_screen.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  //final methodChannel = const MethodChannel('CAMERA');

  // void openCamera() async {
  //   await methodChannel.invokeMethod('openCamera');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        toolbarHeight: 80,
        // systemOverlayStyle: const SystemUiOverlayStyle(
        //   statusBarColor: AppColors.whiteColor,
        // ),
        elevation: 0,

        automaticallyImplyLeading: false,
        backgroundColor: AppColors.whiteColor,
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            AppConstants.appBarTitle,
            style: TextStyle(
                color: AppColors.lighterBlackColor,
                fontWeight: FontWeight.w600,
                fontSize: 21),
          ),
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: IconButton(
                onPressed: () {},
                iconSize: 32,
                splashRadius: 22,
                icon: Icon(
                  Icons.account_circle_outlined,
                  color: AppColors.darkerGreyColor.withOpacity(0.80),
                )),
          )
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Click here to scan\n your face",
              style: TextStyle(
                  color: AppColors.darkerGreyColor,
                  fontSize: 24,
                  height: 1.5,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 26,
            ),
            InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () async {
                  await availableCameras().then((value) => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => CameraScreen(
                                cameras: value,
                              ))));
                },
                child: Neumorphic(
                    style: NeumorphicStyle(
                        shape: NeumorphicShape.concave,
                        boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.circular(16)),
                        depth: 8,
                        lightSource: LightSource.topLeft,
                        color: AppColors.whiteColor),
                    child: Container(
                      padding: const EdgeInsets.all(24.0),
                      color: AppColors.primaryColor.withOpacity(0.075),
                      child: Image.asset(
                        'assets/images/face_scan.png',
                        color:
                            AppColors.primaryColor, //AppColors.darkerGreyColor,
                        scale: 10,
                      ),
                    )
                    // Icon(
                    //   Icons.face,
                    //   size: 58,
                    //   color: AppColors.darkerGreyColor.withOpacity(0.9),
                    // ),
                    )),
            Padding(padding: EdgeInsets.only(bottom: 40))
          ],
        ),
      ),
      // Container(
      //   padding: const EdgeInsets.symmetric(horizontal: 20),
      //   child: IconButton(
      //       onPressed: () {},
      //       iconSize: 30,
      //       splashRadius: 22,
      //       color: AppColors.primaryColor,
      //       icon: const Icon(Icons.add)),
      // ),

      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.all(16.0),
      //   child: SizedBox(
      //     height: 64.0,
      //     width: 64.0,
      //     child: FloatingActionButton(
      //       elevation: 8,
      //       backgroundColor: AppColors.primaryColor,
      //       onPressed: () async {
      //         await availableCameras().then((value) => Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //                 builder: (_) => CameraScreen(
      //                       cameras: value,
      //                     ))));
      //       },
      //       child: const Padding(
      //         padding: EdgeInsets.all(4.0),
      //         child: Icon(
      //           Icons.camera_enhance_rounded,
      //           size: 32,
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
