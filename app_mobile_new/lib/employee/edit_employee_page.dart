import 'package:flutter/material.dart';
import 'employee_service.dart';

class EditEmployeePage extends StatefulWidget {
  final Map<String, dynamic> user;

  const EditEmployeePage({required this.user, super.key});

  @override
  State<EditEmployeePage> createState() => _EditEmployeePageState();
}

class _EditEmployeePageState extends State<EditEmployeePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  String _role = "admin";
  String _statut = "1";
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user["name"]);
    _emailController = TextEditingController(text: widget.user["email"]);
    _role = widget.user["role"] ?? "admin";
    _statut = widget.user["statut"]?.toString() ?? "1";
  }

  Future<void> _updateEmployee() async {
    if (_formKey.currentState!.validate()) {
      setState(() => loading = true);
      try {
        await EmployeeService.updateEmployee(
          id: widget.user["id"],
          nom: _nameController.text,
          email: _emailController.text,
          role: _role,
          statut: _statut,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Employé mis à jour avec succès")),
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
      appBar: AppBar(title: const Text("Modifier Employé")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Nom"),
              validator: (val) => val == null || val.isEmpty ? "Nom requis" : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
              validator: (val) {
                if (val == null || val.isEmpty) return "Email requis";
                final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                if (!regex.hasMatch(val)) return "Email invalide";
                return null;
              },
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
                onPressed: loading ? null : _updateEmployee,
                child: loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text("Mettre à jour"),
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