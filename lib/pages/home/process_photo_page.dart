import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
    return GetBuilder<HomeLogic>(builder: (state) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text(
            '一寸照片',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildContent(),
            // const Spacer(),
            _bottomContent(),
            _bottomBtnWidget(),
          ],
        ),
      );
    });
  }

  Widget _bottomContent() {
    return (logic.imageState != 2 && logic.isShowColors)
        ? Container()
        : SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 15, right: 15, bottom: 10.0, top: 45),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  7,
                  (index) => GestureDetector(
                    onTap: () {
                      logic.changeColor(_getColorForIndex(index));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        width: 45, // 根据需要调整宽度
                        height: 45, // 根据需要调整高度
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _getColorForIndex(index), // 自定义颜色
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  Widget _bottomBtnWidget() {
    return logic.imageState != 2
        ? Container()
        : Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildButton(
                  icon: Icons.photo_outlined,
                  label: '选择照片',
                  onTap: () {
                    // 处理选择照片的点击事件
                    logic.selectImageFromGallery();
                  },
                ),
                _buildVerticalDivider(),
                _buildButton(
                  icon: Icons.camera_alt_outlined,
                  label: '拍照上传',
                  onTap: () {
                    logic.captureImageWithCamera();
                  },
                ),
                _buildVerticalDivider(),
                _buildButton(
                  icon: Icons.photo_camera_back_outlined,
                  label: '选择底色',
                  onTap: () {
                    // 处理选择底色的点击事件
                    logic.changeShowColorS();
                  },
                ),
                _buildVerticalDivider(),
                _buildButton(
                  icon: Icons.save_alt_rounded,
                  label: '保存图片',
                  onTap: () {
                    // 处理保存图片的点击事件
                  },
                ),
              ],
            ),
          );
  }

  Widget _buildButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
        child: Column(
          children: [
            Icon(icon),
            const SizedBox(height: 5),
            Text(label),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return const DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.grey,
      ),
      child: SizedBox(
        width: 1,
        height: 30,
      ),
    );
  }

  Color _getColorForIndex(int index) {
    // 根据索引返回颜色
    // 这里只是一个示例，你可以根据需要更改颜色
    switch (index) {
      case 0:
        return Colors.blue;
      case 1:
        return Colors.red;
      case 2:
        return Colors.green;
      case 3:
        return Colors.yellow;
      case 4:
        return Colors.orange;
      case 5:
        return Colors.purple;
      case 6:
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }

  Widget _buildContent() {
    switch (logic.imageState) {
      case 0:
        return _selectBtnWidget();
      case 1:
        return _loadingWidget();
      case 2:
        return _photoWidget();
      // Add more cases for other states as needed
      default:
        return Container(); // Default case, or you can throw an error.
    }
  }

  Widget _photoWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 55, right: 55),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 44 / 64, // 你的照片宽高比
            child: Container(
              color: logic.bgColor,
              child: Center(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Image.memory(
                    logic.imageData,
                    fit: BoxFit.scaleDown, // 使用BoxFit.scaleDown等比例缩放
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _loadingWidget() {
    // const SpinKitPouringHourGlass(size: 101.0,color: Colors.deepPurple)
    // const SpinKitCubeGrid(size: 101.0, color: Colors.deepPurple)
    // const SpinKitFadingGrid(color: Colors.deepPurple, size: 105.0, shape: BoxShape.rectangle)
    // const SpinKitDancingSquare(color: Colors.deepPurple, size: 145.0,)
    //  const SpinKitFadingGrid(color: Colors.deepPurple, size: 105.0,);
    //    SpinKitFadingGrid(color: Colors.white, shape: BoxShape.rectangle),
    //    SpinKitPulsingGrid(color: Colors.white),
    //SpinKitPulsingGrid(color: Colors.white, boxShape: BoxShape.rectangle)
    return Stack(
      alignment: Alignment.center,
      children: [
        // SpinKitFadingGrid goes here
        const SpinKitPulsingGrid(
            color: Colors.deepPurple,
            size: 105.0,
            boxShape: BoxShape.rectangle),
        // Add an overlay widget (e.g., a semi-transparent container)
        Container(
          color: Colors.black.withOpacity(0.2), // Adjust the opacity as needed
        ),
        // You can add other overlay elements here if necessary
      ],
    );
  }

  Widget _selectBtnWidget() {
    // Build your UI for state2
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SizedBox(
          height: 50,
        ),
        const Text(
          '从相册选择自己的照片或用相机拍照',
        ),
        const SizedBox(
          height: 50,
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
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
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
    );
  }
}
