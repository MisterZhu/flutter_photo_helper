import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';

class HomeLogic extends GetxController {
  late final ImagePicker _picker = ImagePicker();
  String imageFilePath = '';
  static const platform = MethodChannel('samples.flutter.dev/battery');
  static const platform1 = MethodChannel('plugin_apple');
  // RxInt counter = 0.obs;
  List listData = [
    {
      "title": '结婚登记照',
      "describeText": '规格：49mm × 35mm',
    },
    {
      "title": '电子社保卡',
      "describeText": '规格：30mm × 37mm',
    },
    {
      "title": '电子驾照',
      "describeText": '规格：44mm × 64mm',
    },
    {
      "title": '身份证',
      "describeText": '规格：26mm × 32mm',
    },
    {
      "title": '大学生图像信息采集',
      "describeText": '规格：41mm × 54mm',
    },
    {
      "title": '考公',
      "describeText": '规格：25mm × 35mm',
    },
    {
      "title": '教师资格证',
      "describeText": '规格：41mm × 54mm',
    },
    {
      "title": '考研',
      "describeText": '规格：41mm × 54mm',
    },
    {
      "title": '标准一寸照',
      "describeText": '规格：25mm × 35mm',
    },
    {
      "title": '小一寸照',
      "describeText": '规格：22mm × 32mm',
    },
    {
      "title": '大一寸照',
      "describeText": '规格：33mm × 48mm',
    },
    {
      "title": '标准二寸照',
      "describeText": '规格：35mm × 49mm',
    },
    {
      "title": '小二寸照',
      "describeText": '规格：35mm × 45mm',
    },
    {
      "title": '大二寸照',
      "describeText": '规格：35mm × 53mm',
    },
    {
      "title": '三寸照',
      "describeText": '规格：55mm × 84mm',
    },
    {
      "title": '四寸照',
      "describeText": '规格：76mm × 102mm',
    },
    {
      "title": '五寸照',
      "describeText": '规格：89mm × 127mm',
    },
    {
      "title": '六寸照',
      "describeText": '规格：102mm × 152mm',
    },
  ];
  var selectIndex = 0;
  // 以下为周期函数
  @override
  void onInit() {
    debugPrint('onInit');
    super.onInit();
  }

  ///选择照片
  Future<void> selectImageFromGallery() async {
    // 从图库选择图片
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // 使用选择的图片
      debugPrint('选择的图片路径：${image.path}');
      imageFilePath = image.path;
      // update([TBDefVal.kChatInputFile]);
    } else {
      debugPrint('没有选择图片。');
    }
  }

  ///拍照
  Future<void> captureImageWithCamera() async {
    // 使用相机拍摄新照片
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      // 使用拍摄的照片
      debugPrint('拍摄的照片路径：${photo.path}');
      imageFilePath = photo.path;
      // update([TBDefVal.kChatInputFile]);
    } else {
      debugPrint('没有拍摄照片。');
    }
  }

  Future<void> appleOne() async {
    final result = await platform1
        .invokeMethod('sendImageToNative', {'imagePath': imageFilePath});
    Map map = result as LinkedHashMap<Object?, Object?>;
    debugPrint("result: ${map["result"]}");
    debugPrint("code: ${map["code"]}");
    debugPrint("map: $map");
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
  }
}
