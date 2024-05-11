// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import 'bluetooth_logic.dart';
//
// class BluetoothPage extends StatelessWidget {
//   BluetoothPage({Key? key}) : super(key: key);
//
//   final logic = Get.put(BluetoothLogic());
//   final state = Get.find<BluetoothLogic>().state;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ble_scanner.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class bleScanTest extends StatefulWidget {
  const bleScanTest({super.key});

  @override
  State<bleScanTest> createState() => _bleScanTestState();
}

class _bleScanTestState extends State<bleScanTest> {
  final bleScanner = BLE_Scanner();
  List<ScanResult>? _scanResults;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('蓝牙扫描流接收测试')),
      body: StreamBuilder<ScanResult?>(
        stream: bleScanner.bleScanStream,
        builder: (BuildContext context, AsyncSnapshot<ScanResult?> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return const Text('没有数据流');
            case ConnectionState.active:
              if (snapshot.hasError) {
                return Text('Active: 错误: ${snapshot.error}');
              } else {
                _scanResults ??= [];
                if (snapshot.data!.device.platformName.isNotEmpty) {
                  _scanResults!.add(snapshot.data!);
                }
                print(_scanResults);
                return ListView.builder(
                  itemCount: _scanResults?.length,
                  itemBuilder: (BuildContext context, int index) {
                    final scanResult = _scanResults![index];
                    return ListTile(
                      title: Text('设备名称: ${scanResult.device.platformName}'),
                      subtitle: Text('设备ID: ${scanResult.device.remoteId}'),
                      onTap: () {
                        //连接逻辑,自己写
                      },
                    );
                  },
                );
              }
            case ConnectionState.waiting:
              return const Text('等待数据流');
            case ConnectionState.done:
              return const Text('数据流已经关闭');
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (_scanResults != null) {
              _scanResults!.clear();
            }
            bleScanner.startBleScan();
          },
          child: const Icon(Icons.bluetooth_searching)),
    );
  }
}
