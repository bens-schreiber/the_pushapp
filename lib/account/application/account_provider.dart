import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:supabase_flutter/supabase_flutter.dart";
import "package:the_pushapp/account/domain/account.dart";
import "package:the_pushapp/supabase_provider.dart";

/// Whether the user is authenticated to supabase.
final isAuthenticatedProviderAsync = FutureProvider<bool>((ref) async {
  final clientFuture = ref.watch(clientProviderAsync);
  final authStream = ref.watch(clientAuthStreamProvider);
  if (authStream.hasValue) {
    return authStream.value?.event == AuthChangeEvent.signedIn;
  }
  return clientFuture.when(
      data: (value) async => value.auth.currentSession != null,
      loading: () => false,
      error: (error, _) => false);
});

/// Whether the user is authenticated to supabase.
/// Yields from [isAuthenticatedProviderAsync].
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(isAuthenticatedProviderAsync).value == true;
});

/// The authenticated in users Account DTO.
/// Needs to be manually invalidated when an account is created or updated.
final accountProviderAsync = FutureProvider<Account?>((ref) async {
  final isLoggedIn = ref.watch(isAuthenticatedProviderAsync);
  if (isLoggedIn.value != true) return null;

  final client = ref.read(clientProvider);
  final user = await client
      .from("Users")
      .select()
      .eq("id", client.auth.currentUser!.id)
      .count(CountOption.exact);

  return user.count == 0 ? null : Account.fromJson(user.data.first);
});

/// The authenticated in users Account DTO.
/// Yields from [accountProviderAsync].
final accountProvider = Provider<Account?>((ref) {
  return ref.watch(accountProviderAsync).value;
});
