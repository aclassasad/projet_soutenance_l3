import 'package:flutter/material.dart';
import 'product_service.dart';

class EditProductPage extends StatefulWidget {
  final Map<String, dynamic> produit;
  final List<Map<String, dynamic>> categories;
  final List<Map<String, dynamic>> fournisseurs;

  const EditProductPage({
    required this.produit,
    required this.categories,
    required this.fournisseurs,
    super.key,
  });

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomController;
  late TextEditingController _descriptionController;
  late TextEditingController _prixAchatController;
  late TextEditingController _prixVenteController;
  late TextEditingController _stockController;
  late TextEditingController _seuilController;

  String? categorieId;
  String? fournisseurId;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _nomController = TextEditingController(text: widget.produit["nom"]);
    _descriptionController = TextEditingController(text: widget.produit["description"]);
    _prixAchatController = TextEditingController(text: widget.produit["prix_achat"].toString());
    _prixVenteController = TextEditingController(text: widget.produit["prix_vente"].toString());
    _stockController = TextEditingController(text: widget.produit["stock"].toString());
    _seuilController = TextEditingController(text: widget.produit["seuil_alerte"].toString());

    categorieId = widget.produit["categorie_id"].toString();
    fournisseurId = widget.produit["fournisseur_id"].toString();
  }

  Future<void> _updateProduct() async {
    if (_formKey.currentState!.validate()) {
      setState(() => loading = true);
      try {
        final updatedProduct = await ProductService.updateProduct(
          id: widget.produit["id"],
          nom: _nomController.text,
          description: _descriptionController.text,
          prixAchat: double.parse(_prixAchatController.text),
          prixVente: double.parse(_prixVenteController.text),
          stock: int.parse(_stockController.text),
          seuilAlerte: int.parse(_seuilController.text),
          categorieId: categorieId!,
          fournisseurId: fournisseurId!,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Produit mis à jour avec succès")),
        );

        // ✅ renvoie le produit mis à jour à la page précédente
        Navigator.pop(context, updatedProduct);
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
      appBar: AppBar(title: const Text("Modifier Produit")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(children: [
            TextFormField(
              controller: _nomController,
              decoration: const InputDecoration(labelText: "Nom du produit"),
              validator: (val) => val == null || val.isEmpty ? "Nom requis" : null,
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: "Description"),
              maxLines: 3,
            ),
            TextFormField(
              controller: _prixAchatController,
              decoration: const InputDecoration(labelText: "Prix d'achat"),
              keyboardType: TextInputType.number,
              validator: (val) => val == null || val.isEmpty ? "Prix requis" : null,
            ),
            TextFormField(
              controller: _prixVenteController,
              decoration: const InputDecoration(labelText: "Prix de vente"),
              keyboardType: TextInputType.number,
              validator: (val) {
                if (val == null || val.isEmpty) return "Prix requis";
                final prixVente = double.tryParse(val) ?? 0;
                final prixAchat = double.tryParse(_prixAchatController.text) ?? 0;
                if (prixVente < prixAchat) {
                  return "Le prix de vente doit être supérieur ou égal au prix d'achat";
                }
                return null;
              },
            ),
            TextFormField(
              controller: _stockController,
              decoration: const InputDecoration(labelText: "Stock"),
              keyboardType: TextInputType.number,
              validator: (val) => val == null || val.isEmpty ? "Stock requis" : null,
            ),
            TextFormField(
              controller: _seuilController,
              decoration: const InputDecoration(labelText: "Seuil d'alerte"),
              keyboardType: TextInputType.number,
              validator: (val) => val == null || val.isEmpty ? "Seuil requis" : null,
            ),
            DropdownButtonFormField(
              initialValue: categorieId,
              decoration: const InputDecoration(labelText: "Catégorie"),
              items: widget.categories.map((c) {
                return DropdownMenuItem(value: c["id"].toString(), child: Text(c["nom"]));
              }).toList(),
              onChanged: (val) => setState(() => categorieId = val),
            ),
            DropdownButtonFormField(
              initialValue: fournisseurId,
              decoration: const InputDecoration(labelText: "Fournisseur"),
              items: widget.fournisseurs.map((f) {
                return DropdownMenuItem(value: f["id"].toString(), child: Text(f["nom"]));
              }).toList(),
              onChanged: (val) => setState(() => fournisseurId = val),
            ),
            const SizedBox(height: 20),
            Row(children: [
              ElevatedButton(
                onPressed: loading ? null : _updateProduct,
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