import 'package:flutter/material.dart';
import 'package:flutter_photo_helper/pages/home/home_page.dart';
import 'package:flutter_photo_helper/utils/router/zlx_router_path.dart';
import 'package:get/get.dart';

import 'public/zlx_all_binding.dart';
import 'utils/router/zlx_router_pages.dart';

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
      getPages: ZLXRouterPages.getPages,
      initialRoute: basePath,
      initialBinding: ZLXAllBinding(),
      // home: const HomePage(),
    );
  }
}
