import "dart:async";
import "dart:convert";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:json_theme/json_theme.dart";
import "package:the_pushapp/group/group_provider.dart";
import "package:the_pushapp/home/presentation/home.dart";
import "package:the_pushapp/notifications/fcm_stream.dart";
import "package:the_pushapp/notifications/notifications_provider.dart";
import "package:the_pushapp/supabase/supabase_provider.dart";
import "package:the_pushapp/supabase/user_channel.dart";
import "package:the_pushapp/supabase/group_channel.dart";
import "package:the_pushapp/group/deep_link.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  //#region Load theme
  final theme = await rootBundle.loadString("assets/theme.json");
  final themeJson = jsonDecode(theme);
  final themeData = ThemeDecoder.decodeThemeData(themeJson)!;
  //#endregion

  runApp(
    ProviderScope(
      child: MyApp(theme: themeData),
    ),
  );
}

/// When an FCM notification is sent and the app is in the background,
/// the fcm stream will not be listened to. This widget wraps the app in a
/// binding observer to invalidate the group provider any time the app is resumed,
/// to account for any changes that may have occurred while the app was in the background.
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

class InitializeDi extends ConsumerWidget {
  final Widget body;
  const InitializeDi({super.key, required this.body});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    init() async {
      // Supabase
      await ref.read(clientProviderAsync.future);
      ref.read(usersChannelProvider);
      ref.read(groupChannelProvider);

      // Deeplink
      ref.read(deepLinkSubscriptionProvider);

      // Firebase messaging
      final fcm = await ref.read(firebaseMessagingProviderAsync.future);
      await fcm.setAutoInitEnabled(true);
      await fcm.getAPNSToken();
      ref.read(fcmMessageStreamSubscriptionProvider);
      ref.read(fcmMessageOpenedAppStreamSubscriptionProvider);

      return true;
    }

    return FutureBuilder(
        future: init(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return body;
          }

          return const SizedBox.shrink();
        });
  }
}

class MyApp extends StatelessWidget {
  final ThemeData theme;
  const MyApp({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/": (context) => const BindingObserver(
              child: InitializeDi(
                body: HomeScreen(),
              ),
            ),
      },
      title: "The Push App",
      theme: theme,
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
    );
  }
}
