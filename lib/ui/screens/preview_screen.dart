import 'dart:convert';

import 'package:face_swap/res/app_colors.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:math' as math;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';

class PreviewScreen extends StatefulWidget {
  PreviewScreen({Key? key, required this.picture}) : super(key: key);

  final XFile picture;

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  final faceSwapChannel = const MethodChannel('FaceSwap');
  //final faceProcessChannel = const MethodChannel('FaceProcess');
  //final targetProcessChannel = const MethodChannel('TargetProcess');

  late String targetImagePath;
  late String faceImagePath;
  late Uint8List byteImage;
  late bool response;
  late bool processed;

  @override
  void initState() {
    response = false;
    processed = false;
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
      response = true;
    });
    return bytes;
  }

  Future processfaceImage(String faceImage) async {
    String res = await faceSwapChannel //faceProcessChannel
        .invokeMethod('Face', <String, dynamic>{"faceImage": faceImage});
    setState(() {});
    return res;
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
      body: SafeArea(
        child: Stack(children: [
          processed == true
              ? response == true
                  ? Container(
                      alignment: Alignment.center,
                      child: Image.memory(
                        byteImage,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    )
              : Transform(
                  transform: Matrix4.rotationY(math.pi),
                  alignment: Alignment.center,
                  child: Image.file(
                    File(widget.picture.path),
                    fit: BoxFit.cover,
                  ),
                ),
          // ? Transform(
          //     alignment: Alignment.center,
          //     transform: Matrix4.rotationY(math.pi),
          //     child: Image.file(
          //       File(widget.picture.path),
          //       fit: BoxFit.cover,
          //     ))
          // : Image.memory(
          //     byteImage,
          //     fit: BoxFit.cover,
          //   ),
          processed == true
              ? Container()
              : Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      iconSize: 38,
                      padding: const EdgeInsets.all(20),
                      constraints: const BoxConstraints(),
                      icon: Icon(Icons.cancel,
                          color: Colors.white.withOpacity(0.65))),
                ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.18,
                decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(24)),
                    color: AppColors.blackColor),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: IconButton(
                          onPressed: () async {
                            // byteImage = await faceSwap(
                            //                     // byteImageFace,
                            //                     // byteImageTarget,
                            //                     faceImagePath,
                            //                     //targetImagePath,
                            //                     //   faceImg.toString(),
                            //                     //    targetImg.toString(),
                            //                     byteImage);

                            faceImagePath = widget.picture.path.toString();

                            String result =
                                await processfaceImage(faceImagePath);

                            if (result == "face image processed") {
                              print("face image processed");

                              showModalBottomSheet<void>(
                                elevation: 0,
                                isScrollControlled: true,
                                backgroundColor: AppColors.whiteColor,
                                barrierColor: Colors.transparent,
                                context: context,
                                constraints:
                                    const BoxConstraints.tightForFinite(),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20.0),
                                  ),
                                ),
                                builder: (BuildContext context) {
                                  return Container(
                                    height: 180,
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20.0),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        const Text(
                                          "Select Target Image",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        IconButton(
                                            onPressed: () async {
                                              final ImagePicker picker =
                                                  ImagePicker();
                                              // Pick an image
                                              final XFile? targetImage =
                                                  await picker.pickImage(
                                                      source:
                                                          ImageSource.gallery);

                                              if (targetImage != null) {
                                                targetImagePath =
                                                    targetImage.path.toString();

                                                String result =
                                                    await processTargetImage(
                                                        targetImagePath);

                                                if (result ==
                                                    "target image processed") {
                                                  print(
                                                      "target image processed");

                                                  setState(() {
                                                    processed = true;
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
                                                  Navigator.pop(context);
                                                }
                                              }

                                              // if (targetImage != null) {
                                              //   faceImagePath =
                                              //       widget.picture.path.toString();
                                              //   targetImagePath =
                                              //       targetImage.path.toString();

                                              // Uint8List byteImageFace =
                                              //     Uint8List.fromList(
                                              //         File(faceImagePath)
                                              //             .readAsBytesSync());

                                              //               Uint8List byteImageTarget =
                                              //     Uint8List.fromList(
                                              //         File(targetImagePath)
                                              //             .readAsBytesSync());

                                              // String byteImageFace = base64Encode(
                                              //     File(faceImagePath)
                                              //         .readAsBytesSync());

                                              // String byteImageTarget =
                                              //     base64Encode(
                                              //         File(targetImagePath)
                                              //             .readAsBytesSync());
                                              // final Uri faceImg =
                                              //     Uri.file(faceImagePath);

                                              // final Uri targetImg =
                                              //     Uri.file(targetImagePath);

                                              // byteImage = await faceSwap(
                                              //     // byteImageFace,
                                              //     // byteImageTarget,
                                              //     // faceImagePath,
                                              //     //targetImagePath,
                                              //     //   faceImg.toString(),
                                              //     //    targetImg.toString(),
                                              //     //  byteImage
                                              //     );

                                              // print(" array image1 " +
                                              //     byteImageFace.toString());
                                              // print(" array image2 " +
                                              //     byteImageTarget.toString());

                                              //   print(faceImg.toString() +
                                              //       " path of face");
                                              //   }
                                            },
                                            iconSize: 40,
                                            icon: const Icon(
                                              Icons.file_upload_outlined,
                                              color: AppColors.blackColor,
                                            ))
                                      ],
                                    ),
                                  );
                                },
                              );
                            }
                          },
                          iconSize: 60,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: Container(
                              height: 60,
                              width: 60,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.whiteColor,
                              ),
                              child: const Icon(Icons.done,
                                  size: 40, color: Colors.black)),
                        ),
                      ),
                    ]),
              )),
        ]),
      ),
    );
  }
}
