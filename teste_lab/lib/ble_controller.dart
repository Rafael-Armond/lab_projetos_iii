import 'dart:convert';

import 'package:bluetooth_classic/models/device.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:get/get.dart';
import 'package:bluetooth_classic/bluetooth_classic.dart';

class BleController extends GetxController {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  final _bluetoothClassicPlugin = BluetoothClassic();

  Rx<double> posX = 100.0.obs;
  Rx<double> posY = 100.0.obs;

  Rx<bool> isScanning = false.obs;
  Rx<BluetoothDevice?> connectedDevice = Rx<BluetoothDevice?>(null);

  Future scanDevices() async {
    isScanning.value = true;

    List<Device> devices = await _bluetoothClassicPlugin.getPairedDevices();

    isScanning.value = false;
  }

  Future<void> connectDevice(Device device) async {
    await _bluetoothClassicPlugin.connect(
        device.address, "00001101-0000-1000-8000-00805f9b34fb");

    Get.snackbar(
      "Conectado com sucesso",
      "Dispositivo ${device.name} conectado com sucesso",
      duration: const Duration(seconds: 6),
      backgroundColor: Colors.green,
    );

    _bluetoothClassicPlugin.onDeviceDataReceived().listen((event) {
      print(utf8.decode(event));
    });
  }

  Future<void> disconnectDevice(Device device) async {}

  Future<void> discoverServices() async {
    if (connectedDevice.value != null) {
      final services = await connectedDevice.value!.discoverServices();
      for (var service in services) {
        print('Service: $service \n');
        var characteristics = service.characteristics;
        for (BluetoothCharacteristic c in characteristics) {
          List<int> value = await c.read();
          print(value);
        }
      }
    }
  }

  void changePosistion(double positionX, double positionY, double step,
      StickDragDetails details) {
    posX.value = positionX + step * details.x;
    posY.value = positionY + step * details.y;

    _bluetoothClassicPlugin
        .write("${posX.value.toString()} ${posY.value.toString()}");
  }

  Stream<List<Device>> get scanResults =>
      Stream.fromFuture(_bluetoothClassicPlugin.getPairedDevices());
}
