import 'package:get/get.dart';
import 'package:teste_lab/ble_controller.dart';

Future<void> dependencyManagement() async {
  Get.put(BleController());
}
