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
        body: Center(
          child: _buildContent(),
        ),
      );
    });
  }
  Widget _buildContent() {
    switch (logic.imageState) {
      case 0:
        return _selectBtnWidget();
      case 1:
        return _loadingWidget();
    // Add more cases for other states as needed
      default:
        return Container(); // Default case, or you can throw an error.
    }
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
        const SpinKitPulsingGrid(color: Colors.deepPurple, size: 105.0, boxShape: BoxShape.rectangle),
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
    );
  }
}
