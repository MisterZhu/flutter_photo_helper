import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_photo_helper/pages/home/home_page.dart';
import 'package:flutter_photo_helper/utils/router/zlx_router_path.dart';
import 'package:get/get.dart';

import 'public/zlx_all_binding.dart';
import 'utils/router/zlx_router_pages.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  /// 路由的basePath
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    String basePath = ZLXRouterPath.homePath;

    return GetMaterialApp(
      title: 'demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      navigatorKey: navigatorKey,
      getPages: ZLXRouterPages.getPages,
      initialRoute: basePath,
      initialBinding: ZLXAllBinding(),
      builder: EasyLoading.init(
        builder: (context, widget) {
          return MediaQuery(
            // 设置文字大小不随系统设置改变
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: widget ?? const SizedBox(),
          );
        },
      ),
      // home: const HomePage(),
    );
  }
}
