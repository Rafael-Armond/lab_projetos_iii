import 'package:flutter/material.dart';

class ObjectDetected extends StatelessWidget {
  final bool detected;
  final String title;
  const ObjectDetected(
      {super.key, required this.detected, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: detected ? Colors.green : Colors.amber,
      width: 90,
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
