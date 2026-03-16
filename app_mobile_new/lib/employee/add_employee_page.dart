import 'package:flutter/material.dart';
import 'employee_service.dart';

class AddEmployeePage extends StatefulWidget {
  const AddEmployeePage({super.key});

  @override
  State<AddEmployeePage> createState() => _AddEmployeePageState();
}

class _AddEmployeePageState extends State<AddEmployeePage> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _showPassword = false;
  bool _showConfirm = false;
  int _strength = 0;
  String _role = "admin";
  String _statut = "1";
  bool loading = false;

  // Vérification email
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return "Email requis";
    final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!regex.hasMatch(value)) return "Email invalide";
    return null;
  }

  // Vérification force mot de passe
  void _checkPasswordStrength(String value) {
    int strength = 0;
    if (value.length >= 8) strength++;
    if (RegExp(r'[A-Z]').hasMatch(value)) strength++;
    if (RegExp(r'[a-z]').hasMatch(value)) strength++;
    if (RegExp(r'\d').hasMatch(value)) strength++;
    if (RegExp(r'[@$!%*?&]').hasMatch(value)) strength++;
    setState(() => _strength = strength);
  }

  // Vérification confirmation
  String? _validateConfirm(String? value) {
    if (value != _passwordController.text) return "Les mots de passe ne correspondent pas";
    return null;
  }

  Future<void> _createEmployee() async {
    if (_formKey.currentState!.validate()) {
      setState(() => loading = true);
      try {
        await EmployeeService.createEmployee(
          nom: _nomController.text,
          email: _emailController.text,
          password: _passwordController.text,
          role: _role,
          statut: _statut,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Employé créé avec succès")),
        );
        Navigator.pop(context); // retour à la liste
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
      appBar: AppBar(title: const Text("Ajouter un employé")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(children: [
            TextFormField(
              controller: _nomController,
              decoration: const InputDecoration(labelText: "Nom"),
              validator: (val) => val == null || val.isEmpty ? "Nom requis" : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
              validator: _validateEmail,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _passwordController,
              obscureText: !_showPassword,
              decoration: InputDecoration(
                labelText: "Mot de passe",
                suffixIcon: IconButton(
                  icon: Icon(_showPassword ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _showPassword = !_showPassword),
                ),
              ),
              onChanged: _checkPasswordStrength,
              validator: (val) => val == null || val.isEmpty ? "Mot de passe requis" : null,
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: _strength / 5,
              color: _strength <= 2 ? Colors.red : _strength == 3 ? Colors.orange : Colors.green,
              backgroundColor: Colors.grey[300],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _confirmController,
              obscureText: !_showConfirm,
              decoration: InputDecoration(
                labelText: "Confirmer le mot de passe",
                suffixIcon: IconButton(
                  icon: Icon(_showConfirm ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _showConfirm = !_showConfirm),
                ),
              ),
              validator: _validateConfirm,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField(
              initialValue: _role,
              items: const [
                DropdownMenuItem(value: "admin", child: Text("Admin")),
                DropdownMenuItem(value: "gerant", child: Text("Gérant")),
                DropdownMenuItem(value: "caissier", child: Text("Caissier")),
              ],
              onChanged: (val) => setState(() => _role = val!),
              decoration: const InputDecoration(labelText: "Rôle"),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField(
              initialValue: _statut,
              items: const [
                DropdownMenuItem(value: "1", child: Text("Actif")),
                DropdownMenuItem(value: "0", child: Text("En congé")),
              ],
              onChanged: (val) => setState(() => _statut = val!),
              decoration: const InputDecoration(labelText: "Statut"),
            ),
            const SizedBox(height: 20),
            Row(children: [
              ElevatedButton(
                onPressed: loading ? null : _createEmployee,
                child: loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text("Créer"),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Annuler"),
              ),
            ]),
          ]),
        ),
      ),
    );
  }
}