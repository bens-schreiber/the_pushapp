import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:the_pushapp/supabase_provider.dart';

/// Exposes the last auth state change event from supabase.
final supabaseAuthStreamProvider = StreamProvider<AuthState>((ref) {
  final supabase = ref.watch(supabaseProvider);
  return supabase.value?.auth.onAuthStateChange ?? const Stream.empty();
});

/// Whether the user is logged in to supabase or not.
/// Listens to the auth state stream and the supabase current session.
final isLoggedInProviderAsync = FutureProvider<bool>((ref) async {
  final supabase = ref.watch(supabaseProvider);
  final authStream = ref.watch(supabaseAuthStreamProvider);
  return supabase.when(
      data: (value) async =>
          value.auth.currentSession != null &&
          authStream.value?.event == AuthChangeEvent.signedIn,
      loading: () => false,
      error: (error, _) => false);
});
