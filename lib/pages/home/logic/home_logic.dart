import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../model/home_certifi_model.dart';

class HomeLogic extends GetxController {
  late final ImagePicker _picker = ImagePicker();
  String imageFilePath = '';
  int imageState = 0;
  Color bgColor = Colors.blue;
  late Uint8List imageData;
  bool isShowColors = true;

  static const platform = MethodChannel('samples.flutter.dev/battery');
  static const platform1 = MethodChannel('plugin_apple');
  // RxInt counter = 0.obs;
  List listData = [
    {
      "title": '电子驾照',
      "width": 44,
      "height": 64,
      "describeText": '规格：44mm × 64mm',
    },
    {
      "title": '身份证',
      "width": 26,
      "height": 32,
      "describeText": '规格：26mm × 32mm',
    },
    {
      "title": '考公',
      "width": 25,
      "height": 35,
      "describeText": '规格：25mm × 35mm',
    },
    {
      "title": '考研',
      "width": 41,
      "height": 54,
      "describeText": '规格：41mm × 54mm',
    },
    {
      "title": '教师资格证',
      "width": 41,
      "height": 54,
      "describeText": '规格：41mm × 54mm',
    },
    {
      "title": '大学生图像信息采集',
      "width": 41,
      "height": 54,
      "describeText": '规格：41mm × 54mm',
    },
    {
      "title": '电子社保卡',
      "width": 30,
      "height": 37,
      "describeText": '规格：30mm × 37mm',
    },
    {
      "title": '标准一寸照',
      "width": 25,
      "height": 35,
      "describeText": '规格：25mm × 35mm',
    },
    {
      "title": '小一寸照',
      "width": 22,
      "height": 32,
      "describeText": '规格：22mm × 32mm',
    },
    {
      "title": '大一寸照',
      "width": 33,
      "height": 48,
      "describeText": '规格：33mm × 48mm',
    },
    {
      "title": '标准二寸照',
      "width": 35,
      "height": 49,
      "describeText": '规格：35mm × 49mm',
    },
    {
      "title": '小二寸照',
      "width": 35,
      "height": 45,
      "describeText": '规格：35mm × 45mm',
    },
    {
      "title": '大二寸照',
      "width": 35,
      "height": 53,
      "describeText": '规格：35mm × 53mm',
    },
    {
      "title": '三寸照',
      "width": 55,
      "height": 84,
      "describeText": '规格：55mm × 84mm',
    },
    {
      "title": '四寸照',
      "width": 76,
      "height": 102,
      "describeText": '规格：76mm × 102mm',
    },
    {
      "title": '五寸照',
      "width": 89,
      "height": 127,
      "describeText": '规格：89mm × 127mm',
    },
    {
      "title": '六寸照',
      "width": 102,
      "height": 152,
      "describeText": '规格：102mm × 152mm',
    },
  ];
  HomeCertifiModel? myCertifiModel;

  var selectIndex = 0;
  // 以下为周期函数
  @override
  void onInit() {
    debugPrint('onInit');
    super.onInit();
    myCertifiModel = HomeCertifiModel.fromJson(listData.first);
  }

  void changeShowColorS() {
    isShowColors = !isShowColors;
    update();
  }

  void changeColor(Color color) {
    bgColor = color;
    update();
  }

  ///选择照片
  void selectImageFromGallery() async {
    // 从图库选择图片
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // 使用选择的图片
      debugPrint('选择的图片路径：${image.path}');
      imageFilePath = image.path;
      imageState = 1;
      await doSaveImage();
      // _getBatteryLevel();
      // update([TBDefVal.kChatInputFile]);
    } else {
      imageState = 0;

      debugPrint('没有选择图片。');
    }
    update();
  }

  ///拍照
  void captureImageWithCamera() async {
    // 使用相机拍摄新照片
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      // 使用拍摄的照片
      debugPrint('拍摄的照片路径：${photo.path}');
      imageFilePath = photo.path;
      imageState = 1;
      // _getBatteryLevel();
      await doSaveImage();

      // update([TBDefVal.kChatInputFile]);
    } else {
      imageState = 0;

      debugPrint('没有拍摄照片。');
    }
    update();
  }

  /// 执行存储图片到本地相册
  Future<void> doSaveImage() async {
    PermissionStatus permissionStatus;

    /// android权限为Permission.storage对应iOS的Permission.photos
    if (Platform.isAndroid) {
      permissionStatus = await Permission.storage.request();
    } else {
      permissionStatus = await Permission.photos.request();
    }

    if (permissionStatus == PermissionStatus.granted) {
      debugPrint('可以保存');
      appleOne();
      // File imageFile = File(imageFilePath);
      // imageData = await imageFile.readAsBytes();
      // imageState = 2;
      // update();
    } else {
      // 处理权限被拒绝的情况
      //  TBLoadingUtils.failure(text: '权限被拒绝，请授予存储权限。');
      debugPrint('权限被拒绝，请授予存储权限。');
    }
  }

  /// 无权限弹窗

  Future<void> appleOne() async {
    try {
      final result = await platform1
          .invokeMethod('sendImageToNative', {'imagePath': imageFilePath});
      Map map = result as LinkedHashMap<Object?, Object?>;
      debugPrint("result: ${map["result"]}");
      if (Platform.isAndroid) {
        debugPrint("------------------------Platform.isAndroid");

        // For Android, decode Base64 string
        // if (map["imgData"] != null && (map["imgData"] as String).isNotEmpty) {
        //   imageData =
        //       Uint8List.fromList(base64.decode(map["imgData"] as String));
        // }
        List<int> imageList = map["imgData"];
        imageData = Uint8List.fromList(imageList);
      } else if (Platform.isIOS) {
        debugPrint("------------------------Platform.isIOS");
        if (map["imgData"] != null &&
            (map["imgData"] as Uint8List).isNotEmpty) {
          imageData = map["imgData"] as Uint8List;
        }
      }
      imageState = 2;
      update();
    } catch (e) {
      // Handle errors if any
      debugPrint("Error: $e");
    }
  }

  Future<void> appleTwo() async {
    final result = await platform1
        .invokeMethod('sendImageDataToNative', {'imagePath': imageFilePath});
    Map map = result as LinkedHashMap<Object?, Object?>;
    debugPrint("result: ${map["result"]}");
    debugPrint("code: ${map["code"]}");
  }

  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }
    debugPrint("map: $batteryLevel");
  }
}
