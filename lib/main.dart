import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_pushapp/login/application/login_provider.dart';
import 'package:the_pushapp/login/presentation/login.dart';
import 'package:the_pushapp/supabase_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final supabase = ref.watch(supabaseProvider);
    return switch (supabase) {
      AsyncError(:final error) => Text('Error: $error'),
      AsyncData() => const _MyAppImpl(),
      _ => const CircularProgressIndicator(),
    };
  }
}

class _MyAppImpl extends StatelessWidget {
  const _MyAppImpl();

  @override
  Widget build(
    BuildContext context,
  ) {
    return MaterialApp(
        title: 'The Push App',
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
    final isLoggedIn = (ref.watch(isLoggedInProviderAsync)).value == true;
    final supabase = ref.watch(supabaseProvider);

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            supabase.value?.auth.signOut();
          },
          child: const Icon(Icons.refresh),
        ),
        body: Center(
            child: isLoggedIn
                ? const Text('Logged in')
                : const Padding(
                    padding: EdgeInsets.only(top: 100),
                    child: LoginDisplay())));
  }
}
