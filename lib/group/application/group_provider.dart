import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:supabase_flutter/supabase_flutter.dart";
import "package:the_pushapp/account/application/account_provider.dart";
import "package:the_pushapp/account/domain/account.dart";
import "package:the_pushapp/group/domain/group.dart";
import "package:the_pushapp/supabase_provider.dart";

/// The group the user is in.
///
/// Listens to [accountProvider]
///
/// Invalidated by the [groupChannelProvider] web socket.
final groupProviderAsync = FutureProvider<Group?>((ref) async {
  final account = ref.watch(accountProvider);
  if (account == null || account.groupId == null) return null;

  final client = ref.read(clientProvider);
  final group = await client
      .from("Groups")
      .select()
      .eq("id", account.groupId!)
      .count(CountOption.exact);

  return Group.fromJson(group.data.first);
});

/// Synchronously read [groupProviderAsync].
final groupProvider = Provider<Group?>((ref) {
  return ref.watch(groupProviderAsync).value;
});

/// The members of the group.
///
/// Listens to [groupProvider]
///
/// Invalidated by the [groupChannelProvider] web socket.
final groupMembersProviderAsync = FutureProvider<List<Account>>((ref) async {
  final group = ref.watch(groupProvider);
  if (group == null) return [];

  final client = ref.read(clientProvider);

  // supabase read policy will return only us and group members
  final members = await client.from("Users").select().count(CountOption.exact);

  return members.data.map((e) => Account.fromJson(e)).toList();
});

/// Synchronously read [groupMembersProviderAsync].
final groupMembersProvider = Provider<List<Account>>((ref) {
  return ref.watch(groupMembersProviderAsync).value ?? [];
});
