import 'package:flutter/material.dart';
import 'fournisseur_service.dart';

class CreateFournisseurPage extends StatefulWidget {
  const CreateFournisseurPage({super.key});

  @override
  State<CreateFournisseurPage> createState() => _CreateFournisseurPageState();
}

class _CreateFournisseurPageState extends State<CreateFournisseurPage> {
  final _formKey = GlobalKey<FormState>();
  String nom = "";
  String email = "";
  String telephone = "";
  String adresse = "";
  bool loading = false;

  Future<void> _saveFournisseur() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => loading = true);

      try {
        await FournisseurService.createFournisseur(
          nom: nom,
          email: email,
          telephone: telephone,
          adresse: adresse,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Fournisseur enregistré avec succès")),
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
      appBar: AppBar(title: const Text("Nouveau Fournisseur")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(children: [
            TextFormField(
              decoration: const InputDecoration(labelText: "Nom"),
              validator: (val) => val == null || val.isEmpty ? "Nom requis" : null,
              onSaved: (val) => nom = val!,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: "Email"),
              keyboardType: TextInputType.emailAddress,
              onSaved: (val) => email = val ?? "",
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: "Téléphone"),
              keyboardType: TextInputType.phone,
              onSaved: (val) => telephone = val ?? "",
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: "Adresse"),
              maxLines: 3,
              onSaved: (val) => adresse = val ?? "",
            ),
            const SizedBox(height: 20),
            Row(children: [
              ElevatedButton(
                onPressed: loading ? null : _saveFournisseur,
                child: loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text("Enregistrer"),
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