import 'package:flutter_photo_helper/pages/home/logic/home_logic.dart';
import 'package:get/get.dart';

/// 首页-binding
class ZLXAllBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeLogic>(() => HomeLogic());
  }
}
