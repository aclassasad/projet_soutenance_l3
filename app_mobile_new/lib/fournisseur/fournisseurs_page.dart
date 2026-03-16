import 'package:flutter/material.dart';
import 'fournisseur_service.dart';

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors du chargement: $e")),
      );
    }
  }

  Future<void> _deleteFournisseur(int id, String nom) async {
    try {
      await FournisseurService.deleteFournisseur(id);
      setState(() {
        fournisseurs.removeWhere((f) => f["id"] == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Fournisseur $nom supprimé")),
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
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Liste des Fournisseurs")),
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
                  final created = await Navigator.pushNamed(context, "/fournisseurs/create");
                  if (created != null && created is Map<String, dynamic>) {
                    setState(() {
                      fournisseurs.add(created);
                    });
                  }
                },
                icon: const Icon(Icons.add),
                label: const Text("Nouveau"),
              ),
              
              
            ]),

            const SizedBox(height: 20),

            Expanded(
              child: fournisseurs.isEmpty
                  ? const Center(child: Text("Aucun fournisseur trouvé"))
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        // 🔹 Adapter le nombre de lignes selon la hauteur disponible
                        final availableHeight = constraints.maxHeight;
                        final calculatedRows = (availableHeight ~/ 80).clamp(5, 20);
                        rowsPerPage = calculatedRows;

                        return PaginatedDataTable(
                          header: const Text("Fournisseurs"),
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
class _FournisseurDataSource extends DataTableSource {
  final BuildContext context;
  final List<Map<String, dynamic>> fournisseurs;
  final Function(int id, String nom) onDelete;
  final Function(Map<String, dynamic> updated) onUpdate;

  _FournisseurDataSource({
    required this.context,
    required this.fournisseurs,
    required this.onDelete,
    required this.onUpdate,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= fournisseurs.length) return null;
    final f = fournisseurs[index];

    return DataRow(cells: [
      DataCell(Text("${f['id']}")),
      DataCell(Text(f['nom'] ?? "")),
      DataCell(Row(children: [
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
          icon: const Icon(Icons.visibility, color: Colors.blue),
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
          icon: const Icon(Icons.edit, color: Colors.orange),
        ),
       IconButton(
  onPressed: () async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Supprimer le fournisseur"),
        content: Text("Voulez-vous vraiment supprimer ${f['nom']} ?"),
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
      onDelete(f["id"], f["nom"]);
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
  int get rowCount => fournisseurs.length;
  @override
  int get selectedRowCount => 0;
}