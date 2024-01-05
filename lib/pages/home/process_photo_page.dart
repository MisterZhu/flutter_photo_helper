import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'logic/home_logic.dart';

class ProcessPhotoPage extends StatefulWidget {
  const ProcessPhotoPage({super.key});
  @override
  State<ProcessPhotoPage> createState() => _ProcessPhotoPageState();
}

class _ProcessPhotoPageState extends State<ProcessPhotoPage> {
  final HomeLogic logic = Get.put(HomeLogic());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          '一寸照片',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
        ),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              '从相册选择自己的照片或用相机拍照',
            ),
            const SizedBox(
              height: 100,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 150, // 设置宽度
                  height: 50, // 设置高度
                  child: ElevatedButton(
                    onPressed: () {
                      logic.selectImageFromGallery();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // 设置背景颜色
                      side: const BorderSide(
                          color: Colors.deepPurple, width: 1.0), // 设置边框颜色和宽度
                    ),
                    child: const Text(
                      '从相册选择',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 150, // 设置宽度
                  height: 50, // 设置高度
                  child: ElevatedButton(
                    onPressed: () {
                      logic.captureImageWithCamera();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple[400], // 设置背景颜色
                    ),
                    child: const Text(
                      '去拍照',
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            // const SizedBox(
            //   height: 100,
            // ),
            // Text(_batteryLevel),
          ],
        ),
      ),
    );
  }

  Widget getItem(context, index) {
    return InkWell(
      onTap: () {
        logic.selectIndex = index;
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
