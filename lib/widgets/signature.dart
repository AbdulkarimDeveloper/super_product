import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

class SignatureWidget extends StatefulWidget {
  const SignatureWidget({
    super.key,
    this.borderColor,
    required this.signatureController,
  });
  final Color? borderColor;
  final SignatureController signatureController;
  @override
  // ignore: library_private_types_in_public_api
  _SignatureWidgetState createState() => _SignatureWidgetState();
}

class _SignatureWidgetState extends State<SignatureWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: widget.borderColor ?? Colors.green),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Column(
          children: <Widget>[
            Signature(
              controller: widget.signatureController,
              height: 150 * 1.5,
              width: 150 * 1.5,
              backgroundColor: Colors.white,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.clear),
                  color: Colors.green,
                  onPressed: () {
                    widget.signatureController.clear();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

List<Point> compressPoints(List<Point> pointsParams) {
  List<Point> point = [];

  //resize  signature
  for (var element in [...pointsParams]) {
    Point p = Point(
      Offset(element.offset.dx / 3, element.offset.dy / 3),
      element.type,
      element.pressure,
    );
    point.add(p);
  }
  return point;
}
