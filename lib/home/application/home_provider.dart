import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:the_pushapp/account/data/channel.dart";
import "package:the_pushapp/account/data/deep_link.dart";
import "package:the_pushapp/group/application/group_provider.dart";
import "package:the_pushapp/group/data/channel.dart";
import "package:the_pushapp/notifications/application/notifications_provider.dart";
import "package:the_pushapp/notifications/data/fcm_stream.dart";
import "package:the_pushapp/supabase_provider.dart";
import "package:the_pushapp/token/application/token_provider.dart";

/// Initializes root providers.
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

/// True if the sliding bottom sheet should be locked.
final lockSlidingBottomSheetProvider = Provider((ref) {
  final initFinishedAsync = ref.watch(initializeAppProviderAsync);
  final loadingAnimation = ref.watch(tokenLoadingAnimationStateProvider);
  final group = ref.watch(groupProvider);

  return initFinishedAsync.value != true ||
      loadingAnimation == true ||
      group == null;
});
