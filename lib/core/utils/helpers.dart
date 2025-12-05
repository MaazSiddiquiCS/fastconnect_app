import 'package:flutter/material.dart';

class Helpers {
  static void showSnack(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        behavior: SnackBarBehavior.floating,               
        backgroundColor: Theme.of(context).colorScheme.primary
      ),
    );
  }

  static bool isEmailValid(String email) {
    final regex = RegExp(r"^[\w\.-]+@[\w\.-]+\.\w+$");
    return regex.hasMatch(email.trim());
  }

  static void dismissKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
