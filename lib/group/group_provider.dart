import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:supabase_flutter/supabase_flutter.dart";
import "package:the_pushapp/account/account_provider.dart";
import "package:the_pushapp/account/freezed/account.dart";
import "package:the_pushapp/group/freezed/group.dart";
import "package:the_pushapp/supabase/supabase_provider.dart";

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

  try {
    final members = await client.from("Users").select().count();
    return members.data.map((e) => Account.fromJson(e)).toList();
  } catch (e) {
    return [];
  }

  // return members.data.map((e) => Account.fromJson(e)).toList();
});

/// Synchronously read [groupMembersProviderAsync].
final groupMembersProvider = Provider<List<Account>>((ref) {
  return ref.watch(groupMembersProviderAsync).value ?? [];
});

final groupPhotosProviderAsync =
    FutureProvider.autoDispose<List<String>>((ref) async {
  final members = ref.watch(groupMembersProvider);
  if (members == []) return [];

  final client = ref.read(clientProvider);

  // TODO: certainly must be a better way to do this
  List<String> urls = [];
  for (var m in members) {
    final media = await client.storage
        .from("Group Media")
        .list(path: "${m.id}/${m.groupId}");

    if (media.isEmpty) continue;
    media.removeWhere((e) => e.name == ".emptyFolderPlaceholder");

    final last = media.reduce((a, b) =>
        DateTime.parse(a.name).compareTo(DateTime.parse(b.name)) > 1 ? a : b);

    final url = client.storage
        .from("Group Media")
        .getPublicUrl("${m.id}/${m.groupId}/${last.name}");

    urls.add(url);
  }

  return urls;
});
