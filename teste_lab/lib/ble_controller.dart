import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class BleController extends GetxController {
  FlutterBlue flutterBlue = FlutterBlue.instance;

  Rx<double> posX = 100.0.obs;
  Rx<double> posY = 100.0.obs;

  Rx<bool> isScanning = false.obs;
  Rx<BluetoothDevice?> connectedDevice = Rx<BluetoothDevice?>(null);

  Future scanDevices() async {
    isScanning.value = true;
    var blePermission = await Permission.bluetoothScan.status;
    if (blePermission.isDenied) {
      if (await Permission.bluetoothScan.request().isGranted) {
        if (await Permission.bluetoothConnect.request().isGranted) {
          await flutterBlue.startScan(timeout: const Duration(seconds: 10));
          await flutterBlue.stopScan();
        }
      }
    } else {
      await flutterBlue.startScan(timeout: const Duration(seconds: 10));
      await flutterBlue.stopScan();
    }
    isScanning.value = false;
  }

  Future<void> connectDevice(BluetoothDevice device) async {
    try {
      await device.connect();
      Get.snackbar(
        "Conectado com sucesso",
        "Dispositivo ${device.name} conectado com sucesso",
        duration: const Duration(seconds: 6),
        backgroundColor: Colors.green,
      );
    } on Exception catch (e) {
      Get.snackbar(
        "Erro ao conectar",
        "Erro: $e",
        duration: const Duration(seconds: 6),
        backgroundColor: Colors.red,
      );
    }
  }

  Future<void> disconnectDevice(BluetoothDevice device) async {
    try {
      await device.disconnect();
      Get.snackbar(
        "Erro ao desconectar",
        "Dispositivo ${device.name} conectado com sucesso",
        duration: const Duration(seconds: 6),
        backgroundColor: Colors.green,
      );
    } on Exception catch (e) {
      Get.snackbar(
        "Erro ao desconectar",
        "Erro: $e",
        duration: const Duration(seconds: 6),
        backgroundColor: Colors.red,
      );
    }
  }

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

    print('position x: ${posX.value.toString()}');
    print('position y: ${posY.value.toString()}');
  }

  Stream<List<ScanResult>> get scanResults => flutterBlue.scanResults;
}
