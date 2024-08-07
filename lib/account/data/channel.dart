import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:supabase_flutter/supabase_flutter.dart";
import "package:the_pushapp/account/application/account_provider.dart";
import "package:the_pushapp/supabase_provider.dart";

/// Initializes the [RealtimeChannel] for the user table.
final usersChannelProvider = Provider<RealtimeChannel>((ref) {
  final client = ref.read(clientProvider);
  return client
      .channel("Users")
      .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: "public",
          table: "Users",
          callback: (_) {
            ref.invalidate(accountProviderAsync);
          })
      .subscribe();
});
