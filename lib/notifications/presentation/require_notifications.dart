import "package:firebase_messaging/firebase_messaging.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:the_pushapp/notifications/notifications_provider.dart";

class RequireNotifications extends ConsumerWidget {
  final Widget child;
  final bool hide;
  const RequireNotifications(
      {required this.child, this.hide = false, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationPreferences =
        ref.watch(notificationPreferencesProviderAsync);

    error(e) => Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Error: $e"),
                ElevatedButton(
                  onPressed: () =>
                      ref.refresh(notificationPreferencesProviderAsync),
                  child: const Text("Retry"),
                )
              ],
            ),
          ),
        );

    hasNotificationsEnabled(NotificationSettings? s) =>
        s?.alert == AppleNotificationSetting.enabled;

    const requireNotifications = Scaffold(
      body: Center(
        child: Text("Please enable notifications"),
      ),
    );

    return notificationPreferences.when(
      data: (s) {
        final enabled = hasNotificationsEnabled(s);
        final providerInitialized =
            ref.read(firebaseMessagingProviderAsync).hasValue;

        if (!enabled && providerInitialized) {
          ref
              .read(firebaseMessagingProviderAsync)
              .value!
              .requestPermission(alert: true, announcement: true)
              .then((_) async {
            await Future.delayed(
                const Duration(seconds: 1)); // rebuilds too fast
            ref.invalidate(notificationPreferencesProviderAsync);
          });

          return requireNotifications;
        }
        return child;
      },
      loading: () => const SizedBox.shrink(),
      error: (e, _) => error(e),
    );
  }
}
