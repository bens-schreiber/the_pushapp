import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:the_pushapp/account/application/account_provider.dart";
import "package:the_pushapp/group/application/group_provider.dart";
import "package:the_pushapp/home/presentation/home.dart";
import "package:the_pushapp/supabase_provider.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase, auth stream listener, and websocket channels
  final container = ProviderContainer();
  await container.read(clientProviderAsync.future);
  container.read(usersChannelProvider);
  container.read(groupChannelProvider);

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
