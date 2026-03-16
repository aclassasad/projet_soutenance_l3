import 'package:flutter/material.dart';
import 'inventory_service.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  Map<String, dynamic>? stats;
  List<Map<String, dynamic>> produits = [];
  List<Map<String, dynamic>> categories = [];
  bool loading = true;

  // 🔹 variables pour recherche + filtre
  String searchText = "";
  int? selectedCategory;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      final statsData = await InventoryService.getInventoryStats();
      final categoriesData = await InventoryService.getCategories();
      final produitsData = await InventoryService.searchProduits();

      setState(() {
        stats = statsData;
        categories = categoriesData;
        produits = produitsData;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur: $e")),
      );
    }
  }

  Future<void> _loadInventory({String search = "", int? categorieId}) async {
    try {
      final produitsData = await InventoryService.searchProduits(
        search: search,
        categorieId: categorieId,
      );

      setState(() {
        produits = produitsData;
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
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Inventory Management")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text("Inventory Management",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const Text("Manage your store's product inventory",
              style: TextStyle(color: Colors.grey)),

          const SizedBox(height: 20),

          // ✅ Metrics Cards avec scroll horizontal
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: [
              _metricCard("Total Products", stats!['total_produits'], Colors.blue, Icons.inventory),
              const SizedBox(width: 12),
              _metricCard("Low Stock Items", stats!['low_stock'], Colors.orange, Icons.warning),
              const SizedBox(width: 12),
              _metricCard("Out of Stock", stats!['out_of_stock'], Colors.red, Icons.cancel),
              const SizedBox(width: 12),
              _metricCard(
                "Total Value",
                "\$${(double.tryParse(stats?['valeur_totale']?.toString() ?? '0') ?? 0.0).toStringAsFixed(2)}",
                Colors.green,
                Icons.attach_money,
              ),
            ]),
          ),

          const SizedBox(height: 20),

          // 🔹 Search + Filter + Dropdown
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
              child: Row(children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: "Search by product name...",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) {
                      searchText = val;
                      _loadInventory(search: searchText, categorieId: selectedCategory);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                DropdownButton<int>(
                  hint: const Text("All Categories"),
                  value: selectedCategory,
                  items: categories.map((c) => DropdownMenuItem<int>(
                    value: c['id'],
                    child: Text(c['nom']),
                  )).toList(),
                  onChanged: (val) {
                    selectedCategory = val;
                    _loadInventory(search: searchText, categorieId: selectedCategory);
                  },
                ),
              ]),
            ),
            DropdownButton<String>(
              hint: const Text("Mon gestionnaire"),
              items: const [
                DropdownMenuItem(value: "produits", child: Text("Produits")),
                DropdownMenuItem(value: "categories", child: Text("Catégories")),
                DropdownMenuItem(value: "fournisseurs", child: Text("Fournisseurs")),
              ],
              onChanged: (val) {
                if (val != null) Navigator.pushNamed(context, "/$val");
              },
            ),
          ]),

          const SizedBox(height: 20),

          // 🔹 Product Table
          Card(
            child: Column(
              children: produits.map((p) => ListTile(
                leading: Text(p['id']?.toString() ?? "N/A"),
                title: Text(p['nom']?.toString() ?? "Sans nom"),
                subtitle: Text(
                  "Catégorie: ${p['categorie']?['nom'] ?? 'N/A'} • "
                  "Stock: ${p['stock']?.toString() ?? '0'} • "
                  "Prix: \$${p['prix_vente']?.toString() ?? '0'}"
                ),
                trailing: PopupMenuButton<String>(
                  onSelected: (val) async {
                    if (val == "edit") {
                      Navigator.pushNamed(context, "/produits/edit", arguments: p);
                    } else if (val == "delete") {
                      await InventoryService.deleteProduit(p['id']);
                      setState(() {
                        produits.removeWhere((prod) => prod['id'] == p['id']);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Produit ${p['nom'] ?? "Sans nom"} supprimé")),
                      );
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: "edit", child: Text("Edit")),
                    PopupMenuItem(value: "delete", child: Text("Delete")),
                  ],
                ),
              )).toList(),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _metricCard(String title, dynamic value, Color color, IconData icon) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(color: Colors.grey)),
            Text("$value", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ]),
          CircleAvatar(backgroundColor: color.withOpacity(0.1), child: Icon(icon, color: color)),
        ]),
      ),
    );
  }
}