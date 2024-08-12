import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:the_pushapp/account/application/account_provider.dart";
import "package:the_pushapp/group/application/group_provider.dart";

/// True if the current user is the token holder.
///
/// Listens to the [groupProvider] and [accountProvider].
final isTokenHolderProvider = Provider<bool>((ref) {
  final group = ref.watch(groupProvider);
  final account = ref.watch(accountProvider);
  return account != null && group?.tokenUserId == account.id;
});

/// Signals when the token loading animation is occuring.
/// Synced with the animation duration.
final tokenLoadingProviderAsync = FutureProvider(
    (ref) async => await Future.delayed(const Duration(seconds: 2)));
