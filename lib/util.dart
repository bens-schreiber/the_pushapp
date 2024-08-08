import "package:flutter/material.dart";

void showSnackbar(String text, BuildContext context) {
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(text),
  ));
}

Future<bool> useErrorHandle(Function f, BuildContext context) async {
  try {
    await f();
    return true;
  } catch (e) {
    final error = "Error: $e";
    showSnackbar(error, context);
    return false;
  }
}
