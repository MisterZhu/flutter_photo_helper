import 'package:flutter/material.dart';
import 'package:flutter_photo_helper/utils/router/zlx_router_helper.dart';
import 'package:flutter_photo_helper/utils/router/zlx_router_path.dart';
import 'package:get/get.dart';

import 'logic/home_logic.dart';
import 'model/home_certifi_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeLogic logic = Get.put(HomeLogic());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          '首页',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
        ),
      ),
      body: GridView.builder(
        itemCount: logic.listData.length,
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 2.5),
        padding: const EdgeInsets.all(10),
        itemBuilder: getItem,
      ),
    );
  }

  Widget getItem(context, index) {
    return InkWell(
      onTap: () {
        logic.selectIndex = index;
        logic.myCertifiModel = HomeCertifiModel.fromJson(logic.listData[index]);

        logic.myCertifiModel = HomeCertifiModel.fromJson(logic.listData[index]);
        ZLXRouterHelper.pathPage(ZLXRouterPath.processPath, null);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.deepPurple, width: 1),
          borderRadius: BorderRadius.circular(8.0), // 设置圆角
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image.network(logic.listData[index]['imageUrl']),
            Text(
              logic.listData[index]['title'],
              style:
                  const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(logic.listData[index]['describeText'])
          ],
        ),
      ),
    );
  }
}
