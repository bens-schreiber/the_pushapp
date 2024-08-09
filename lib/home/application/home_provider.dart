import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:the_pushapp/account/application/account_provider.dart";
import "package:the_pushapp/account/data/channel.dart";
import "package:the_pushapp/account/data/deep_link.dart";
import "package:the_pushapp/group/data/channel.dart";
import "package:the_pushapp/notifications/application/notifications_provider.dart";
import "package:the_pushapp/notifications/data/fcm_stream.dart";
import "package:the_pushapp/supabase_provider.dart";

final initializeAppProviderAsync = FutureProvider<bool>((ref) async {
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

  return true;
});

/// Signals when the loading animation is complete.
final loadingAnimationStateProvider = StateProvider<bool>((ref) => false);

final lockSlidingBottomSheetProvider = Provider((ref) {
  final initFinishedAsync = ref.watch(initializeAppProviderAsync);
  final loadingAnimation = ref.watch(loadingAnimationStateProvider);
  final isAuth = ref.watch(isAuthenticatedProvider);

  return initFinishedAsync.value == true &&
      loadingAnimation == false &&
      isAuth == true;
});
