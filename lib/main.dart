import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:the_pushapp/account/application/account_provider.dart";
import "package:the_pushapp/account/presentation/account_display.dart";
import "package:the_pushapp/account/presentation/login_form.dart";
import "package:the_pushapp/group/presentation/group_display.dart";
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

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final client = ref.read(clientProvider);
    final isAuthenticated = ref.watch(isAuthenticatedProvider);

    const homeDisplay = Column(
      children: [AccountDisplay(), SizedBox(height: 10), GroupDisplay()],
    );

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            client.auth.signOut();
          },
          child: const Icon(Icons.refresh),
        ),
        body: Center(
          child: Padding(
              padding: const EdgeInsets.only(top: 100),
              child: isAuthenticated ? homeDisplay : const LoginForm()),
        ));
  }
}
