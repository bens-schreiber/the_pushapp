import "package:flutter/material.dart";

void showSnackbar(String text, BuildContext context) {
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(text),
  ));
}

bool useErrorSnackbar(Function f, BuildContext context) {
  try {
    f();
    return true;
  } catch (e) {
    final error = "Error: $e";
    showSnackbar(error, context);
    return false;
  }
}
