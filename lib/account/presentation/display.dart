import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:supabase_flutter/supabase_flutter.dart";
import "package:the_pushapp/account/application/account_provider.dart";
import "package:the_pushapp/supabase_provider.dart";

class AccountDisplay extends ConsumerWidget {
  const AccountDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(accountProvider);
    final client = ref.read(clientProvider);

    void invalidateAccount() => ref.invalidate(accountProviderAsync);

    return account == null
        ? _AccountForm(
            client: client,
            onAccountCreated: invalidateAccount,
          )
        : Text("Account: ${account.toString()}");
  }
}

class _AccountForm extends StatelessWidget {
  final SupabaseClient client;
  final Function onAccountCreated;
  _AccountForm({required this.client, required this.onAccountCreated});

  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  Future<void> _createAccount() async {
    if (_formKey.currentState?.validate() != true) return;
    final firstName = _firstNameController.text;
    final lastName = _lastNameController.text;
    await client
        .from("Users")
        .insert({"first_name": firstName, "last_name": lastName});
    onAccountCreated();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: "First name"),
            controller: _firstNameController,
            validator: (value) {
              if (value?.isEmpty == true) {
                return "Please enter your first name";
              }
              return null;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: "Last name"),
            controller: _lastNameController,
            validator: (value) {
              if (value?.isEmpty == true) {
                return "Please enter your last name";
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () => _createAccount(),
            child: const Text("Create account"),
          ),
        ],
      ),
    );
  }
}
