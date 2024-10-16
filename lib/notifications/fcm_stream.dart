import "dart:async";

import "package:firebase_messaging/firebase_messaging.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:the_pushapp/group/group_provider.dart";

/// Installs a [StreamSubscription] into memory to listen for incoming FCM messages into memory.
final fcmMessageStreamSubscriptionProvider =
    Provider<StreamSubscription>((ref) {
  return FirebaseMessaging.onMessage.listen((message) {
    print("message: $message");
    ref.invalidate(groupProviderAsync);
  });
});

/// Installs a [StreamSubscription] into memory to listen for incoming FCM messages into memory.
final fcmMessageOpenedAppStreamSubscriptionProvider =
    Provider<StreamSubscription>((ref) {
  return FirebaseMessaging.onMessageOpenedApp.listen((message) {
    print("message: $message");
    ref.invalidate(groupProviderAsync);
  });
});
