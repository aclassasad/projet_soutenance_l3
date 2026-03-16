import 'package:flutter/material.dart';

class FournisseurDetailPage extends StatelessWidget {
  final Map<String, dynamic> fournisseur;

  const FournisseurDetailPage({required this.fournisseur, super.key});

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
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text("Retour"),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  "/fournisseurs/edit",
                  arguments: fournisseur,
                );
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