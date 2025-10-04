import 'dart:math';

import 'package:uuid/uuid.dart';

String generateUId() => const Uuid().v4();
String generateRandomValue() => Random().nextInt(1000000).toString();
