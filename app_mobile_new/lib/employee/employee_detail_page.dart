import 'package:flutter/material.dart';
import 'employee_service.dart';

class EmployeeDetailPage extends StatefulWidget {
  final Map<String, dynamic> user;

  const EmployeeDetailPage({required this.user, super.key});

  @override
  State<EmployeeDetailPage> createState() => _EmployeeDetailPageState();
}

class _EmployeeDetailPageState extends State<EmployeeDetailPage> {
  List<Map<String, dynamic>> ventes = [];
  bool loadingVentes = true;

  @override
  void initState() {
    super.initState();
    if (widget.user["role"] == "caissier") {
      _loadVentes();
    }
  }

  Future<void> _loadVentes() async {
    try {
      final data = await EmployeeService.getEmployeeSales(widget.user["id"]);
      setState(() {
        ventes = data;
        loadingVentes = false;
      });
    } catch (e) {
      setState(() => loadingVentes = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final statutLabel = (widget.user["statut"] == 1 || widget.user["statut"] == "1")
        ? "Actif"
        : "En congé";

    return Scaffold(
      appBar: AppBar(title: const Text("Détails Employé")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text("Détails de l’employé",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

          const SizedBox(height: 16),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.user["name"],
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text("Email : ${widget.user["email"]}"),
                    Text("Rôle : ${widget.user["role"]}"),
                    Text("Statut : $statutLabel"),
                  ]),
            ),
          ),

          const SizedBox(height: 20),

          Row(children: [
            OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text("Retour"),
            ),
            const SizedBox(width: 12),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  "/employees/edit",
                  arguments: widget.user,
                );
              },
              icon: const Icon(Icons.edit),
              label: const Text("Modifier"),
            ),
          ]),

          const SizedBox(height: 20),

          // 🔹 Liste des ventes si caissier
          if (widget.user["role"] == "caissier")
            Expanded(
              child: loadingVentes
                  ? const Center(child: CircularProgressIndicator())
                  : ventes.isEmpty
                      ? const Center(child: Text("Aucune vente trouvée"))
                      : ListView.builder(
                          itemCount: ventes.length,
                          itemBuilder: (context, i) {
                            final v = ventes[i];
                            final lignes = v['lignes'] ?? [];

                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              elevation: 3,
                              child: ListTile(
                                leading: const Icon(Icons.receipt_long,
                                    color: Colors.blue),
                                title: Text(
                                  "Vente #${v['id']}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text("Total : ${v['total']} FCFA"),
                                trailing: Text(v['created_at'] ?? ""),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) {
                                      final totalGeneral =
                                          double.tryParse(v['total'].toString()) ?? 0.0;

                                      return AlertDialog(
                                        title: Text("Détails Vente #${v['id']}"),
                                        content: SizedBox(
                                          width: double.maxFinite,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Flexible(
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: lignes.length,
                                                  itemBuilder: (context, j) {
                                                    final ligne = lignes[j];
                                                    final produit =
                                                        ligne['produit'] ?? {};
                                                    final quantite =
                                                        int.tryParse(ligne['quantite'].toString()) ?? 0;
                                                    final prixUnitaire =
                                                        double.tryParse(ligne['prix_unitaire'].toString()) ?? 0.0;
                                                    final sousTotal =
                                                        quantite * prixUnitaire;

                                                    return ListTile(
                                                      leading: const Icon(
                                                          Icons.shopping_cart,
                                                          color: Colors.green),
                                                      title: Text(produit['nom'] ??
                                                          "Produit inconnu"),
                                                      subtitle: Text("Quantité : $quantite"),
                                                      trailing: Text("$sousTotal FCFA"),
                                                    );
                                                  },
                                                ),
                                              ),
                                              const SizedBox(height: 12),
                                              Align(
                                                alignment: Alignment.centerRight,
                                                child: Text(
                                                  "Total : $totalGeneral FCFA",
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text("Fermer"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            );
                          },
                        ),
            )
        ]),
      ),
    );
  }
}