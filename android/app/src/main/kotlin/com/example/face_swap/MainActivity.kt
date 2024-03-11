package com.example.face_swap

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import androidx.annotation.NonNull
import com.google.mlkit.vision.common.InputImage
import com.google.mlkit.vision.face.Face
import io.flutter.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream
import java.io.File


class MainActivity: FlutterActivity() {


   // private val faceProcessCHANNEL = "FaceProcess"


   // private val targetProcessCHANNEL = "TargetProcess"


    private val faceSwapCHANNEL = "FaceSwap"

    private val tag = "MainActivity"
    private val face1Tab = 0
    private val face2Tab = 1
    private val pickImage = 100
//    private var selectedTab = 0

    private val desiredWidth = 800
    private val desiredHeight = 800

    private var imageUriFace1: Bitmap? = null
    private var imageUriFace2: Bitmap? = null

    private lateinit var bitmap1: Bitmap
    private lateinit var bitmap2: Bitmap
    private lateinit var bitmap1Swapped: Bitmap
    private lateinit var bitmap2Swapped: Bitmap

//    private lateinit var imageView: ImageView
//    private lateinit var button: FloatingActionButton

    private lateinit var faces1: List<Face>
    private lateinit var faces2: List<Face>
    private val faceDetectorEngine = FaceDetectorEngine()

    private var face1Done = false
    private var face2Done = false
    private var okToSwap = false
    private var hasSwapped = false

     override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)


//         MethodChannel(flutterEngine.dartExecutor.binaryMessenger,   faceProcessCHANNEL).setMethodCallHandler { call, result ->
//             if(call.method == "Face"){
//
//                 var imageStringFace1 : String ?= call.argument("faceImage")!!  // f
//                 var img1File :File  ?= File(imageStringFace1)
//                 var bitmap1 : Bitmap = BitmapFactory.decodeFile(img1File?.absolutePath)
//                 imageUriFace1 = bitmap1
//                 imageUriFace1?.let {  prepareImage(it, 0) }
//
//             }
//         }

//         switch (call.method) {
//             case "isLicensed":
//             result.success(MusicApi.checkLicense());
//             break;
//             case "getSongs":

//         MethodChannel(flutterEngine.dartExecutor.binaryMessenger,  targetProcessCHANNEL).setMethodCallHandler { call, result ->
//             if(call.method == "Target"){
//                 var  imageStringFace2 : String ?= call.argument("targetImage")!!
//                 var img2File : File  ?= File(imageStringFace2)
//                 var bitmap2 : Bitmap = BitmapFactory.decodeFile(img2File?.absolutePath)
//                 imageUriFace2 = bitmap2
//                 imageUriFace2?.let { prepareImage(it, 1) }
//             }
//         }





         MethodChannel(flutterEngine.dartExecutor.binaryMessenger,   faceSwapCHANNEL).setMethodCallHandler {
               call, result ->

                          if(call.method == "Face"){

                              var mes = "face image processed"
                 var imageStringFace1 : String ?= call.argument("faceImage")!!  // f
                 var img1File :File  ?= File(imageStringFace1)
                 var bitmap1 : Bitmap = BitmapFactory.decodeFile(img1File?.absolutePath)
                 imageUriFace1 = bitmap1
                 imageUriFace1?.let {  prepareImage(it, 0, result , mes) }

             }

                 else   if  (call.method == "Target"){
                     var mes = "target image processed"
                 var  imageStringFace2 : String ?= call.argument("targetImage")!!
                 var img2File : File  ?= File(imageStringFace2)
                 var bitmap2 : Bitmap = BitmapFactory.decodeFile(img2File?.absolutePath)
                 imageUriFace2 = bitmap2
                 imageUriFace2?.let { prepareImage(it, 1, result, mes) }
               //  result.success("target image processed")
             }

          else if(call.method == "Swap"){
         //  var imageStringFace1 : String ?= call.argument("faceImage")!! // file//
         // var  imageStringFace2 : String ?= call.argument("targetImage")!!

//         var img1File :File  ?= File(imageStringFace1)
//        var img2File : File  ?= File(imageStringFace2)

            //   var bitmap1 : Bitmap = BitmapFactory.decodeFile(img1File?.absolutePath)
            //   var bitmap2 : Bitmap = BitmapFactory.decodeFile(img2File?.absolutePath)


//               var bitmap1 : Bitmap = BitmapFactory.decodeByteArray(img1File.let { it } , 0 , img1File?.size.let { it } ?: 0 )
//               var bitmap2 : Bitmap = BitmapFactory.decodeByteArray(img2File.let { it } , 0 , img1File?.size.let { it } ?: 0 )




//               imageUriFace1 =        convertFileToContentURI(img1File)
//               imageUriFace2 =      convertFileToContentURI(img2File)
               //



//               MediaScannerConnection.scanFile(
//                   this, arrayOf<String>(img1File.getAbsolutePath()), null
//               ) { path, uri ->
//                   imageUriFace1 = uri
//               }
//
//               MediaScannerConnection.scanFile(
//                   this, arrayOf<String>(img2File.getAbsolutePath()), null
//               ) { path, uri ->
//                   imageUriFace2 = uri
//               }

//               imageUriFace1 = bitmap1
//               imageUriFace2 = bitmap2


//                     imageUriFace1 =      FileProvider.getUriForFile(context, "com.example.navigationdrawerfinal.fileprovider", File(imageStringFace1))//
//               imageUriFace2 =     FileProvider.getUriForFile(context, "image2", File(imageStringFace2))/// .toUri()!!

//              imageUriFace1?.let {  prepareImage(it, 0, result) }
//               imageUriFace2?.let { prepareImage(it, 1, result) }



//               val swappedImage: ByteArray = returnSwappedImageByteArray()
//               result.success(swappedImage)

//               val swappedImage: ByteArray = returnSwappedImageByteArray(imageUriFace1!!)
//               result.success(swappedImage)

            //   if (okToSwap) {
                   Log.d(tag, "Ready to swap!")

                   val landmarksForFaces1 = Landmarks.arrangeLandmarksForFaces(faces1)
                   val landmarksForFaces2 = Landmarks.arrangeLandmarksForFaces(faces2)

                        bitmap2Swapped =
                            Swap.faceSwapAll(
                                bitmap1,
                                bitmap2,
                                landmarksForFaces1,
                                landmarksForFaces2
                            )
//                   bitmap1Swapped =
//                       Swap.faceSwapAll(
//                           bitmap2,
//                           bitmap1,
//                           landmarksForFaces2,
//                           landmarksForFaces1
//                       )





                   hasSwapped = true

                   if (okToSwap) {
                       Log.d(tag, "Face Swapped!!")
                       val swappedImage: ByteArray = returnSwappedImageByteArray(bitmap2Swapped)
                       result.success(swappedImage)
                   }

                   //imageUriFace1?.let { it1 -> drawLandmarks(it1, landmarksForFaces1) }


          //     }
           }
       }

   }

//    private fun convertFileToContentURI(file: File):Uri {
//        var cr = context.contentResolver
//        var imgPath = file.absolutePath
//        var imgName = null
//        var imgDescription = null
//        var uriString = MediaStore.Images.Media.insertImage(cr , imgPath , imgName , imgDescription)
//        Log.d("CheckingVal" , uriString)
//        return Uri.parse(uriString)
//    }

    private fun returnSwappedImageByteArray(bitmap: Bitmap) : ByteArray {

        val stream = ByteArrayOutputStream()
      bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
        val byteArray: ByteArray = stream.toByteArray()
     bitmap.recycle();
        return byteArray;
    }


    // override fun onCreate(savedInstanceState: Bundle?) {
    //     super.onCreate(savedInstanceState)
    //     setContentView(R.layout.activity_main)

    //     val tabs = findViewById<TabLayout>(R.id.tabLayout)
    //     button = findViewById(R.id.fab)
    //     button.isEnabled = false
    //     imageView = findViewById(R.id.imageView)

        // Change tabs

        // tabs.addOnTabSelectedListener(object : TabLayout.OnTabSelectedListener {
        //     override fun onTabSelected(tab: TabLayout.Tab?) {

        //         if (tab != null) {
        //             Log.d(tag, "Tab ${tab.position} selected")

        //             selectedTab = tab.position

        //             if (hasSwapped) {
        //                 // Swapped, used swapped bitmaps instead of source.
        //                 if (tab.position == face1Tab) {
        //                     imageView.setImageBitmap(bitmap1Swapped)
        //                 }
        //                 if (tab.position == face2Tab) {
        //                     imageView.setImageBitmap(bitmap2Swapped)
        //                 }
        //             } else {
        //                 // Has not swapped, use sources.
        //                 if (tab.position == face1Tab) {
        //                     imageView.setImageURI(imageUriFace1)
        //                 }
        //                 if (tab.position == face2Tab) {
        //                     imageView.setImageURI(imageUriFace2)
        //                 }
        //             }
        //         }
        //     }

        //     override fun onTabReselected(tab: TabLayout.Tab?) {
        //         Log.d(tag, "onTabReselected not in use.")
        //     }

        //     override fun onTabUnselected(tab: TabLayout.Tab?) {
        //         Log.d(tag, "onTabUnselected not in use.")
        //     }
        // })

        // Open gallery for image selection

        // imageView.setOnClickListener {
        //     Log.d(tag, "Click on image view.")
        //     val gallery =
        //         Intent(Intent.ACTION_PICK, MediaStore.Images.Media.INTERNAL_CONTENT_URI)
        //     startActivityForResult(gallery, pickImage)
        // }

        // Click listener for action button, should result in face swap.

        // button.setOnClickListener {
        //     Log.d(tag, "Action button clicked.")

        //     if (okToSwap) {
        //         Log.d(tag, "Ready to swap!")

        //         val landmarksForFaces1 = Landmarks.arrangeLandmarksForFaces(faces1)
        //         val landmarksForFaces2 = Landmarks.arrangeLandmarksForFaces(faces2)

        //         bitmap2Swapped =
        //             Swap.faceSwapAll(bitmap1, bitmap2, landmarksForFaces1, landmarksForFaces2)
        //         bitmap1Swapped =
        //             Swap.faceSwapAll(bitmap2, bitmap1, landmarksForFaces2, landmarksForFaces1)


        //         if (selectedTab == face1Tab) {
        //             imageView.setImageBitmap(bitmap1Swapped)
        //         }

        //         if (selectedTab == face2Tab) {
        //             imageView.setImageBitmap(bitmap2Swapped)
        //         }

        //         hasSwapped = true

        //         // imageUriFace1?.let { it1 -> drawLandmarks(it1, landmarksForFaces1) }
        //     }
        // }
    //}

    // Gallery
    // override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
    //     super.onActivityResult(requestCode, resultCode, data)
    //     Log.d(tag, "onActivityResult: Image selected.")

    //     if (resultCode == RESULT_OK && requestCode == pickImage) {

    //         button.isEnabled = false

    //         if (selectedTab == face1Tab) {
    //             imageUriFace1 = data?.data
    //             imageView.setImageURI(imageUriFace1)
    //             imageUriFace1?.let { prepareImage(it, 0) }
    //         }
    //         if (selectedTab == face2Tab) {
    //             imageUriFace2 = data?.data
    //             imageView.setImageURI(imageUriFace2)
    //             imageUriFace2?.let { prepareImage(it, 1) }
    //         }
    //     }
    // }


     private fun prepareImage(bitmap: Bitmap, faceIndex: Int, result: io.flutter.plugin.common.MethodChannel.Result, message : String) {
        Log.d(tag, "prepareImage: Preparing image for face detection.")

    //    override fun onResourceReady(resource: Bitmap, transition: Transition<in Bitmap>?) {

            val inputImage = InputImage.fromBitmap(bitmap, 0)
            hasSwapped = false



            when (faceIndex) {
                0 -> bitmap1 = bitmap
                else -> bitmap2 = bitmap
            }

            faceDetectorEngine.detectInImage(inputImage)
                .addOnSuccessListener { faces ->
                    Log.d(tag, "faces detection.")
                    when (faceIndex) {
                        0 -> faces1 = faces
                        else -> faces2 = faces

                    }

                    val notEmpty = faces.isNotEmpty()
                    if (notEmpty && faceIndex == 0) {
                        face1Done = true
                    }
                    if (notEmpty && faceIndex == 1) {
                        face2Done = true
                    }

                    okToSwap = face1Done && face2Done
                    if (okToSwap == true) {
                        Log.d(tag, "okToSwap : true")

                                            }
                    result.success(message)



//                    if (okToSwap) {
//                        Log.d(tag, "Ready to swap!")
//
//                        val landmarksForFaces1 = Landmarks.arrangeLandmarksForFaces(faces1)
//                        val landmarksForFaces2 = Landmarks.arrangeLandmarksForFaces(faces2)
//
////                        bitmap2Swapped =
////                            Swap.faceSwapAll(
////                                bitmap1,
////                                bitmap2,
////                                landmarksForFaces1,
////                                landmarksForFaces2
////                            )
//                        bitmap1Swapped =
//                            Swap.faceSwapAll(
//                                bitmap2,
//                                bitmap1,
//                                landmarksForFaces2,
//                                landmarksForFaces1
//                            )
//
//
//
//
//
//                        hasSwapped = true
//
//                        if (okToSwap) {
//                            Log.d(tag, "Face Swapped!!")
//                            val swappedImage: ByteArray = returnSwappedImageByteArray(bitmap1Swapped)
//                            result.success(swappedImage)
//                        }
//
//                        //imageUriFace1?.let { it1 -> drawLandmarks(it1, landmarksForFaces1) }
//
//
//                    }
                    //button.isEnabled = okToSwap
                }
   //     }

//        override fun onLoadCleared(placeholder: Drawable?) {
//        }

//        Glide.with(this)
//            .asBitmap()
//            .load(file)
//            .into(object : CustomTarget<Bitmap>(desiredWidth, desiredHeight) {
//                override fun onResourceReady(resource: Bitmap, transition: Transition<in Bitmap>?) {
//
//                    val inputImage = InputImage.fromBitmap(resource, 0)
//                    hasSwapped = false
//
//                    when (faceIndex) {
//                        0 -> bitmap1 = resource
//                        else -> bitmap2 = resource
//                    }
//
//                    faceDetectorEngine.detectInImage(inputImage)
//                        .addOnSuccessListener { faces ->
//                            when (faceIndex) {
//                                0 -> faces1 = faces
//                                else -> faces2 = faces
//                            }
//
//                            val notEmpty = faces.isNotEmpty()
//                            if (notEmpty && faceIndex == 0) {
//                                face1Done = true
//                            }
//                            if (notEmpty && faceIndex == 1) {
//                                face2Done = true
//                            }
//
//                            okToSwap = face1Done && face2Done
//                            //button.isEnabled = okToSwap
//                        }
//                }
//
//                override fun onLoadCleared(placeholder: Drawable?) {
//                }
            }
   // )
    }


    // private fun drawLandmarks(uri: Uri, landmarksForFaces: ArrayList<ArrayList<PointF>>) {
    //     Log.v(tag, "Draw landmarks for faces.")

    //     Glide.with(this)
    //         .asBitmap()
    //         .load(uri)
    //         .into(object : CustomTarget<Bitmap>(desiredWidth, desiredHeight) {
    //             override fun onResourceReady(resource: Bitmap, transition: Transition<in Bitmap>?) {
    //                 val bitmapWithLandmarks =
    //                     ImageUtils.drawLandmarksOnBitmap(resource, landmarksForFaces)

    //                 imageView.setImageBitmap(bitmapWithLandmarks)
    //             }

    //             override fun onLoadCleared(placeholder: Drawable?) {
    //             }
    //         })
    // }




