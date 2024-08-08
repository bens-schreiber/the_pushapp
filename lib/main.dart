import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:the_pushapp/account/data/channel.dart";
import "package:the_pushapp/account/data/deep_link.dart";
import "package:the_pushapp/group/data/channel.dart";
import "package:the_pushapp/home/presentation/home.dart";
import "package:the_pushapp/notifications/application/notifications_provider.dart";
import "package:the_pushapp/notifications/data/fcm_stream.dart";
import "package:the_pushapp/supabase_provider.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    // initial DI
    final container = ProviderContainer();

    // Firebase messaging
    final fcm = await container.read(firebaseMessagingProvider.future);
    await fcm.setAutoInitEnabled(true);
    await fcm.getAPNSToken();
    container.read(fcmTokenRefreshSubscriptionProvider);
    container.read(fcmMessageStreamSubscriptionProvider);

    // Supabase
    await container.read(clientProviderAsync.future);
    container.read(usersChannelProvider);
    container.read(groupChannelProvider);

    // Deeplink
    container.read(deepLinkSubscriptionProvider);

    runApp(ProviderScope(
      // TODO: splash screen?
      // ignore: deprecated_member_use
      parent: container,
      child: const MyApp(),
    ));
  } catch (e) {
    print(e);
  }
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
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.dark,
      home: const Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}
