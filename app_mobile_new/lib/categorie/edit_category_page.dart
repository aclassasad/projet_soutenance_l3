import 'package:flutter/material.dart';
import 'categorie_service.dart';

class EditCategoryPage extends StatefulWidget {
  final Map<String, dynamic> categorie;

  const EditCategoryPage({required this.categorie, super.key});

  @override
  State<EditCategoryPage> createState() => _EditCategoryPageState();
}

class _EditCategoryPageState extends State<EditCategoryPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomController;
  late TextEditingController _descriptionController;
  bool loading = false;

  @override
  void initState() {
    super.initState();
   _nomController = TextEditingController(text: widget.categorie["nom"] ?? "");
_descriptionController = TextEditingController(text: widget.categorie["description"] ?? "");}

  Future<void> _updateCategory() async {
    if (_formKey.currentState!.validate()) {
      setState(() => loading = true);
      try {
        final updatedCategorie = await CategorieService.updateCategorie(
          widget.categorie["id"],
          _nomController.text,
          _descriptionController.text,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Catégorie mise à jour avec succès")),
        );

        // ✅ renvoie la catégorie mise à jour à la page précédente
        Navigator.pop(context, updatedCategorie);
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
      appBar: AppBar(title: const Text("Modifier Catégorie")),
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
                onPressed: loading ? null : _updateCategory,
                child: loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
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