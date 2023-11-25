import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:teste_lab/bluetooth_off_screen.dart';
import 'package:teste_lab/injection_container.dart';
import 'package:teste_lab/joystick_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  dependencyManagement();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: StreamBuilder<BluetoothState>(
        stream: FlutterBlue.instance.state,
        initialData: BluetoothState.unknown,
        builder: (c, snapshot) {
          final state = snapshot.data;
          if (state == BluetoothState.on) {
            return JoystickScreen();
          }
          return const BluetoothOffScreen();
        },
      ),
    );
  }
}
