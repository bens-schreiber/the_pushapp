import "dart:async";

import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:supabase_flutter/supabase_flutter.dart";
import "package:the_pushapp/supabase_provider.dart";
import "package:uni_links/uni_links.dart";

Future<void> handleLink(SupabaseClient client, String? link) async {
  if (link == null) {
    return;
  }

  final uri = Uri.parse(link);
  final invite = uri.queryParameters["invite"];
  if (invite == null) return;

  await client
      .from("Users")
      .update({"group_id": invite}).eq("id", client.auth.currentUser!.id);
}

final deepLinkSubscriptionProvider = Provider<StreamSubscription>((ref) {
  final client = ref.read(clientProvider);
  getInitialLink().then((link) {
    handleLink(client, link);
  });

  return linkStream.listen((link) {
    handleLink(client, link);
  });
});
