import 'package:flutter/material.dart';
import 'fournisseur_service.dart';
import '../theme_provider.dart';

class FournisseursPage extends StatefulWidget {
  const FournisseursPage({super.key});

  @override
  State<FournisseursPage> createState() => _FournisseursPageState();
}

class _FournisseursPageState extends State<FournisseursPage> {
  List<Map<String, dynamic>> fournisseurs = [];
  bool loading = true;
  int rowsPerPage = PaginatedDataTable.defaultRowsPerPage;

  @override
  void initState() {
    super.initState();
    _loadFournisseurs();
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

  Future<void> _loadFournisseurs() async {
    try {
      final data = await FournisseurService.getFournisseurs();
      setState(() {
        fournisseurs = data;
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

  Future<void> _deleteFournisseur(int id, String nom) async {
    try {
      await FournisseurService.deleteFournisseur(id);
      setState(() {
        fournisseurs.removeWhere((f) => f["id"] == id);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Fournisseur $nom supprimé"),
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
                "Chargement des fournisseurs...",
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
          "Liste des fournisseurs",
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
            onPressed: _loadFournisseurs,
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
                          "Gestion des fournisseurs",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${fournisseurs.length} fournisseur(s) au total",
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
                          final created = await Navigator.pushNamed(context, "/fournisseurs/create");
                          if (created != null && created is Map<String, dynamic>) {
                            setState(() {
                              fournisseurs.add(created);
                            });
                          }
                        },
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text("Nouveau fournisseur"),
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

            // Tableau paginé avec scroll horizontal pour éviter le débordement
            Expanded(
              child: fournisseurs.isEmpty
                  ? _buildEmptyState(isDarkMode)
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        final availableHeight = constraints.maxHeight;
                        final calculatedRows = (availableHeight ~/ 80).clamp(5, 20);
                        rowsPerPage = calculatedRows;

                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width - 32,
                            child: PaginatedDataTable(
                              header: Text(
                                "Catalogue des fournisseurs",
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
                              source: _FournisseurDataSource(
                                context: context,
                                fournisseurs: fournisseurs,
                                onDelete: _deleteFournisseur,
                                onUpdate: (updated) {
                                  setState(() {
                                    final index = fournisseurs.indexWhere((item) => item["id"] == updated["id"]);
                                    if (index != -1) {
                                      fournisseurs[index] = updated;
                                    }
                                  });
                                },
                                isDarkMode: isDarkMode,
                              ),
                              showCheckboxColumn: false,
                              headingRowColor: MaterialStateProperty.all(
                                isDarkMode ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                              ),
                            ),
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
              Icons.local_shipping_outlined,
              size: 48,
              color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Aucun fournisseur trouvé",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isDarkMode ? Colors.white : const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Ajoutez votre premier fournisseur",
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? Colors.grey[500] : Colors.grey[500],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () async {
              final created = await Navigator.pushNamed(context, "/fournisseurs/create");
              if (created != null && created is Map<String, dynamic>) {
                setState(() {
                  fournisseurs.add(created);
                });
              }
            },
            icon: const Icon(Icons.add, size: 18),
            label: const Text("Créer un fournisseur"),
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
class _FournisseurDataSource extends DataTableSource {
  final BuildContext context;
  final List<Map<String, dynamic>> fournisseurs;
  final Function(int id, String nom) onDelete;
  final Function(Map<String, dynamic> updated) onUpdate;
  final bool isDarkMode;

  _FournisseurDataSource({
    required this.context,
    required this.fournisseurs,
    required this.onDelete,
    required this.onUpdate,
    required this.isDarkMode,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= fournisseurs.length) return null;
    final f = fournisseurs[index];

    return DataRow(
      cells: [
        DataCell(
          Text(
            "${f['id']}",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: isDarkMode ? Colors.white : const Color(0xFF1E293B),
            ),
          ),
        ),
        DataCell(
          Text(
            f['nom'] ?? "",
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
                    "/fournisseurs/detail",
                    arguments: f,
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
                    "/fournisseurs/edit",
                    arguments: f,
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
                        "Supprimer le fournisseur",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : const Color(0xFF1E293B),
                        ),
                      ),
                      content: Text(
                        "Voulez-vous vraiment supprimer ${f['nom']} ?",
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
                    onDelete(f["id"], f["nom"]);
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
  int get rowCount => fournisseurs.length;
  @override
  int get selectedRowCount => 0;
}