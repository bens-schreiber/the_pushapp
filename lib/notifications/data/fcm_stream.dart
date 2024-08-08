import "dart:async";

import "package:firebase_messaging/firebase_messaging.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:the_pushapp/account/application/account_provider.dart";
import "package:the_pushapp/notifications/application/notifications_provider.dart";
import "package:the_pushapp/supabase_provider.dart";

/// Installs a [StreamSubscription] into memory to listen for incoming FCM messages into memory.
final fcmMessageStreamSubscriptionProvider =
    Provider<StreamSubscription>((ref) {
  return FirebaseMessaging.onMessage.listen((message) {
    print("message: $message");
    ref.invalidate(accountProvider); //TODO: may only want to invalidate group
  });
});

/// Installs a [StreamSubscription] into memory to listen for FCM token refreshes.
final fcmTokenRefreshSubscriptionProvider = Provider<StreamSubscription>((ref) {
  final fcm = ref.read(firebaseMessagingProvider).requireValue;
  return fcm.onTokenRefresh.listen((token) async {
    final client = ref.read(clientProvider);
    if (client.auth.currentUser == null) return;
    await client
        .from("Users")
        .update({"fcm": token}).eq("id", client.auth.currentUser!.id);
  });
});
