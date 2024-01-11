import 'dart:collection';
import 'dart:ui' as ui;
import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../utils/permission/tb_permission_manager.dart';
import '../model/home_certifi_model.dart';

class HomeLogic extends GetxController {
  late final ImagePicker _picker = ImagePicker();
  String imageFilePath = '';
  int imageState = 0;
  Color bgColor = Colors.blue;
  late Uint8List imageData;
  bool isShowColors = true;
  var repaintKey = GlobalKey();

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
      await appleOne();
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
      await appleOne();

      // update([TBDefVal.kChatInputFile]);
    } else {
      imageState = 0;

      debugPrint('没有拍摄照片。');
    }
    update();
  }

  /// 执行存储图片到本地相册
  Future<void> doSaveImage() async {
    // PermissionStatus permissionStatus;
    //
    // /// android权限为Permission.storage对应iOS的Permission.photos
    // if (Platform.isAndroid) {
    //   permissionStatus = await Permission.storage.request();
    // } else {
    //   permissionStatus = await Permission.photos.request();
    // }
    //
    // if (permissionStatus == PermissionStatus.granted) {
    //   debugPrint('可以保存');
    //   appleOne();
    //   // File imageFile = File(imageFilePath);
    //   // imageData = await imageFile.readAsBytes();
    //   // imageState = 2;
    //   // update();
    // } else {
    //   // 处理权限被拒绝的情况
    //   //  TBLoadingUtils.failure(text: '权限被拒绝，请授予存储权限。');
    //   debugPrint('权限被拒绝，请授予存储权限。');
    // }
    PermissionStatus permissionStatus;

    /// android权限为Permission.storage对应iOS的Permission.photos
    if (Platform.isAndroid) {
      permissionStatus = await Permission.storage.request();
    } else {
      permissionStatus = await Permission.photos.request();
    }

    if (permissionStatus == PermissionStatus.granted) {
      Uint8List data = await getImageData();
      String path = await saveImage(data);
      final result = await ImageGallerySaver.saveFile(path);
      Fluttertoast.showToast(msg: '保存成功！', gravity: ToastGravity.CENTER);
    } else {
      // 处理权限被拒绝的情况
      //  TBLoadingUtils.failure(text: '权限被拒绝，请授予存储权限。');
      showNoPermissionAlert();
    }
  }

  /// 无权限弹窗
  showNoPermissionAlert() {
    // 在需要的地方调用requestStoragePermission
    TBPermissionManager().requestStoragePermission().then((_) {
      // 申请权限请求成功后的操作
    }).catchError((error) {
      // wu权限的操作
    });
  }

  Future<void> appleOne() async {
    try {
      final result = await platform1
          .invokeMethod('sendImageToNative', {'imagePath': imageFilePath});
      Map map = result as LinkedHashMap<Object?, Object?>;
      debugPrint("result: ${map["result"]}");
      if (Platform.isAndroid) {
        debugPrint("------------------------Platform.isAndroid");
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

  /// 获取截取图片的数据
  Future<Uint8List> getImageData() async {
    BuildContext buildContext = repaintKey.currentContext!;
    //用于存储截取的图片数据
    var imageBytes;
    //通过 buildContext 获取到 RenderRepaintBoundary 对象，表示要截取的组件边界
    RenderRepaintBoundary boundary =
        buildContext.findRenderObject() as RenderRepaintBoundary;

    //这行代码获取设备的像素密度，用于设置截取图片的像素密度
    double dpr = 3.0;
    //将边界对象 boundary 转换为图像，使用指定的像素密度。
    ui.Image image = await boundary.toImage(pixelRatio: dpr);
    // image.width
    //将图像转换为ByteData数据，指定了数据格式为 PNG 格式。
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    //将ByteData数据转换为Uint8List 类型的图片数据。
    imageBytes = byteData!.buffer.asUint8List();
    return imageBytes;
  }

  Future<String> saveImage(Uint8List imageByte) async {
    //将回调拿到的Uint8List格式的图片转换为File格式
    //获取临时目录
    if (Platform.isIOS || Platform.isAndroid) {
      // 在移动平台或桌面平台上运行文件操作代码
      var tempDir = await getTemporaryDirectory();
      //生成file文件格式
      var file =
          await File('${tempDir.path}/image_${DateTime.now().millisecond}.png')
              .create();

      //转成file文件
      file.writeAsBytesSync(imageByte);
      print("${file.path}");
      String path = file.path;
      return path;
    } else {
      return '';
    }
  }

  void saveImageWith(Uint8List uint8List, String path) {
    // Resize the image to the desired size (295x413)
    img.Image? image = img.decodeImage(uint8List);
    img.Image resizedImage = img.copyResize(image!, width: 295, height: 413);
    // Save the resized image with the specified DPI
    File(path).writeAsBytesSync(img.encodePng(resizedImage));
  }

  Future<String> saveAndModifyImage(Uint8List imageByte) async {
    // 将Uint8List格式的图片转换为img.Image对象
    img.Image? originalImage = img.decodeImage(imageByte);

    // 在这里进行像素操作，例如调整图片大小
    int targetWidth = 295;
    int targetHeight = 413;
    img.Image resizedImage = img.copyResize(originalImage!,
        width: targetWidth, height: targetHeight);

    // 获取临时目录
    var tempDir = await getTemporaryDirectory();

    // 生成文件路径
    var filePath =
        '${tempDir.path}/modified_image_${DateTime.now().millisecond}.png';

    // 将修改后的图片保存到文件
    File outputFile = File(filePath);
    outputFile.writeAsBytesSync(img.encodePng(resizedImage));

    // 返回文件路径
    return filePath;
  }
}
