import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:the_pushapp/home/presentation/home.dart";
import "package:the_pushapp/supabase_provider.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase and auth listener
  final container = ProviderContainer();
  await container.read(clientProviderAsync.future);

  runApp(ProviderScope(
    // TODO: Remove deprecated member use
    // ignore: deprecated_member_use
    parent: container,
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "The Push App",
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const Home());
  }
}
