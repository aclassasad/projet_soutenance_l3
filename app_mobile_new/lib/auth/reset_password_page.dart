import 'package:flutter/material.dart';
import 'auth_service.dart'; // Vérifie que le chemin est correct

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String confirmPassword = "";
  bool loading = false;

  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => loading = true);

      try {
        final data = await AuthService.resetPassword(email, password);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"] ?? "Mot de passe réinitialisé avec succès")),
        );

        Navigator.pushNamed(context, "/login");
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
      appBar: AppBar(title: const Text("Réinitialiser le mot de passe")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(children: [
            const Text(
              "Entrez votre email et votre nouveau mot de passe",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

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

            const SizedBox(height: 16),

            TextFormField(
              decoration: const InputDecoration(
                labelText: "Nouveau mot de passe",
              ),
              obscureText: true,
              validator: (val) => val == null || val.isEmpty ? "Mot de passe requis" : null,
              onSaved: (val) => password = val!,
            ),

            const SizedBox(height: 16),

            TextFormField(
              decoration: const InputDecoration(
                labelText: "Confirmer le mot de passe",
              ),
              obscureText: true,
              validator: (val) {
                if (val == null || val.isEmpty) return "Confirmation requise";
                if (val != password) return "Les mots de passe ne correspondent pas";
                return null;
              },
              onSaved: (val) => confirmPassword = val!,
            ),

            const SizedBox(height: 20),

            loading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _resetPassword,
                    child: const Text("Réinitialiser"),
                  ),
          ]),
        ),
      ),
    );
  }
}