import 'package:flutter/material.dart';

class FournisseurDetailPage extends StatefulWidget {
  final Map<String, dynamic> fournisseur;

  const FournisseurDetailPage({required this.fournisseur, super.key});

  @override
  State<FournisseurDetailPage> createState() => _FournisseurDetailPageState();
}

class _FournisseurDetailPageState extends State<FournisseurDetailPage> {
  late Map<String, dynamic> fournisseur;

  @override
  void initState() {
    super.initState();
    fournisseur = widget.fournisseur;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Détails Fournisseur")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text(
            "Détails du Fournisseur",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fournisseur["nom"],
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text("Email : ${fournisseur["email"] ?? ""}"),
                    Text("Téléphone : ${fournisseur["telephone"] ?? ""}"),
                    Text("Adresse : ${fournisseur["adresse"] ?? ""}"),
                  ]),
            ),
          ),

          const SizedBox(height: 20),

          Row(children: [
            OutlinedButton.icon(
  onPressed: () => Navigator.pop(context, fournisseur), // ✅ renvoie le fournisseur actuel
  icon: const Icon(Icons.arrow_back),
  label: const Text("Retour"),
),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: () async {
                final updated = await Navigator.pushNamed(
                  context,
                  "/fournisseurs/edit",
                  arguments: fournisseur,
                );

                if (updated != null && updated is Map<String, dynamic>) {
                  setState(() {
                    fournisseur = updated;
                  });
                }
              },
              icon: const Icon(Icons.edit),
              label: const Text("Modifier"),
            ),
          ]),
        ]),
      ),
    );
  }
}