import 'package:flutter/material.dart';
import 'categorie_service.dart';

class CreateCategoryPage extends StatefulWidget {
  const CreateCategoryPage({super.key});

  @override
  State<CreateCategoryPage> createState() => _CreateCategoryPageState();
}

class _CreateCategoryPageState extends State<CreateCategoryPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool loading = false;

  Future<void> _createCategory() async {
    if (_formKey.currentState!.validate()) {
      setState(() => loading = true);
      try {
        final newCategorie = await CategorieService.createCategorie(
          _nomController.text,
          _descriptionController.text,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Catégorie créée avec succès")),
        );

        // ✅ renvoie la catégorie créée à la page précédente
        Navigator.pop(context, newCategorie);
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
      appBar: AppBar(title: const Text("Nouvelle Catégorie")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(children: [
            TextFormField(
              controller: _nomController,
              decoration: const InputDecoration(labelText: "Nom de la catégorie"),
              validator: (val) =>
                  val == null || val.isEmpty ? "Nom requis" : null,
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: "Description"),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            Row(children: [
              ElevatedButton(
                onPressed: loading ? null : _createCategory,
                child: loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
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