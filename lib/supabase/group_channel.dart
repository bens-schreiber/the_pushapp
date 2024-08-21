import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:supabase_flutter/supabase_flutter.dart";
import "package:the_pushapp/group/group_provider.dart";
import "package:the_pushapp/supabase/supabase_provider.dart";

/// Initializes the [RealtimeChannel] for the group table.
final groupChannelProvider = Provider<RealtimeChannel>((ref) {
  final client = ref.read(clientProvider);
  return client
      .channel("Groups")
      .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: "public",
          table: "Groups",
          callback: (_) {
            ref.invalidate(groupProviderAsync);
          })
      .subscribe();
});
