import 'package:flutter/material.dart';
import 'auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool loading = false;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => loading = true);

      try {
        final data = await AuthService.login(email, password);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"] ?? "Connexion réussie")),
        );

        // ✅ Le token est déjà stocké dans AuthService.login
        Navigator.pushNamed(context, "/dashboard");
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
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image.asset("assets/images/logo.jpeg", height: 80),

              const SizedBox(height: 20),

              const Text("CONNEXION", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text(
                "Veuillez entrer vos identifiants afin d’accéder à votre dashboard.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 20),

              Form(
                key: _formKey,
                child: Column(children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Email", hintText: "Entrer votre adresse email"),
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) => val == null || val.isEmpty ? "Email requis" : null,
                    onSaved: (val) => email = val!,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Mot de passe", hintText: "Entrer votre mot de passe"),
                    obscureText: true,
                    validator: (val) => val == null || val.isEmpty ? "Mot de passe requis" : null,
                    onSaved: (val) => password = val!,
                  ),
                  const SizedBox(height: 12),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/password-reset");
                      },
                      child: const Text("Mot de passe oublié ?"),
                    ),
                  ),

                  const SizedBox(height: 20),

                  loading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _login,
                          child: const Text("Connexion"),
                        ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}