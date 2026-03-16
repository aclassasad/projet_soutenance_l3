import 'package:flutter/material.dart';
import 'auth_service.dart'; // Vérifie que le chemin est correct

class VerifyCodePage extends StatefulWidget {
  const VerifyCodePage({super.key});

  @override
  State<VerifyCodePage> createState() => _VerifyCodePageState();
}

class _VerifyCodePageState extends State<VerifyCodePage> {
  final _formKey = GlobalKey<FormState>();
  String code = "";
  String password = "";
  String confirmPassword = "";
  double strength = 0.0;
  String strengthLabel = "Faible";
  bool loading = false;

  void checkStrength(String value) {
    int score = 0;
    if (value.length >= 8) score++;
    if (RegExp(r'[A-Z]').hasMatch(value)) score++;
    if (RegExp(r'\d').hasMatch(value)) score++;
    if (RegExp(r'[^A-Za-z0-9]').hasMatch(value)) score++;

    setState(() {
      strength = score / 4;
      switch (score) {
        case 0:
        case 1:
          strengthLabel = "Faible";
          break;
        case 2:
          strengthLabel = "Moyen";
          break;
        case 3:
          strengthLabel = "Bon";
          break;
        case 4:
          strengthLabel = "Fort";
          break;
      }
    });
  }

  Future<void> _verifyCode() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => loading = true);

      try {
        final data = await AuthService.verifyResetCode(code, password);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"] ?? "Mot de passe changé avec succès")),
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
      appBar: AppBar(title: const Text("Vérification du code")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(children: [
            const Text(
              "Entrez le code reçu et votre nouveau mot de passe",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            TextFormField(
              decoration: const InputDecoration(
                labelText: "Code à 6 chiffres",
              ),
              keyboardType: TextInputType.number,
              validator: (val) => val == null || val.isEmpty ? "Code requis" : null,
              onSaved: (val) => code = val!,
            ),

            const SizedBox(height: 16),

            TextFormField(
              decoration: const InputDecoration(
                labelText: "Nouveau mot de passe",
              ),
              obscureText: true,
              onChanged: (val) {
                password = val;
                checkStrength(val);
              },
              validator: (val) => val == null || val.isEmpty ? "Mot de passe requis" : null,
            ),

            const SizedBox(height: 8),
            Text("Force du mot de passe : $strengthLabel"),
            LinearProgressIndicator(value: strength, minHeight: 8),

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
                    onPressed: _verifyCode,
                    child: const Text("Changer le mot de passe"),
                  ),
          ]),
        ),
      ),
    );
  }
}