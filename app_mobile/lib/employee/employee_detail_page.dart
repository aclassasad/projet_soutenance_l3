import 'package:flutter/material.dart';

class EmployeeDetailPage extends StatelessWidget {
  final Map<String, dynamic> user;

  const EmployeeDetailPage({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    final statutLabel = (user["statut"] == 1 || user["statut"] == "1")
        ? "Actif"
        : "En congé";

    return Scaffold(
      appBar: AppBar(title: const Text("Détails Employé")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text(
            "Détails de l’employé",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user["name"],
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text("Email : ${user["email"]}"),
                    Text("Rôle : ${user["role"]}"),
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
                  arguments: user,
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