import 'package:flutter/material.dart';

class ProductDetailPage extends StatelessWidget {
  final Map<String, dynamic> produit;
   final List<Map<String, dynamic>> categories;
  final List<Map<String, dynamic>> fournisseurs;


  const ProductDetailPage({
    required this.produit,
    required this.categories,
    required this.fournisseurs,
 
    super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Détails Produit")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text(
            "Détails du Produit",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  produit["nom"] ?? "Sans nom",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(produit["description"] ?? ""),
                const Divider(),
                ListTile(
                  title: const Text("Prix d'achat"),
                  trailing: Text("${produit["prix_achat"]} FCFA"),
                ),
                ListTile(
                  title: const Text("Prix de vente"),
                  trailing: Text("${produit["prix_vente"]} FCFA"),
                ),
                ListTile(
                  title: const Text("Stock"),
                  trailing: Text("${produit["stock"]}"),
                ),
                ListTile(
                  title: const Text("Seuil alerte"),
                  trailing: Text("${produit["seuil_alerte"]}"),
                ),
                ListTile(
                  title: const Text("Catégorie"),
                  trailing: Text(produit["categorie"]?["nom"] ?? "N/A"), // ✅ correction
                ),
                ListTile(
                  title: const Text("Fournisseur"),
                  trailing: Text(produit["fournisseur"]?["nom"] ?? "N/A"), // ✅ correction
                ),
              ]),
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
      "/produits/edit",
      arguments: {
        "produit": produit,
        "categories": categories,
        "fournisseurs": fournisseurs,
      },
    );

    if (updated != null) {
      // ⚠️ Ici tu peux recharger depuis l’API
      Navigator.pushReplacementNamed(
        context,
        "/produits/detail",
        arguments: {
          "produit": updated,
          "categories": categories,
          "fournisseurs": fournisseurs,
        },
      );
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