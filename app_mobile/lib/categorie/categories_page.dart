import 'package:flutter/material.dart';
import 'categorie_service.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  List<Map<String, dynamic>> categories = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  // 🔹 Charger les catégories depuis l’API
  Future<void> _loadCategories() async {
    try {
      final data = await CategorieService.getCategories();
      setState(() {
        categories = List<Map<String, dynamic>>.from(data);
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur: $e")),
      );
    }
  }

  // 🔹 Supprimer une catégorie
  Future<void> _deleteCategory(int id, String name) async {
    try {
      await CategorieService.deleteCategorie(id);
      setState(() {
        categories.removeWhere((cat) => cat['id'] == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Catégorie $name supprimée")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur suppression: $e")),
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
      appBar: AppBar(title: const Text("Liste des Catégories")),
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
                  final created = await Navigator.pushNamed(
                    context,
                    "/categories/create",
                  );
                  if (created != null) {
                    _loadCategories(); // ✅ recharge après création
                  }
                },
                icon: const Icon(Icons.add),
                label: const Text("Nouvelle Catégorie"),
              ),
            ]),

            const SizedBox(height: 20),

            // 🔹 Tableau paginé
            Expanded(
              child: categories.isEmpty
                  ? const Center(child: Text("Aucune catégorie trouvée"))
                  : PaginatedDataTable(
                      header: const Text("Catégories"),
                      columns: const [
                        DataColumn(label: Text("ID")),
                        DataColumn(label: Text("Nom")),
                        DataColumn(label: Text("Actions")),
                      ],
                      source: _CategoryDataSource(
                        categories,
                        _deleteCategory,
                        context,
                        _loadCategories,
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
class _CategoryDataSource extends DataTableSource {
  final List<Map<String, dynamic>> categories;
  final Function(int, String) onDelete;
  final BuildContext context;
  final Function reload;

  _CategoryDataSource(
    this.categories,
    this.onDelete,
    this.context,
    this.reload,
  );

  @override
  DataRow? getRow(int index) {
    if (index >= categories.length) return null;
    final cat = categories[index];
    return DataRow(cells: [
      DataCell(Text("${cat['id']}")),
      DataCell(Text(cat['nom'] ?? "")),
      DataCell(Row(children: [
        IconButton(
          onPressed: () async {
            final updated = await Navigator.pushNamed(
              context,
              "/categories/detail",
              arguments: cat,
            );
            if (updated != null) reload();
          },
          icon: const Icon(Icons.visibility, color: Colors.blue),
        ),
        IconButton(
          onPressed: () async {
            final updated = await Navigator.pushNamed(
              context,
              "/categories/edit",
              arguments: cat,
            );
            if (updated != null) reload();
          },
          icon: const Icon(Icons.edit, color: Colors.orange),
        ),
        IconButton(
          onPressed: () {
            onDelete(cat['id'], cat['nom']);
          },
          icon: const Icon(Icons.delete, color: Colors.red),
        ),
      ])),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => categories.length;
  @override
  int get selectedRowCount => 0;
}