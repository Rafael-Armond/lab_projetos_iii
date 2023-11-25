import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class CardDevice extends StatelessWidget {
  final ScanResult data;
  final VoidCallback onTap;

  const CardDevice({super.key, required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: const Color.fromARGB(124, 245, 198, 198),
      child: Card(
        elevation: 2,
        child: ListTile(
          title: Text(data.device.name),
          subtitle: Text(data.device.id.id),
          trailing: Text(data.rssi.toString()),
        ),
      ),
    );
  }
}
