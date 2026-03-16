import 'package:flutter/material.dart';
import 'product_service.dart';
import '../inventory_service.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  List<Map<String, dynamic>> produits = [];
  List<Map<String, dynamic>> categories = [];
  List<Map<String, dynamic>> fournisseurs = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // 🔹 Charger les données depuis l’API
  Future<void> _loadData() async {
    try {
      final produitsData = await ProductService.getProducts();
      final categoriesData = await InventoryService.getCategories();
      final fournisseursData = await InventoryService.getFournisseurs();

      setState(() {
        produits = List<Map<String, dynamic>>.from(produitsData);
        categories = List<Map<String, dynamic>>.from(categoriesData);
        fournisseurs = List<Map<String, dynamic>>.from(fournisseursData);
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur: $e")),
      );
    }
  }

  // 🔹 Supprimer un produit
  Future<void> _deleteProduct(int id, String nom) async {
    try {
      await ProductService.deleteProduct(id);
      setState(() {
        produits.removeWhere((p) => p["id"] == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Produit $nom supprimé")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur: $e")),
      );
    }
  }

  // 🔹 Calcul dynamique du nombre de lignes par page
  int _calculateRowsPerPage(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    // On estime ~70 pixels par ligne + réserve ~200 pixels pour AppBar/boutons
    final availableHeight = screenHeight - 200;
    return (availableHeight ~/ 70).clamp(5, 20); 
    // min 5 lignes, max 20
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Liste des Produits")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Boutons d’action (retour + création)
            Row(children: [
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, "/inventory");
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text("Retour à l’inventaire"),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () async {
                  await Navigator.pushNamed(context, "/produits/create");
                  _loadData(); // ✅ recharge après création
                },
                icon: const Icon(Icons.add),
                label: const Text("Nouveau Produit"),
              ),
            ]),

            const SizedBox(height: 20),

            // 🔹 Tableau paginé
            Expanded(
              child: produits.isEmpty
                  ? const Center(
                      child: Text("Aucun produit trouvé",
                          style: TextStyle(color: Colors.grey)))
                  : PaginatedDataTable(
                      header: const Text("Produits"),
                      columns: const [
                        DataColumn(label: Text("ID")),
                        DataColumn(label: Text("Nom")),
                        DataColumn(label: Text("Actions")),
                      ],
                      source: _ProductDataSource(
                        produits,
                        categories,
                        fournisseurs,
                        _deleteProduct,
                        context,
                        _loadData,
                      ),
                      rowsPerPage: _calculateRowsPerPage(context), // ✅ dynamique
                      showCheckboxColumn: false,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// 🔹 DataSource pour PaginatedDataTable
class _ProductDataSource extends DataTableSource {
  final List<Map<String, dynamic>> produits;
  final List<Map<String, dynamic>> categories;
  final List<Map<String, dynamic>> fournisseurs;
  final Function(int, String) onDelete;
  final BuildContext context;
  final Function reload;

  _ProductDataSource(
    this.produits,
    this.categories,
    this.fournisseurs,
    this.onDelete,
    this.context,
    this.reload,
  );

  @override
  DataRow? getRow(int index) {
    if (index >= produits.length) return null;
    final p = produits[index];
    return DataRow(cells: [
      DataCell(Text("${p['id']}")),
      DataCell(Text(p['nom'] ?? "Sans nom")),
      DataCell(Row(children: [
        IconButton(
          onPressed: () {
            Navigator.pushNamed(
              context,
              "/produits/detail",
              arguments: {
                "produit": p,
                "categories": categories,
                "fournisseurs": fournisseurs,
              },
            );
          },
          icon: const Icon(Icons.visibility, color: Colors.blue),
        ),
        IconButton(
          onPressed: () async {
            await Navigator.pushNamed(
              context,
              "/produits/edit",
              arguments: {
                "produit": p,
                "categories": categories,
                "fournisseurs": fournisseurs,
              },
            );
            reload(); // ✅ recharge après édition
          },
          icon: const Icon(Icons.edit, color: Colors.orange),
        ),
        IconButton(
          onPressed: () {
            onDelete(p["id"], p["nom"]);
          },
          icon: const Icon(Icons.delete, color: Colors.red),
        ),
      ])),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => produits.length;
  @override
  int get selectedRowCount => 0;
}