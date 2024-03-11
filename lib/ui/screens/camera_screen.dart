// import 'dart:developer';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/services.dart';
// import 'package:permission_handler/permission_handler.dart';

// class CameraScreen extends StatefulWidget {
//   const CameraScreen({super.key});

//   @override
//   State<CameraScreen> createState() => _CameraScreenState();
// }

// class _CameraScreenState extends State<CameraScreen> {
//   MethodChannel cameraChannel = const MethodChannel("CameraController");

//   Future<void> startCamera() async {
//     var status = await Permission.camera.status;
//     if (status.isGranted) {
//       try {
//         bool success = await cameraChannel.invokeMethod("startSession");
//         if (success && mounted) {
//           setState(() {});
//         }
//       } catch (e) {
//         log(e.toString());
//       }
//     } else if (status.isDenied) {
//       var status = await Permission.camera.request();
//       if (status.isGranted) {
//         startCamera();
//       }
//     }
//   }

//   Future<void> stopCamera() async {
//     try {
//       bool success = await cameraChannel.invokeMethod("stopSession");
//       if (success && mounted) {
//         setState(() {});
//       }
//     } catch (e) {
//       log(e.toString());
//     }
//   }

//   @override
//   void initState() {
//     startCamera();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     stopCamera();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     const String viewType = '<camera_view>';
//     final Map<String, dynamic> creationParams = <String, dynamic>{};
//     return PlatformViewLink(
//         surfaceFactory: ((context, controller) => AndroidViewSurface(
//               controller: controller as AndroidViewController,
//               hitTestBehavior: PlatformViewHitTestBehavior.opaque,
//               gestureRecognizers: const <
//                   Factory<OneSequenceGestureRecognizer>>{},
//             )),
//         onCreatePlatformView: (params) {
//           return PlatformViewsService.initSurfaceAndroidView(
//             id: params.id,
//             viewType: viewType,
//             layoutDirection: TextDirection.ltr,
//             creationParams: creationParams,
//             creationParamsCodec: const StandardMessageCodec(),
//             onFocus: () {
//               params.onFocusChanged(true);
//             },
//           )
//             ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
//             ..create();
//         },
//         viewType: viewType);
//   }
// }

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:face_swap/res/app_colors.dart';
import 'package:face_swap/res/app_constants.dart';
import 'package:face_swap/ui/screens/media_upload_screen.dart';
import 'package:face_swap/ui/screens/preview_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;
import 'dart:math' as math;

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key, required this.cameras});
  final List<CameraDescription>? cameras;

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _cameraController;
  bool _isRearCameraSelected = false;
  XFile? fixedPicture;
  String? faceImagePath;
  final faceSwapChannel = const MethodChannel('FaceSwap');
  final options =
      FaceDetectorOptions(performanceMode: FaceDetectorMode.accurate);
  FaceDetector? faceDetector;
  //bool faceDetecting = false;
  // final options = FaceDetectorOptions(
  //   performanceMode: FaceDetectorMode.accurate,
  // );
  // late FaceDetector _faceDetector;
  List<Face> facesDetected = [];
  bool _instructionWindow = true;
  bool _takeComplete = false;
  //int? faces;

  // Future _processImage(CameraImage cameraImage) async {
  //   try {
  //     await detectFacesFromImage(cameraImage);
  //   } catch (ex, stack) {}
  // }

  // InputImageRotation rotationIntToImageRotation(int rotation) {
  //   switch (rotation) {
  //     case 90:
  //       return InputImageRotation.rotation90deg;
  //     case 180:
  //       return InputImageRotation.rotation180deg;
  //     case 270:
  //       return InputImageRotation.rotation270deg;
  //     default:
  //       return InputImageRotation.rotation0deg;
  //   }
  // }

  // Future<void> _predictFacesFromImage({required CameraImage image}) async {
  //   await detectFacesFromImage(image);
  //   if (mounted) setState(() {});
  //   //await takePicture();
  // }

  // Future<void> detectFacesFromImage(CameraImage image) async {
  //   InputImageData firebaseImageMetadata = InputImageData(
  //     imageRotation: rotationIntToImageRotation(
  //         _cameraController.description.sensorOrientation),
  //     inputImageFormat: InputImageFormat.bgra8888,
  //     size: Size(image.width.toDouble(), image.height.toDouble()),
  //     planeData: image.planes.map(
  //       (Plane plane) {
  //         return InputImagePlaneMetadata(
  //           bytesPerRow: plane.bytesPerRow,
  //           height: plane.height,
  //           width: plane.width,
  //         );
  //       },
  //     ).toList(),
  //   );

  //   InputImage firebaseVisionImage = InputImage.fromBytes(
  //     bytes: image.planes[0].bytes,
  //     inputImageData: firebaseImageMetadata,
  //   );
  //   // print(firebaseVisionImage.filePath.toString() + " image path");
  //   var result = await faceDetector.processImage(firebaseVisionImage);
  //   result;
  //   print(result.toString() + " face detector data");
  //   if (result.isNotEmpty) {
  //     facesDetected = result;
  //     print(facesDetected.length.toString() + " face detected");
  //   }
  // }

  Future initCamera(CameraDescription cameraDescription) async {
    _cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );
    try {
      await _cameraController!.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
        //_cameraController.startImageStream((CameraImage image) async {
        // await _predictFacesFromImage(image: image);
        // .then((value) {});
        //   return null;
        // });
      });
    } on CameraException catch (e) {
      debugPrint("camera error $e");
    }
  }

  List<Alignment> alignmentList = [
    Alignment.topLeft,
    Alignment.topRight,
    Alignment.bottomRight,
    Alignment.bottomLeft,
  ];
  int index = 0;
  late Alignment begin;
  late Alignment end;
  int animatorConst = 1;

  @override
  void initState() {
    super.initState();
    begin = Alignment.topRight;
    end = Alignment.bottomRight;
    // initCamera(widget.cameras![1]);
    // faceDetector = FaceDetector(
    //   options: options,
    // );
  }

  @override
  void dispose() {
    if (_cameraController != null && faceDetector != null) {
      _cameraController!.dispose();
      faceDetector!.close();
    }

    super.dispose();
  }

  Future processfaceImage(String faceImage) async {
    String res = await faceSwapChannel
        .invokeMethod('Face', <String, dynamic>{"faceImage": faceImage});
    setState(() {});
    return res;
  }

  Future takePicture() async {
    if (!_cameraController!.value.isInitialized) {
      return null;
    }
    if (_cameraController!.value.isTakingPicture) {
      return null;
    }
    try {
      await _cameraController!.setFlashMode(FlashMode.off);
      XFile picture = await _cameraController!.takePicture();

      fixedPicture = await fixImage(picture);

      facesDetected = await faceDetector!
          .processImage(InputImage.fromFilePath(fixedPicture!.path));

      print(facesDetected.length.toString() + "faces datected");

      await manageProcessImage();
      if (facesDetected.isEmpty) {
        await Future.delayed(const Duration(milliseconds: 1500), () async {});
        XFile picture = await _cameraController!.takePicture();
        fixedPicture = await fixImage(picture);
        facesDetected = await faceDetector!
            .processImage(InputImage.fromFilePath(fixedPicture!.path));

        print(facesDetected.length.toString() + "take two: faces datected");
        await manageProcessImage();
      }
      if (facesDetected.isEmpty) {
        await Future.delayed(const Duration(milliseconds: 1500), () async {});
        XFile picture = await _cameraController!.takePicture();
        fixedPicture = await fixImage(picture);
        facesDetected = await faceDetector!
            .processImage(InputImage.fromFilePath(fixedPicture!.path));

        print(facesDetected.length.toString() + "take three: faces datected");
        await manageProcessImage();
      }

      if (facesDetected.isEmpty) {
        setState(() {
          _takeComplete = true;
          animatorConst = 0;
        });
      }

      // setState(() {
      //   _isPreview = true;
      // });

      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => PreviewScreen(
      //               picture: fixedPicture,
      //             )));
    } on CameraException catch (e) {
      debugPrint('Error occured while taking picture: $e');
      return null;
    }
  }

  Future<XFile> fixImage(XFile picture) async {
    final img.Image capturedImage =
        img.decodeImage(await File(picture.path).readAsBytes())!;
    final img.Image orientedImage = img.bakeOrientation(capturedImage);
    File file =
        await File(picture.path).writeAsBytes(img.encodeJpg(orientedImage));
    //XFile
    return XFile(file.path);
  }

  Future manageProcessImage() async {
    if (facesDetected.isNotEmpty) {
      setState(() {
        _takeComplete = true;
        animatorConst = 0;
      });
      String result = await processfaceImage(fixedPicture!.path);
      if (result == "face image processed") {
        print("face image processed");
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => MediaUploadScreen()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          // systemOverlayStyle: const SystemUiOverlayStyle(
          //   statusBarColor: AppColors.whiteColor,
          // ),
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.whiteColor,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: _instructionWindow
                ? Container()
                : const Text(
                    "Creating Face Scan",
                    style: TextStyle(
                        color: AppColors.lighterBlackColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 19.5),
                  ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: InkWell(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16)),
                onTap: () {
                  Navigator.pop(context);
                },
                child: Neumorphic(
                  style: NeumorphicStyle(
                      shape: NeumorphicShape.concave,
                      boxShape: NeumorphicBoxShape.roundRect(
                          const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              bottomLeft: Radius.circular(16))),
                      depth: 6,
                      lightSource: LightSource.topLeft,
                      color: AppColors.whiteColor),
                  child: Container(
                    decoration: BoxDecoration(
                        color: AppColors.red.withOpacity(0.20),
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            bottomLeft: Radius.circular(16))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14.0),
                      child: Icon(
                        Icons.close,
                        size: 21,
                        color: AppColors.red,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        body: _instructionWindow
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Almost There",
                            style: TextStyle(
                                color: AppColors.lighterBlackColor,
                                fontSize: 28,
                                fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Be ready",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: AppColors.darkerGreyColor,
                                fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Neumorphic(
                        style: NeumorphicStyle(
                            shape: NeumorphicShape.concave,
                            boxShape: NeumorphicBoxShape.roundRect(
                                BorderRadius.circular(140)),
                            depth: 12,
                            lightSource: LightSource.topLeft,
                            color: AppColors.whiteColor),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(200),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(200),
                            child: Image.asset(
                              'assets/images/girl.png',
                              scale: 2.2,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 36,
                      ),
                      Text(
                        "Keep your face in the circle for \na couple of seconds",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppColors.darkerGreyColor,
                            fontSize: 16),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () async {
                        await initCamera(widget.cameras![1]);
                        faceDetector = FaceDetector(
                          options: options,
                        );
                        setState(() {
                          _instructionWindow = false;
                          //end = Alignment.bottomRight;
                        });
                        WidgetsBinding.instance
                            .addPostFrameCallback((timeStamp) {
                          setState(() {
                            end = Alignment.topLeft;
                            //  begin = Alignment.bottomRight;
                          });
                        });
                        await Future.delayed(
                            const Duration(milliseconds: 1500), () async {});
                        await takePicture();
                      },
                      child: Neumorphic(
                        style: NeumorphicStyle(
                            shape: NeumorphicShape.concave,
                            boxShape: NeumorphicBoxShape.roundRect(
                                BorderRadius.circular(16)),
                            depth: 8,
                            lightSource: LightSource.topLeft,
                            color: AppColors.whiteColor),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Container(
                            color: AppColors.primaryColor.withOpacity(0.16),
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: const Text(
                              "Ready",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primaryColor,
                                  fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    (_cameraController!.value.isInitialized)
                        ? Stack(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                    right: 64,
                                    left: 64,
                                    top: 24 + 5,
                                    bottom: 24),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(140)),
                                child: Neumorphic(
                                  style: NeumorphicStyle(
                                      shape: NeumorphicShape.concave,
                                      boxShape: NeumorphicBoxShape.roundRect(
                                          BorderRadius.circular(140)),
                                      depth: 12,
                                      lightSource: LightSource.topLeft,
                                      color: AppColors.whiteColor),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 400),
                                    onEnd: () {
                                      setState(() {
                                        index = index + animatorConst;
                                        // animate the color
                                        // bottomColor = colorList[index % colorList.length];
                                        // topColor = colorList[(index + 1) % colorList.length];

                                        // animate the alignment
                                        begin = alignmentList[
                                            index % alignmentList.length];
                                        end = alignmentList[
                                            (index + 2) % alignmentList.length];
                                      });
                                    },
                                    curve: Curves.fastOutSlowIn,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(140),
                                      // color: Colors.blue.withAlpha(100),
                                      gradient: LinearGradient(
                                        begin: begin, //Alignment.topLeft,
                                        end: end, //Alignment.topCenter,
                                        colors: const [
                                          AppColors.primaryColor,
                                          AppColors.whiteColor,
                                          AppColors.whiteColor,
                                          AppColors.whiteColor,
                                          AppColors.whiteColor,
                                          AppColors.whiteColor,
                                          //AppColors.whiteColor,
                                          // AppColors.whiteColor,
                                        ],
                                      ),
                                      // border:
                                      // ProgressBorder.all(
                                      //     color: Colors.white, progress: 0, width: 0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(3.5),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(140),
                                        child: CameraPreview(
                                          _cameraController!,
                                          child: _takeComplete
                                              ? Container(
                                                  color: AppColors.primaryColor
                                                      .withOpacity(0.6),
                                                  child: _takeComplete &&
                                                          facesDetected
                                                              .isNotEmpty
                                                      ? const Icon(
                                                          Icons.done,
                                                          color: AppColors
                                                              .whiteColor,
                                                          size: 46,
                                                        )
                                                      : IconButton(
                                                          onPressed: () async {
                                                            setState(() {
                                                              animatorConst = 1;
                                                              _takeComplete =
                                                                  false;
                                                            });
                                                            await takePicture();
                                                          },
                                                          icon: const Icon(
                                                            Icons.replay,
                                                            color: AppColors
                                                                .whiteColor,
                                                            size: 46,
                                                          )),
                                                )
                                              : Container(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                  margin: const EdgeInsets.only(
                                      right: 84 - 10,
                                      left: 84 - 10,
                                      top: 44 - 10,
                                      bottom: 44 - 10),
                                  child: Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: _takeComplete &&
                                                    facesDetected.isEmpty
                                                ? AppColors.whiteColor
                                                : AppColors.lighterGreyColor,
                                            width: 2),
                                        color: AppColors.whiteColor,
                                        borderRadius:
                                            BorderRadius.circular(200)),
                                    child: Neumorphic(
                                      style: NeumorphicStyle(
                                          shape: NeumorphicShape.concave,
                                          boxShape:
                                              NeumorphicBoxShape.roundRect(
                                                  BorderRadius.circular(200)),
                                          depth: 8,
                                          lightSource: LightSource.topLeft,
                                          color: _takeComplete &&
                                                  facesDetected.isEmpty
                                              ? AppColors.red
                                              : AppColors.whiteColor),
                                      child:
                                          _takeComplete && facesDetected.isEmpty
                                              ? Icon(
                                                  Icons.error,
                                                  size: 24,
                                                  color: AppColors.whiteColor,
                                                )
                                              : Image.asset(
                                                  'assets/images/face_scan.png',
                                                  color: AppColors.greyColor,
                                                  scale: 24),
                                    ),
                                  ) //Icon(Icons.document_scanner_outlined, )),
                                  )
                            ],
                          )
                        : Container(
                            height: 450,
                            alignment: Alignment.center,
                            child: const CircularProgressIndicator()),

                    Container(
                      alignment: Alignment.center,
                      child: Column(children: [
                        Text(
                          _takeComplete
                              ? _takeComplete && facesDetected.isNotEmpty
                                  ? "Face has been Scanned!"
                                  : "No face is detected"
                              : "Scanning your face",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 18.5, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                            _takeComplete
                                ? _takeComplete && facesDetected.isNotEmpty
                                    ? "Proceeding..."
                                    : "Face Scan has been failed. Please try again"
                                : "Keep your head and make sure your face\n fits into the circle",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16,
                                color: AppColors.darkerGreyColor)),
                      ]),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(200),
                        onTap: () {
                          setState(() =>
                              _isRearCameraSelected = !_isRearCameraSelected);
                          initCamera(
                              widget.cameras![_isRearCameraSelected ? 0 : 1]);
                        },
                        child: Neumorphic(
                          style: const NeumorphicStyle(
                              shape: NeumorphicShape.concave,
                              boxShape: NeumorphicBoxShape.circle(),
                              depth: 8,
                              lightSource: LightSource.topLeft,
                              color: AppColors.whiteColor),
                          child: Container(
                            color: AppColors.primaryColor.withOpacity(0.08),
                            child: const Padding(
                              padding: EdgeInsets.all(18.0),
                              child: Icon(
                                CupertinoIcons.switch_camera,
                                size: 28,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )

                    // Align(
                    //     alignment: Alignment.bottomCenter,
                    //     child: Container(
                    //       height: MediaQuery.of(context).size.height * 0.1,
                    //       decoration: const BoxDecoration(
                    //           borderRadius:
                    //               BorderRadius.vertical(top: Radius.circular(24)),
                    //           color: AppColors.blackColor),
                    //       child: Row(
                    //           crossAxisAlignment: CrossAxisAlignment.center,
                    //           children: [
                    //             Expanded(
                    //                 child: IconButton(
                    //               padding: EdgeInsets.zero,
                    //               iconSize: 30,
                    //               icon: Icon(
                    //                   _isRearCameraSelected
                    //                       ? CupertinoIcons.switch_camera
                    //                       : CupertinoIcons.switch_camera_solid,
                    //                   color: Colors.white),
                    //               onPressed: () {
                    //                 setState(() =>
                    //                     _isRearCameraSelected = !_isRearCameraSelected);
                    //                 initCamera(
                    //                     widget.cameras![_isRearCameraSelected ? 0 : 1]);
                    //               },
                    //             )),
                    //             Expanded(
                    //                 child:
                    //                     // _isPreview
                    //                     //     ? IconButton(
                    //                     //         onPressed: () async {
                    //                     //           faceImagePath =
                    //                     //               fixedPicture!.path.toString();
                    //                     //           String result = await processfaceImage(
                    //                     //               fixedPicture!.path);
                    //                     //           if (result == "face image processed") {
                    //                     //             print("face image processed");
                    //                     //             //
                    //                     //           }
                    //                     //         },
                    //                     //         iconSize: 60,
                    //                     //         padding: EdgeInsets.zero,
                    //                     //         constraints: const BoxConstraints(),
                    //                     //         icon: Container(
                    //                     //             height: 60,
                    //                     //             width: 60,
                    //                     //             decoration: const BoxDecoration(
                    //                     //               shape: BoxShape.circle,
                    //                     //               color: AppColors.whiteColor,
                    //                     //             ),
                    //                     //             child: const Icon(Icons.done,
                    //                     //                 size: 40, color: Colors.black)),
                    //                     //       )
                    //                     //     :
                    //                     IconButton(
                    //               onPressed: () {
                    //                 setState(() {
                    //                   end = Alignment.topCenter;
                    //                 });
                    //               }, //takePicture,
                    //               iconSize: 80,
                    //               padding: EdgeInsets.zero,
                    //               constraints: const BoxConstraints(),
                    //               icon: const Icon(Icons.circle, color: Colors.white),
                    //             )),
                    //             const Spacer(),

                    //             // faces != null
                    //             //     ? faces! > 0
                    //             //         ? Text(
                    //             //             "Face Detected",
                    //             //             style: TextStyle(
                    //             //                 fontSize: 24, color: AppColors.whiteColor),
                    //             //           )
                    //             //         : Text("No Face",
                    //             //             style: TextStyle(
                    //             //                 fontSize: 24, color: AppColors.whiteColor))
                    //             //     : Text("No Face",
                    //             //         style: TextStyle(
                    //             //             fontSize: 24, color: AppColors.whiteColor)),
                    //           ]),
                    //     )),
                  ]));
  }
}
