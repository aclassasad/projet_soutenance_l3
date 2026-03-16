import 'package:flutter/material.dart';
import 'fournisseur_service.dart';

class FournisseursPage extends StatefulWidget {
  final List<Map<String, dynamic>> fournisseurs;

  const FournisseursPage({required this.fournisseurs, super.key});

  @override
  State<FournisseursPage> createState() => _FournisseursPageState();
}

class _FournisseursPageState extends State<FournisseursPage> {
  late List<Map<String, dynamic>> fournisseurs;

  @override
  void initState() {
    super.initState();
    fournisseurs = widget.fournisseurs;
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
    return Scaffold(
      appBar: AppBar(title: const Text("Liste des Fournisseurs")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, "/fournisseurs/create");
              },
              icon: const Icon(Icons.add),
              label: const Text("Nouveau Fournisseur"),
            ),
            const SizedBox(width: 8),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, "/inventory");
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text("Retour à l’inventaire"),
            ),
          ]),

          const SizedBox(height: 20),

          Expanded(
            child: fournisseurs.isEmpty
                ? const Center(child: Text("Aucun fournisseur trouvé"))
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text("ID")),
                        DataColumn(label: Text("Nom")),
                        DataColumn(label: Text("Email")),
                        DataColumn(label: Text("Téléphone")),
                        DataColumn(label: Text("Adresse")),
                        DataColumn(label: Text("Actions")),
                      ],
                      rows: fournisseurs.map((f) {
                        return DataRow(cells: [
                          DataCell(Text("${f['id']}")),
                          DataCell(Text(f['nom'])),
                          DataCell(Text(f['email'] ?? "")),
                          DataCell(Text(f['telephone'] ?? "")),
                          DataCell(Text(f['adresse'] ?? "")),
                          DataCell(Row(children: [
                            IconButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  "/fournisseurs/detail",
                                  arguments: f,
                                );
                              },
                              icon: const Icon(Icons.visibility, color: Colors.blue),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  "/fournisseurs/edit",
                                  arguments: f,
                                );
                              },
                              icon: const Icon(Icons.edit, color: Colors.orange),
                            ),
                            IconButton(
                              onPressed: () {
                                _deleteFournisseur(f["id"], f["nom"]);
                              },
                              icon: const Icon(Icons.delete, color: Colors.red),
                            ),
                          ])),
                        ]);
                      }).toList(),
                    ),
                  ),
          ),
        ]),
      ),
    );
  }
}