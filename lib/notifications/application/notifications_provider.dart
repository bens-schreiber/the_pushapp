import "package:firebase_core/firebase_core.dart";
import "package:firebase_messaging/firebase_messaging.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:the_pushapp/firebase_options.dart";

/// Provides the [FirebaseMessaging] instance.
final firebaseMessagingProvider = FutureProvider((ref) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  return FirebaseMessaging.instance;
});

/// Provides the [NotificationSettings] for the [FirebaseMessaging] instance.
///
/// Listens to [firebaseMessagingProvider]
final notificationPreferencesProvider =
    FutureProvider<NotificationSettings?>((ref) async {
  final fcmAsync = ref.watch(firebaseMessagingProvider);
  if (fcmAsync.hasError || fcmAsync.isLoading) return null;

  final fcm = fcmAsync.value!;
  return await fcm.getNotificationSettings();
});

/// Creates a new FCM token
final fcmTokenProvider = FutureProvider<String?>((ref) async {
  final fcmAsync = ref.watch(firebaseMessagingProvider);
  if (fcmAsync.hasError || fcmAsync.isLoading) return null;

  return await fcmAsync.value!.getToken();
});
