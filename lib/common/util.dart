import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:shared_preferences/shared_preferences.dart";

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

Future<bool> showConfirmationDialog({
  required String title,
  required String content,
  required BuildContext context,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text("Confirm"),
        ),
      ],
    ),
  );

  return result ?? false;
}

Future<Null> showOkDialog({
  required String title,
  required String content,
  required BuildContext context,
}) async {
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("OK"),
        ),
      ],
    ),
  );
}

void useOneTimeDialog({
  required String title,
  required String content,
  required BuildContext context,
  bool Function()? condition,
  List<Object?>? keys,
}) async {
  dialog() async {
    // see if in shared preferences
    final prefs = await SharedPreferences.getInstance();
    final key = "dialog_$title";
    if (prefs.getBool(key) == true) return;

    if (!context.mounted) return;
    await showOkDialog(title: title, content: content, context: context);
    prefs.setBool(key, true);
  }

  useEffect(() {
    if (condition?.call() != true) return;
    dialog();
    return null;
  }, keys);
}
