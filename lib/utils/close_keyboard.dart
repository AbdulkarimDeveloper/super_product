import 'package:flutter/material.dart';

void closeKeyBoard(BuildContext context) {
  try {
    FocusScopeNode currentFocus = FocusScope.of(context);
    FocusManager.instance.primaryFocus?.unfocus();

    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      currentFocus.focusedChild?.unfocus();
    }
  } catch (e) {}
}
