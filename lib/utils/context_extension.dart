import 'package:flutter/material.dart';

extension ContextExt on BuildContext {
  double get maxWidth => MediaQuery.of(this).size.width;
  double get maxHeight => MediaQuery.of(this).size.height;

  pop() => Navigator.pop(this);
}
