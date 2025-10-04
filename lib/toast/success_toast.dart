import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

Future<void> showSuccessFlashBar(String message, {String? data}) async {
  showSimpleNotification(
    Text(
      message,
      style: TextStyle(fontSize: 16, height: 1.5, color: Colors.white),
    ),
    autoDismiss: true,
    elevation: 0,
    duration: const Duration(seconds: 5),
    slideDismissDirection: DismissDirection.vertical,
    leading: const Icon(
      Icons.check_circle_outline_outlined,
      size: 28.0,
      color: Colors.green,
    ),
    background: const Color(0xFF303030),
  );
}
