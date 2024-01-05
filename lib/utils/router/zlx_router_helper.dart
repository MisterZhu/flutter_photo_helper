import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// 路由-工具管理
class ZLXRouterHelper {
  /*通过path跳转页面并关闭上一个页面*/
  static Future? pathOffPage(String path, dynamic params) {
    params ??= '';
    return Get.offAndToNamed(path, arguments: params);
  }

  /*通过path跳转页面
  * 默认页面跳转都需要做登录验证
  * 如果页面需要去掉登录验证，params需要传参removeLoginCheck=true
  */
  static Future? pathPage(String path, dynamic params) async {
    params ??= '';
    // List<String> noLoginPathList = [
    //   ZLXRouterPages.loginPath,
    // ];

    /// 是否去掉登录验证
    // if (params is Map) {
    //   var removeLoginCheck = params["removeLoginCheck"];
    //   if (removeLoginCheck == true) {
    //     noLoginPathList.add(path);
    //   }
    // }

    /// 是否需要登录，默认需要
    // bool isNeedLogin = true;
    // for (String subPath in noLoginPathList) {
    //   if (path == subPath) {
    //     isNeedLogin = false;
    //     break;
    //   }
    // }

    // if (isNeedLogin == true && SCScaffoldManager.instance.isLogin == false) {
    //   SCRouterHelper.pathOffAllPage(SCRouterPath.loginPath, null);
    //   return null;
    // }

    // /// webView
    // if (path == ZLXRouterPath.webViewPath) {
    //   if (Platform.isAndroid) {
    //     /// 调用Android WebView
    //     var channel = SCScaffoldManager.flutterToNative;
    //     var result = await channel.invokeMethod(
    //         SCScaffoldManager.android_webview, params);
    //
    //     /// todo 刷新控制台数据
    //     print("-------$result-------");
    //     return result;
    //   } else if (Platform.isIOS) {
    //     /// 调用iOS WebView
    //     return SCScaffoldManager.instance
    //         .flutterToNativeAction(SCFlutterKey.kIOSNativeWebView, params);
    //   }
    // }

    return Get.toNamed(path, arguments: params);
  }

  /*通过path跳转页面,关闭所有页面*/
  static Future? pathOffAllPage(String path, dynamic params) {
    params ??= '';
    return Get.offAllNamed(path, arguments: params);
  }

  /*返回上一页*/
  static void back(dynamic params) {
    params ??= '';
    Get.back(result: params);
  }

  /*跳转到下一个页面，下一个页面返回到指定页面*/
  static void offUntil(
      Widget page, String routeName, Map arguments, String backRouteName) {
    Get.offUntil(
        GetPageRoute(
            page: () => page,
            routeName: routeName,
            settings: RouteSettings(arguments: arguments)),
        (Route<dynamic> route) {
      GetPageRoute currentRoute = route as GetPageRoute;
      if (currentRoute.routeName == null) {
        RouteSettings settings = route.settings;
        if (settings.name == backRouteName) {
          return true;
        } else {
          return false;
        }
      } else {
        if (currentRoute.routeName == backRouteName) {
          return true;
        } else {
          return false;
        }
      }
    });
  }
}
