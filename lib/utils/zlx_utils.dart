import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../main.dart';

/// 工具类

class ZLXUtils {
  ///获取当前context

  static getCurrentContext(
      {Function(BuildContext context)? completionHandler}) {
    Future.delayed(const Duration(seconds: 0), () async {
      BuildContext context = navigatorKey.currentState!.overlay!.context;
      completionHandler?.call(context);
    });
  }

  /*手机系统是否是中文*/
  static bool isChineseLan() {
    final deviceLocale = Get.deviceLocale;
    print(
        "-----------------deviceLocale = ${deviceLocale?.countryCode?.toLowerCase()}");
    final isChinese = deviceLocale?.languageCode?.toLowerCase() == 'zh' &&
        (deviceLocale?.countryCode == 'CN' ||
            deviceLocale?.countryCode == 'TW' ||
            deviceLocale?.countryCode == 'HK' ||
            deviceLocale?.countryCode == 'MO');

    return isChinese;
  }

  /*计算文字宽宽高*/
  static Size boundingTextSize(
      BuildContext context, String text, TextStyle style,
      {int maxLines = 2 ^ 31, double maxWidth = double.infinity}) {
    if (text == null || text.isEmpty) {
      return Size.zero;
    }
    final TextPainter textPainter = TextPainter(
        textDirection: TextDirection.ltr,
        locale: Localizations.localeOf(context),
        text: TextSpan(text: text, style: style),
        maxLines: maxLines)
      ..layout(maxWidth: maxWidth);
    return textPainter.size;
  }

  /*修改状态栏颜色*/
  changeStatusBarStyle({required SystemUiOverlayStyle style}) {
    SystemChrome.setSystemUIOverlayStyle(style);
  }

  /*获取屏幕宽度*/
  double getScreenWidth() {
    return MediaQueryData.fromView(window).size.width;
  }

  /*获取屏幕底部安全距离*/
  double getBottomSafeArea() {
    return MediaQueryData.fromView(window).padding.bottom;
  }

  /*获取性别num*/
  static int getGenderNumber({required String genderString}) {
    if (genderString == '男') {
      return 1;
    } else {
      return 0;
    }
  }

  /*获取性别string*/
  static String getGenderString({required int gender}) {
    if (gender == 1) {
      return '男';
    } else {
      return '女';
    }
  }

  /*flutter调用h5*/
  String flutterCallH5({required String h5Name, required var params}) {
    var jsonParams = jsonEncode(params);
    return "$h5Name('$jsonParams')";
  }

  /*本地图片转base64字符串*/
  Future<String> localImageToBase64(String path) async {
    ByteData bytes = await rootBundle.load(path);
    var buffer = bytes.buffer;
    String base64 = jsonEncode(Uint8List.view(buffer));
    return base64;
  }

  ///获取组件高度
  static double getHeightFromKey(GlobalKey key) {
    // 获取 key 关联的小部件位置信息
    RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
    // 返回小部件的 高度
    return renderBox.size.height;
  }

  ///获取组件距屏幕顶部距离

  static double getTopDistanceFromKey(GlobalKey key) {
    // 获取 key 关联的小部件位置信息
    RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
    Offset widgetPosition = renderBox.localToGlobal(Offset.zero);

    // 返回小部件的 top 距离屏幕顶部的距离
    return widgetPosition.dy;
  }

  ///获取组件距屏幕底部距离
  static double getBottomDistanceFromKey(GlobalKey key) {
    // 获取屏幕的高度
    double screenHeight = MediaQuery.of(key.currentContext!).size.height;

    // 获取 key 关联的小部件位置信息
    RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
    Offset widgetPosition = renderBox.localToGlobal(Offset.zero);

    // 返回小部件的 bottom 距离屏幕底部的距离
    return screenHeight - (widgetPosition.dy + renderBox.size.height);
  }

  ///获取数组中的随机四个元素
  List<T> getRandomFour<T>(List<T> list) {
    final random = Random();
    final List<T> result = [];

    // 随机生成四个不重复的索引
    final Set<int> randomIndexes = Set();
    while (randomIndexes.length < 4 && randomIndexes.length < list.length) {
      final index = random.nextInt(list.length);
      randomIndexes.add(index);
    }
    // 根据随机索引获取元素并添加到结果列表中
    randomIndexes.forEach((index) {
      result.add(list[index]);
    });
    return result;
  }

  ///获取数组中的随机n个元素
  List<T> getRandomItems<T>(List<T>? list, int count) {
    if (list == null) {
      return [];
    }
    final random = Random();
    list.shuffle(random);
    final itemCount = count <= list.length ? count : list.length;

    return list.take(itemCount).toList();
  }
}
