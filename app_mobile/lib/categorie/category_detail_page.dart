import 'package:flutter/material.dart';
import 'categorie_service.dart';

class CategoryDetailPage extends StatefulWidget {
  final Map<String, dynamic> categorie; // ✅ on attend un Map complet

  const CategoryDetailPage({required this.categorie, super.key});

  @override
  State<CategoryDetailPage> createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
  Map<String, dynamic>? categorie;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadCategorie();
  }

  Future<void> _loadCategorie() async {
    try {
      final data = await CategorieService.getCategorieDetail(widget.categorie["id"]);
      setState(() {
        categorie = data;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (categorie == null) {
      return const Scaffold(
        body: Center(child: Text("Catégorie introuvable")),
      );
    }

   final List<Map<String, dynamic>> produits =
    (categorie!["produits"] as List?)
        ?.map((p) => Map<String, dynamic>.from(p as Map))
        .toList() 
    ?? [];
    return Scaffold(
      appBar: AppBar(title: const Text("Détails Catégorie")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text("Détails de la Catégorie",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

          const SizedBox(height: 12),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(categorie!["nom"],
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(categorie!["description"] ?? ""),
                  ]),
            ),
          ),

          const SizedBox(height: 20),

          const Text("Produits associés",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

          const SizedBox(height: 8),

          Expanded(
            child: produits.isEmpty
                ? const Text("Aucun produit dans cette catégorie.")
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text("Nom")),
                        DataColumn(label: Text("Prix Vente")),
                        DataColumn(label: Text("Stock")),
                      ],
                      rows: produits.map((p) {
                        return DataRow(cells: [
                          DataCell(Text(p["nom"])),
                          DataCell(Text("${p["prix_vente"]}")),
                          DataCell(Text("${p["stock"]}")),
                        ]);
                      }).toList(),
                    ),
                  ),
          ),

          const SizedBox(height: 20),

          Row(children: [
            OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text("Retour"),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: () async {
                final updated = await Navigator.pushNamed(
                  context,
                  "/categories/edit",
                  arguments: categorie,
                );

                if (updated != null) {
                  setState(() {
                    categorie = updated as Map<String, dynamic>; // ✅ mise à jour locale
                  });
                }
              },
              icon: const Icon(Icons.edit),
              label: const Text("Modifier"),
            ),
          ]),
        ]),
      ),
    );
  }
}