import 'dart:io';

import 'package:bruno/bruno.dart';
import 'package:permission_handler/permission_handler.dart';

import '../router/zlx_router_helper.dart';
import '../zlx_utils.dart';

class TBPermissionManager {
  static final TBPermissionManager _singleton = TBPermissionManager._internal();
  factory TBPermissionManager() => _singleton;

  TBPermissionManager._internal();
  bool _dialogShown = false;

  ///权限失败弹框
  void showPermissionDialog(String message) {
    ZLXUtils.getCurrentContext(completionHandler: (context) async {
      BrnDialogManager.showConfirmDialog(
        context,
        title: '温馨提示',
        cancel: '取消',
        confirm: '确定',
        message: message,
        onCancel: () {
          _dialogShown = false;
          ZLXRouterHelper.back(null);
        },
        onConfirm: () {
          _dialogShown = false;
          openAppSettings();
          ZLXRouterHelper.back(null);
        },
      );
      _dialogShown = true;
    });
  }

  ///相册权限
  Future<void> requestStoragePermission() async {
    PermissionStatus permissionStatus;

    // 检查权限和申请权限
    if (Platform.isAndroid) {
      permissionStatus = await Permission.storage.request();
    } else {
      permissionStatus = await Permission.photos.request();
    }
    if (permissionStatus == PermissionStatus.granted) {
      /* 外部调用
      .then((_) {
             //申请权限请求成功后的操作
        })
        **/
    } else if (!_dialogShown) {
      /*外部调用
      .catchError((error){
          // wu权限的操作
       })
      * */
      print('-----------------------------------弹出次数');
      showPermissionDialog("相机权限受限，请在设置中开启相机权限");
    }
  }

  ///麦克风权限
  Future<void> requestMicrophonePermission() async {
    PermissionStatus permissionStatus;

    // 检查权限和申请权限
    if (Platform.isAndroid) {
      permissionStatus = await Permission.storage.request();
    } else {
      permissionStatus = await Permission.photos.request();
    }
    if (permissionStatus == PermissionStatus.granted) {
      /* 外部调用
      .then((_) {
             //申请权限请求成功后的操作
        })
        **/
    } else if (!_dialogShown) {
      showPermissionDialog("麦克风权限受限，请在设置中开启麦克风权限");
    }
  }
}
