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
  int rowsPerPage = PaginatedDataTable.defaultRowsPerPage;

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
            // 🔹 Boutons d’action
            Row(children: [
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, "/inventory");
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text("Retour "),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () async {
                  await Navigator.pushNamed(context, "/produits/create");
                  _loadData(); // ✅ recharge après création
                },
                icon: const Icon(Icons.add),
                label: const Text("Nouveau"),
              ),
            ]),

            const SizedBox(height: 20),

            // 🔹 Tableau paginé
            Expanded(
              child: produits.isEmpty
                  ? const Center(child: Text("Aucun produit trouvé"))
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        final availableHeight = constraints.maxHeight;
                        final calculatedRows = (availableHeight ~/ 80).clamp(5, 20);
                        rowsPerPage = calculatedRows;

                        return PaginatedDataTable(
                          header: const Text("Produits"),
                          rowsPerPage: rowsPerPage,
                          columns: const [
                            DataColumn(label: Text("ID")),
                            DataColumn(label: Text("Nom")),
                            DataColumn(label: Text("Actions")),
                          ],
                          source: _ProductDataSource(
                            context: context,
                            produits: produits,
                            categories: categories,
                            fournisseurs: fournisseurs,
                            onDelete: _deleteProduct,
                            reload: _loadData,
                          ),
                          showCheckboxColumn: false,
                        );
                      },
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
  final BuildContext context;
  final List<Map<String, dynamic>> produits;
  final List<Map<String, dynamic>> categories;
  final List<Map<String, dynamic>> fournisseurs;
  final Function(int, String) onDelete;
  final Function reload;

  _ProductDataSource({
    required this.context,
    required this.produits,
    required this.categories,
    required this.fournisseurs,
    required this.onDelete,
    required this.reload,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= produits.length) return null;
    final p = produits[index];

    return DataRow(cells: [
      DataCell(Text("${p['id']}")),
      DataCell(Text(p['nom'] ?? "Sans nom")),
      DataCell(Row(children: [
        IconButton(
          onPressed: () async {
            final updated = await Navigator.pushNamed(
              context,
              "/produits/detail",
              arguments: {
                "produit": p,
                "categories": categories,
                "fournisseurs": fournisseurs,
              },
            );
            if (updated != null) reload(); // ✅ recharge après retour
          },
          icon: const Icon(Icons.visibility, color: Colors.blue),
        ),
        IconButton(
          onPressed: () async {
            final updated = await Navigator.pushNamed(
              context,
              "/produits/edit",
              arguments: {
                "produit": p,
                "categories": categories,
                "fournisseurs": fournisseurs,
              },
            );
            if (updated != null) reload(); // ✅ recharge après édition
          },
          icon: const Icon(Icons.edit, color: Colors.orange),
        ),
        IconButton(
  onPressed: () async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Supprimer le produit"),
        content: Text("Voulez-vous vraiment supprimer ${p['nom']} ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Supprimer"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      onDelete(p["id"], p["nom"]);
    }
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