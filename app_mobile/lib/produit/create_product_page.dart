import 'package:flutter/material.dart';
import 'product_service.dart';
import '../inventory_service.dart';

class CreateProductPage extends StatefulWidget {
  const CreateProductPage({super.key});

  @override
  State<CreateProductPage> createState() => _CreateProductPageState();
}

class _CreateProductPageState extends State<CreateProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _prixAchatController = TextEditingController();
  final _prixVenteController = TextEditingController();
  final _stockController = TextEditingController();
  final _seuilController = TextEditingController();

  String? categorieId;
  String? fournisseurId;
  bool loading = false;

  List<Map<String, dynamic>> categories = [];
  List<Map<String, dynamic>> fournisseurs = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final categoriesData = await InventoryService.getCategories();
      final fournisseursData = await InventoryService.getFournisseurs();
      setState(() {
        categories = List<Map<String, dynamic>>.from(categoriesData);
        fournisseurs = List<Map<String, dynamic>>.from(fournisseursData);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur: $e")),
      );
    }
  }

  Future<void> _createProduct() async {
    if (_formKey.currentState!.validate()) {
      setState(() => loading = true);
      try {
        await ProductService.createProduct(
          nom: _nomController.text,
          description: _descriptionController.text,
          prixAchat: double.parse(_prixAchatController.text),
          prixVente: double.parse(_prixVenteController.text),
          stock: int.parse(_stockController.text),
          seuilAlerte: int.parse(_seuilController.text),
          categorieId: int.parse(categorieId!),
          fournisseurId: int.parse(fournisseurId!),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Produit créé avec succès")),
        );
        Navigator.pop(context);
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
      appBar: AppBar(title: const Text("Créer un produit")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomController,
                decoration: const InputDecoration(labelText: "Nom"),
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
                validator: (val) => val == null || val.isEmpty ? "Prix requis" : null,
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
                items: categories.map((c) {
                  return DropdownMenuItem(
                    value: c["id"].toString(),
                    child: Text(c["nom"]),
                  );
                }).toList(),
                onChanged: (val) => setState(() => categorieId = val),
                validator: (val) => val == null ? "Catégorie requise" : null,
              ),

              DropdownButtonFormField(
                initialValue: fournisseurId,
                decoration: const InputDecoration(labelText: "Fournisseur"),
                items: fournisseurs.map((f) {
                  return DropdownMenuItem(
                    value: f["id"].toString(),
                    child: Text(f["nom"]),
                  );
                }).toList(),
                onChanged: (val) => setState(() => fournisseurId = val),
                validator: (val) => val == null ? "Fournisseur requis" : null,
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: loading ? null : _createProduct,
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Créer"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}