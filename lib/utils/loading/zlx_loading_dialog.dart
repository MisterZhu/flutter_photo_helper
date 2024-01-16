import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ZLXLoadingDialog {
  static show() {
    Get.dialog(
      Container(
        color: Colors.black54,
        child: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  static hide() {
    Get.back();
  }
}
