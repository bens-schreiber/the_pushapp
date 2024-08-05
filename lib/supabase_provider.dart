import "dart:async";

import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:supabase_flutter/supabase_flutter.dart";

// ignore: unused_element
late StreamSubscription _authSubscription;

final clientProviderAsync = FutureProvider<SupabaseClient>((ref) async {
  final supabase = await Supabase.initialize(
    url: "https://tywqkhiiksnnvtdswlbc.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InR5d3FraGlpa3NubnZ0ZHN3bGJjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjI4MDk5NDAsImV4cCI6MjAzODM4NTk0MH0.VSQLswtGZhlrc06k64F47geS6K6_lits3a1Sk4w7akI",
  );

  final client = supabase.client;

  // Load the session from shared preferences if it exists
  final prefs = await SharedPreferences.getInstance();
  final session = prefs.getString("session");
  if (session != null) {
    client.auth.recoverSession(session);
  }

  // Listen to auth state changes and persist the session
  _authSubscription = client.auth.onAuthStateChange.listen((state) async {
    if (state.event == AuthChangeEvent.signedOut) {
      await prefs.remove("session");
    } else {
      await prefs.setString(
          "session", client.auth.currentSession!.toJson().toString());
    }
  });

  return client;
});

/// Yields from [clientProviderAsync].
final clientProvider = Provider<SupabaseClient>(
    (ref) => ref.watch(clientProviderAsync).requireValue);

/// Exposes the last auth state change event from supabase.
final clientAuthStreamProvider = StreamProvider<AuthState>((ref) {
  final clientFuture = ref.watch(clientProviderAsync);
  return clientFuture.value?.auth.onAuthStateChange ?? const Stream.empty();
});
