import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:the_pushapp/account/data/channel.dart";
import "package:the_pushapp/account/data/deep_link.dart";
import "package:the_pushapp/group/data/channel.dart";
import "package:the_pushapp/home/presentation/home.dart";
import "package:the_pushapp/supabase_provider.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase, auth stream listener, websocket channels, and deep link handling
  final container = ProviderContainer();
  await container.read(clientProviderAsync.future);

  container.read(usersChannelProvider);
  container.read(groupChannelProvider);
  container.read(deepLinkSubscriptionProvider);

  runApp(ProviderScope(
    // TODO: splash screen?
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
