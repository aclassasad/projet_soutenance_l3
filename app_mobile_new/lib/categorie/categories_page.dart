import 'package:flutter/material.dart';
import 'categorie_service.dart';
import '../theme_provider.dart';

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
    // Écouter les changements de thème
    ThemeProvider.instance.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    ThemeProvider.instance.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() {
    if (mounted) {
      setState(() {});
    }
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erreur lors du chargement: $e"),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _deleteCategory(int id, String name) async {
    try {
      await CategorieService.deleteCategorie(id);
      setState(() {
        categories.removeWhere((cat) => cat['id'] == id);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Catégorie $name supprimée"),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erreur suppression: $e"),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ThemeProvider.instance.themeMode == 'dark';

    if (loading) {
      return Scaffold(
        backgroundColor: isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: Color(0xFF4361EE)),
              const SizedBox(height: 16),
              Text(
                "Chargement des catégories...",
                style: TextStyle(color: isDarkMode ? Colors.grey[400] : Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          "Liste des catégories",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_outlined, color: isDarkMode ? Colors.grey[400] : const Color(0xFF64748B)),
            onPressed: _loadCategories,
            tooltip: "Actualiser",
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête avec compteur
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Gestion des catégories",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${categories.length} catégorie(s) au total",
                          style: TextStyle(
                            fontSize: 13,
                            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(context, "/inventory");
                        },
                        icon: const Icon(Icons.arrow_back, size: 18),
                        label: const Text("Retour"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: isDarkMode ? Colors.grey[400] : const Color(0xFF64748B),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          side: BorderSide(
                            color: isDarkMode ? const Color(0xFF475569) : Colors.grey.shade300,
                          ),
                        ),
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
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text("Nouvelle catégorie"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4361EE),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Tableau paginé
            Expanded(
              child: categories.isEmpty
                  ? _buildEmptyState(isDarkMode)
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        final availableHeight = constraints.maxHeight;
                        final calculatedRows = (availableHeight ~/ 80).clamp(5, 20);
                        rowsPerPage = calculatedRows;

                        return PaginatedDataTable(
                          header: Text(
                            "Catalogue des catégories",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isDarkMode ? Colors.white : const Color(0xFF1E293B),
                            ),
                          ),
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
                            isDarkMode: isDarkMode,
                          ),
                          showCheckboxColumn: false,
                          headingRowColor: MaterialStateProperty.all(
                            isDarkMode ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
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

  Widget _buildEmptyState(bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.category_outlined,
              size: 48,
              color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Aucune catégorie trouvée",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isDarkMode ? Colors.white : const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Ajoutez votre première catégorie",
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? Colors.grey[500] : Colors.grey[500],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () async {
              final created = await Navigator.pushNamed(context, "/categories/create");
              if (created != null && created is Map<String, dynamic>) {
                setState(() {
                  categories.add(created);
                });
              }
            },
            icon: const Icon(Icons.add, size: 18),
            label: const Text("Créer une catégorie"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4361EE),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
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
  final bool isDarkMode;

  _CategoryDataSource({
    required this.context,
    required this.categories,
    required this.onDelete,
    required this.onUpdate,
    required this.isDarkMode,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= categories.length) return null;
    final cat = categories[index];

    return DataRow(
      cells: [
        DataCell(
          Text(
            "${cat['id']}",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: isDarkMode ? Colors.white : const Color(0xFF1E293B),
            ),
          ),
        ),
        DataCell(
          Text(
            cat['nom'] ?? "",
            style: TextStyle(
              color: isDarkMode ? Colors.white : const Color(0xFF1E293B),
            ),
          ),
        ),
        DataCell(
          Row(
            children: [
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
                icon: const Icon(Icons.visibility, color: Color(0xFF4361EE)),
                tooltip: "Voir les détails",
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
                icon: const Icon(Icons.edit, color: Color(0xFFF59E0B)),
                tooltip: "Modifier",
              ),
              IconButton(
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      backgroundColor: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
                      title: Text(
                        "Supprimer la catégorie",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : const Color(0xFF1E293B),
                        ),
                      ),
                      content: Text(
                        "Voulez-vous vraiment supprimer ${cat['nom']} ?",
                        style: TextStyle(
                          fontSize: 14,
                          color: isDarkMode ? Colors.grey[300] : Colors.black87,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                          child: Text(
                            "Annuler",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                          child: const Text("Supprimer", style: TextStyle(fontSize: 14)),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    onDelete(cat["id"], cat["nom"]);
                  }
                },
                icon: const Icon(Icons.delete, color: Colors.red),
                tooltip: "Supprimer",
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => categories.length;
  @override
  int get selectedRowCount => 0;
}