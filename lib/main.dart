import "dart:async";
import "dart:convert";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:json_theme/json_theme.dart";
import "package:the_pushapp/group/application/group_provider.dart";
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
      home: const BindingObserver(child: HomeScreen()),
      debugShowCheckedModeBanner: false,
    );
  }
}

class BindingObserver extends ConsumerStatefulWidget {
  final Widget child;
  const BindingObserver({super.key, required this.child});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BindingObserverState();
}

class _BindingObserverState extends ConsumerState<BindingObserver>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      ref.invalidate(groupProviderAsync);
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }
}
