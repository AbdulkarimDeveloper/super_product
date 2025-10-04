import 'package:flutter/material.dart';

class FailureWidget extends StatelessWidget {
  const FailureWidget({super.key, this.onTap});

  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.cancel_outlined, color: Colors.red, size: 60),
          SizedBox(height: 20),
          Text('حدث خطأ ما', style: TextStyle(fontSize: 30)),
        ],
      ),
    );
  }
}
