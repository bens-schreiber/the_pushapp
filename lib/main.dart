import "dart:async";
import "dart:convert";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:json_theme/json_theme.dart";
import "package:the_pushapp/home/presentation/home.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // theme
  final theme = await rootBundle.loadString("assets/theme.json");
  final themeJson = jsonDecode(theme);
  final themeData = ThemeDecoder.decodeThemeData(themeJson)!;

  runApp(
    ProviderScope(
      child: MyApp(theme: themeData),
    ),
  );
}

class MyApp extends StatelessWidget {
  final ThemeData theme;
  const MyApp({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "The Push App",
      theme: theme,
      themeMode: ThemeMode.dark,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
