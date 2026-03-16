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
  int rowsPerPage = PaginatedDataTable.defaultRowsPerPage;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

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
        SnackBar(content: Text("Erreur lors du chargement: $e")),
      );
    }
  }

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

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Liste des Catégories")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
OutlinedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, "/inventory");
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text("Retour"),
              ),
const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () async {
                  final created = await Navigator.pushNamed(context, "/categories/create");
                  if (created != null && created is Map<String, dynamic>) {
                    setState(() {
                      categories.add(created);
                    });
                  }
                },
                
                icon: const Icon(Icons.add),
                label: const Text("Nouveau"),
              ),
              
              
            ]),

            const SizedBox(height: 20),

            Expanded(
              child: categories.isEmpty
                  ? const Center(child: Text("Aucune catégorie trouvée"))
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        final availableHeight = constraints.maxHeight;
                        final calculatedRows = (availableHeight ~/ 80).clamp(5, 20);
                        rowsPerPage = calculatedRows;

                        return PaginatedDataTable(
                          header: const Text("Catégories"),
                          rowsPerPage: rowsPerPage,
                          columns: const [
                            DataColumn(label: Text("ID")),
                            DataColumn(label: Text("Nom")),
                            DataColumn(label: Text("Actions")),
                          ],
                          source: _CategoryDataSource(
                            context: context,
                            categories: categories,
                            onDelete: _deleteCategory,
                            onUpdate: (updated) {
                              setState(() {
                                final index = categories.indexWhere((item) => item["id"] == updated["id"]);
                                if (index != -1) {
                                  categories[index] = updated;
                                }
                              });
                            },
                          ),
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
class _CategoryDataSource extends DataTableSource {
  final BuildContext context;
  final List<Map<String, dynamic>> categories;
  final Function(int id, String name) onDelete;
  final Function(Map<String, dynamic> updated) onUpdate;

  _CategoryDataSource({
    required this.context,
    required this.categories,
    required this.onDelete,
    required this.onUpdate,
  });

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
            if (updated != null && updated is Map<String, dynamic>) {
              onUpdate(updated);
            }
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
            if (updated != null && updated is Map<String, dynamic>) {
              onUpdate(updated);
            }
          },
          icon: const Icon(Icons.edit, color: Colors.orange),
        ),
       IconButton(
  onPressed: () async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Supprimer la catégorie"),
        content: Text("Voulez-vous vraiment supprimer ${cat['nom']} ?"),
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
      onDelete(cat["id"], cat["nom"]);
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
  int get rowCount => categories.length;
  @override
  int get selectedRowCount => 0;
}