import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BLE_Scanner {
  //创建一个controller控制流
  final _bleScanController = StreamController<ScanResult?>();

  Future<void> startBleScan() async {
    //把扫描结果添加到流里面
    FlutterBluePlus.scanResults.listen((event) {
      for (ScanResult element in event) {
        _bleScanController.add(element);
      }
    });
    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));
  }

  //停止扫描接口
  Future<void> stopBleScan() async {
    await FlutterBluePlus.stopScan();
  }

  // 获取蓝牙扫描结果的 Stream,作为接口返回出去
  Stream<ScanResult?> get bleScanStream => _bleScanController.stream;
}
