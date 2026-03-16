import 'package:flutter/material.dart';
import 'auth_service.dart'; // Vérifie que le chemin est correct

class PasswordResetPage extends StatefulWidget {
  const PasswordResetPage({super.key});

  @override
  State<PasswordResetPage> createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  final _formKey = GlobalKey<FormState>();
  String email = "";
  bool loading = false;

  Future<void> _sendResetCode() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => loading = true);

      try {
        final data = await AuthService.sendResetCode(email);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"] ?? "Code envoyé à votre email")),
        );

        Navigator.pushNamed(context, "/verify-code");
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur: $e")),
        );
      } finally {
        setState(() => loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mot de passe oublié")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text("Entrez votre email", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            const SizedBox(height: 20),

            TextFormField(
              decoration: const InputDecoration(
                labelText: "Email",
                hintText: "Entrer votre adresse email",
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (val) => val == null || val.isEmpty ? "Email requis" : null,
              onSaved: (val) => email = val!,
            ),

            const SizedBox(height: 20),

            loading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _sendResetCode,
                    child: const Text("Envoyer le code"),
                  ),
          ]),
        ),
      ),
    );
  }
}