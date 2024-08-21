import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";

void showSnackbar(String text, BuildContext context) {
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(text),
  ));
}

Future<bool> inErrorHandler(Function f, BuildContext context) async {
  try {
    await f();
    return true;
  } catch (e) {
    final error = "Error: $e";
    showSnackbar(error, context);
    return false;
  }
}

ValueNotifier<Future<T>?> useFutureLoader<T>() => useState<Future<T>?>(null);
