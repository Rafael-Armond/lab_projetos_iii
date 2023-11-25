import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:get/get.dart';
import 'package:teste_lab/ble_controller.dart';
import 'package:teste_lab/card_device.dart';

class JoystickScreen extends StatelessWidget {
  final JoystickController _joystickController = JoystickController();
  final _bleController = Get.find<BleController>();

  JoystickScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lab. de Projetos III"),
        centerTitle: true,
      ),
      body: GetBuilder<BleController>(
        init: BleController(),
        builder: (controller) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: const Alignment(0, 0.8),
                        child: Joystick(
                          mode: JoystickMode.all,
                          controller: _joystickController,
                          listener: (details) {
                            _bleController.changePosistion(
                                _bleController.posX.value,
                                _bleController.posY.value,
                                10,
                                details);
                          },
                          onStickDragEnd: () {
                            _bleController.posX.value = 100;
                            _bleController.posY.value = 100;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Obx(
                  () => ElevatedButton(
                    onPressed: _bleController.isScanning.value
                        ? null
                        : () async => await controller.scanDevices(),
                    child: const Text("Escanear"),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                SingleChildScrollView(
                  child: StreamBuilder<List<ScanResult>>(
                    stream: controller.scanResults,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final data = snapshot.data![index];
                              return CardDevice(
                                  onTap: () async {
                                    await _bleController
                                        .connectDevice(data.device);
                                  },
                                  data: data);
                            });
                      } else {
                        return const Center(
                          child: Text("No Device Found"),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
