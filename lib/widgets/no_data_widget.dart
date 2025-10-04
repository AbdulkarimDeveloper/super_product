import 'package:flutter/material.dart';
import 'package:test_project/utils/app_resources.dart';

class NoDataWidget extends StatelessWidget {
  const NoDataWidget({super.key, this.onTap});

  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(AppResources.noData, width: 100, height: 100),
          SizedBox(height: 20),
          Text('لا يوجد منتجات', style: TextStyle(fontSize: 30)),
        ],
      ),
    );
  }
}
