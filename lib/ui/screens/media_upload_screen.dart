import 'dart:io';

import 'package:face_swap/res/app_colors.dart';
import 'package:face_swap/ui/screens/home_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class MediaUploadScreen extends StatefulWidget {
  const MediaUploadScreen({super.key});

  @override
  State<MediaUploadScreen> createState() => _MediaUploadScreenState();
}

class _MediaUploadScreenState extends State<MediaUploadScreen> {
  final faceSwapChannel = const MethodChannel('FaceSwap');
  XFile? targetImage;
  late Uint8List byteImage;
  late bool isUploaded;
  late bool response;
  late bool processed;
  late bool isSwapping;

  @override
  void initState() {
    response = false;
    processed = false;
    isUploaded = false;
    isSwapping = false;
    byteImage = Uint8List.fromList([0]);
    super.initState();
  }

  Future faceSwap(
      //String targetImage,
      // String faceImage,
      // Uint8List byteImage
      ) async {
    Uint8List bytes = await faceSwapChannel.invokeMethod(
      'Swap',
      //<String, dynamic>{
      //  "faceImage": faceImage, //.toString(),
      // "targetImage": targetImage, //.toString()
      // }
    );
    setState(() {
      // byteImage = bytes;
      isSwapping = false;
      response = true;
    });
    return bytes;
  }

  Future processTargetImage(String targetImage) async {
    String res = await faceSwapChannel //faceProcessChannel
        .invokeMethod('Target', <String, dynamic>{"targetImage": targetImage});
    setState(() {});
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,

        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.whiteColor,
        // title: Padding(
        //   padding: EdgeInsets.symmetric(horizontal: 20.0),
        //   child: _instructionWindow
        //       ? Container()
        //       : Text(
        //           "Creating Face Scan",
        //           style: TextStyle(
        //               color: AppColors.lighterBlackColor,
        //               fontWeight: FontWeight.w600,
        //               fontSize: 19.5),
        //         ),
        // ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: InkWell(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeScreen()));
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    response ? "Result" : "Upload Image",
                    style: const TextStyle(
                        color: AppColors.lighterBlackColor,
                        fontSize: 28,
                        fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    response
                        ? "Face Swapped Image"
                        : "Swap face in your uploaded image",
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Neumorphic(
                  style: NeumorphicStyle(
                      shape: NeumorphicShape.concave,
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(30)),
                      depth: -12,
                      lightSource: LightSource.topLeft,
                      color: AppColors.primaryColor.withOpacity(0.075)),
                  child: Container(
                    // height: 320,
                    // width: 320,
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.5,
                      maxWidth: MediaQuery.of(context).size.width,
                    ),

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: isSwapping
                        ? const Center(child: CircularProgressIndicator())
                        : isUploaded
                            ? processed
                                ? response
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(30),
                                        child: Image.memory(
                                          byteImage,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(30),
                                        child: Image.file(
                                          File(targetImage!.path),
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                : const Center(
                                    child: CircularProgressIndicator())
                            : InkWell(
                                borderRadius: BorderRadius.circular(30),
                                onTap: () async {
                                  final ImagePicker picker = ImagePicker();
                                  // Pick an image
                                  targetImage = await picker.pickImage(
                                      source: ImageSource.gallery);

                                  if (targetImage != null) {
                                    String targetImagePath =
                                        targetImage!.path.toString();

                                    setState(() {
                                      isUploaded = true;
                                    });

                                    String result = await processTargetImage(
                                        targetImagePath);

                                    if (result == "target image processed") {
                                      print("target image processed");

                                      setState(() {
                                        processed = true;
                                      });
                                    }
                                  }
                                },
                                child: Container(
                                  height: 320,
                                  width: 320,
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Select your Image here",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: AppColors.darkerGreyColor,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      Icon(
                                        Icons.upload_file_outlined,
                                        size: 60,
                                        color: AppColors.darkerGreyColor
                                            .withOpacity(0.85),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                  ),
                ),
              ),
              // const SizedBox(
              //   height: 36,
              // ),
              // Text(
              //   "Keep your face in the circle for \na couple of seconds",
              //   textAlign: TextAlign.center,
              //   style: TextStyle(
              //       fontWeight: FontWeight.w500,
              //       color: AppColors.darkerGreyColor,
              //       fontSize: 16),
              // ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () async {
                if (processed) {
                  if (!response) {
                    setState(() {
                      isSwapping = true;
                    });

                    byteImage = await faceSwap(
                        // byteImageFace,
                        // byteImageTarget,
                        // faceImagePath,
                        //targetImagePath,
                        //   faceImg.toString(),
                        //    targetImg.toString(),
                        //  byteImage
                        );
                  } else {
                    Uint8List imageInUnit8List =
                        byteImage; // store unit8List image here ;
                    final tempDir = await getTemporaryDirectory();
                    File file =
                        await File('${tempDir.path}/image.png').create();
                    file.writeAsBytesSync(imageInUnit8List);
                    print(file.path.toString() + " save file path");
                    await GallerySaver.saveImage(file.path);
                  }
                }
              },
              child: Neumorphic(
                style: NeumorphicStyle(
                    shape: NeumorphicShape.concave,
                    boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(16)),
                    depth: processed ? 8 : 0,
                    lightSource: LightSource.topLeft,
                    color: AppColors.whiteColor),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Container(
                    color: processed
                        ? AppColors.primaryColor.withOpacity(0.16)
                        : AppColors.whiteColor,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Text(
                      response ? "Save Image" : "Swap Faces",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: processed
                              ? AppColors.primaryColor
                              : AppColors.darkerGreyColor,
                          fontSize: 20),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
