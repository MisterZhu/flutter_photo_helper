import 'package:flutter_photo_helper/pages/bluetooth/bluetooth_view.dart';
import 'package:get/get.dart';

import '../../pages/home/process_photo_page.dart';
import '../../pages/home/home_page.dart';

import 'zlx_router_path.dart';

/// 路由-pages
class ZLXRouterPages {
  /*根据path使用路由*/
  static final List<GetPage> getPages = [
    /*首页*/
    GetPage(name: ZLXRouterPath.homePath, page: () => const HomePage()),
    // GetPage(name: ZLXRouterPath.bluetoothPath, page: () => BluetoothPage()),
    GetPage(name: ZLXRouterPath.bluetoothPath, page: () => const bleScanTest()),

    GetPage(
        name: ZLXRouterPath.processPath, page: () => const ProcessPhotoPage()),
  ];
}
