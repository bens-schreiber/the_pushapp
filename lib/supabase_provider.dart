import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseProvider = FutureProvider((ref) async {
  final supabase = await Supabase.initialize(
    url: "https://tywqkhiiksnnvtdswlbc.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InR5d3FraGlpa3NubnZ0ZHN3bGJjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjI4MDk5NDAsImV4cCI6MjAzODM4NTk0MH0.VSQLswtGZhlrc06k64F47geS6K6_lits3a1Sk4w7akI",
  );
  return supabase.client;
});
