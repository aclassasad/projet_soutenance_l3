import 'package:flutter/material.dart';
import 'fournisseur_service.dart';

class EditFournisseurPage extends StatefulWidget {
  final Map<String, dynamic> fournisseur;

  const EditFournisseurPage({required this.fournisseur, super.key});

  @override
  State<EditFournisseurPage> createState() => _EditFournisseurPageState();
}

class _EditFournisseurPageState extends State<EditFournisseurPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomController;
  late TextEditingController _emailController;
  late TextEditingController _telephoneController;
  late TextEditingController _adresseController;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _nomController = TextEditingController(text: widget.fournisseur["nom"]);
    _emailController = TextEditingController(text: widget.fournisseur["email"]);
    _telephoneController = TextEditingController(text: widget.fournisseur["telephone"]);
    _adresseController = TextEditingController(text: widget.fournisseur["adresse"]);
  }

  Future<void> _updateFournisseur() async {
    if (_formKey.currentState!.validate()) {
      setState(() => loading = true);
      try {
        await FournisseurService.updateFournisseur(
          id: widget.fournisseur["id"],
          nom: _nomController.text,
          email: _emailController.text,
          telephone: _telephoneController.text,
          adresse: _adresseController.text,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Fournisseur mis à jour avec succès")),
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
      appBar: AppBar(title: const Text("Modifier Fournisseur")),
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
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
              keyboardType: TextInputType.emailAddress,
            ),
            TextFormField(
              controller: _telephoneController,
              decoration: const InputDecoration(labelText: "Téléphone"),
              keyboardType: TextInputType.phone,
            ),
            TextFormField(
              controller: _adresseController,
              decoration: const InputDecoration(labelText: "Adresse"),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            Row(children: [
              ElevatedButton(
                onPressed: loading ? null : _updateFournisseur,
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