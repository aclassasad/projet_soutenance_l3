import 'package:flutter/material.dart';
import 'product_service.dart';
import '../inventory_service.dart';
import '../theme_provider.dart';

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

  // 🔹 Charger les données depuis l'API
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
        SnackBar(
          content: Text("Erreur: $e"),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: Colors.red,
        ),
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Produit $nom supprimé"),
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
            content: Text("Erreur: $e"),
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
                "Chargement des produits...",
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
          "Liste des produits",
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
            onPressed: _loadData,
            tooltip: "Actualiser",
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête avec icône
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
                          "Gestion des produits",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${produits.length} produit(s) au total",
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
                          await Navigator.pushNamed(context, "/produits/create");
                          _loadData();
                        },
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text("Nouveau produit"),
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

            // 🔹 Tableau paginé
            Expanded(
              child: produits.isEmpty
                  ? _buildEmptyState(isDarkMode)
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        final availableHeight = constraints.maxHeight;
                        final calculatedRows = (availableHeight ~/ 80).clamp(5, 20);
                        rowsPerPage = calculatedRows;

                        return PaginatedDataTable(
                          header: Text(
                            "Catalogue des produits",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isDarkMode ? Colors.white : const Color(0xFF1E293B),
                            ),
                          ),
                          rowsPerPage: rowsPerPage,
                          columns: const [
                            DataColumn(label: Text("ID")),
                            DataColumn(label: Text("Nom du produit")),
                            DataColumn(label: Text("Actions")),
                          ],
                          source: _ProductDataSource(
                            context: context,
                            produits: produits,
                            categories: categories,
                            fournisseurs: fournisseurs,
                            onDelete: _deleteProduct,
                            reload: _loadData,
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
              Icons.inventory_2_outlined,
              size: 48,
              color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Aucun produit trouvé",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isDarkMode ? Colors.white : const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Ajoutez votre premier produit",
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? Colors.grey[500] : Colors.grey[500],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () async {
              await Navigator.pushNamed(context, "/produits/create");
              _loadData();
            },
            icon: const Icon(Icons.add, size: 18),
            label: const Text("Créer un produit"),
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
class _ProductDataSource extends DataTableSource {
  final BuildContext context;
  final List<Map<String, dynamic>> produits;
  final List<Map<String, dynamic>> categories;
  final List<Map<String, dynamic>> fournisseurs;
  final Function(int, String) onDelete;
  final Function reload;
  final bool isDarkMode;

  _ProductDataSource({
    required this.context,
    required this.produits,
    required this.categories,
    required this.fournisseurs,
    required this.onDelete,
    required this.reload,
    required this.isDarkMode,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= produits.length) return null;
    final p = produits[index];

    return DataRow(
      cells: [
        DataCell(
          Text(
            "${p['id']}",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: isDarkMode ? Colors.white : const Color(0xFF1E293B),
            ),
          ),
        ),
        DataCell(
          Text(
            p['nom'] ?? "Sans nom",
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
                    "/produits/detail",
                    arguments: {
                      "produit": p,
                      "categories": categories,
                      "fournisseurs": fournisseurs,
                    },
                  );
                  if (updated != null) reload();
                },
                icon: const Icon(Icons.visibility, color: Color(0xFF4361EE)),
                tooltip: "Voir les détails",
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
                  if (updated != null) reload();
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
                        "Supprimer le produit",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : const Color(0xFF1E293B),
                        ),
                      ),
                      content: Text(
                        "Voulez-vous vraiment supprimer ${p['nom']} ?",
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
                    onDelete(p["id"], p["nom"]);
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
  int get rowCount => produits.length;
  @override
  int get selectedRowCount => 0;
}