import "dart:developer";

import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:supabase_flutter/supabase_flutter.dart";
import "package:the_pushapp/account/application/account_provider.dart";
import "package:the_pushapp/group/domain/group.dart";
import "package:the_pushapp/supabase_provider.dart";

late RealtimeChannel _realtimeChannel;

/// The group the user is in.
///
/// Listens to [accountProvider]
///
/// Needs to be manually invalidated when the group is modified.
final groupProviderAsync = FutureProvider<Group?>((ref) async {
  final account = ref.watch(accountProvider);
  if (account == null || account.groupId == null) return null;

  final client = ref.read(clientProvider);
  final group = await client
      .from("Groups")
      .select()
      .eq("id", account.groupId!)
      .count(CountOption.exact);

  if (group.count == 0) {
    _realtimeChannel.unsubscribe();
    return null;
  }

  _realtimeChannel = client
      .channel("Groups")
      .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: "public",
          table: "Groups",
          callback: (_) {
            ref.invalidateSelf();
          })
      .subscribe();

  return Group.fromJson(group.data.first);
});

/// Synchronously read [groupProviderAsync].
final groupProvider = Provider<Group?>((ref) {
  return ref.watch(groupProviderAsync).value;
});
