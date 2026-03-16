import 'package:flutter/material.dart';
import 'employee_service.dart';

class EmployeesPage extends StatefulWidget {
  const EmployeesPage({super.key});

  @override
  State<EmployeesPage> createState() => _EmployeesPageState();
}

class _EmployeesPageState extends State<EmployeesPage> {
  Map<String, dynamic>? stats;
  List<Map<String, dynamic>> employees = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadEmployees();
  }

  Future<void> _loadEmployees() async {
    try {
      final statsData = await EmployeeService.getEmployeeStats();
      final employeesData = await EmployeeService.getEmployees();
      setState(() {
        stats = statsData;
        employees = employeesData;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Employee Management")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Header
        LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth < 600) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Employee Management", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const Text("Manage your store's staff and schedules", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () async {
              await Navigator.pushNamed(context, "/employees/add");
              _loadEmployees();
            },
            icon: const Icon(Icons.folder),
            label: const Text("Ajouter un employé"),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("Employee Management", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Text("Manage your store's staff and schedules", style: TextStyle(color: Colors.grey)),
            ],
          ),
          ElevatedButton.icon(
            onPressed: () async {
              await Navigator.pushNamed(context, "/employees/add");
              _loadEmployees();
            },
            icon: const Icon(Icons.folder),
            label: const Text("Ajouter un employé"),
          ),
        ],
      );
    }
  },
),

          const SizedBox(height: 20),

          // Stats Cards
          Wrap(
  spacing: 12,
  runSpacing: 12,
  children: [
    SizedBox(
      width: MediaQuery.of(context).size.width / 2 - 24,
      child: _statCard("Total Employees", stats!['total'] ?? 0, Colors.indigo, Icons.people),
    ),
    SizedBox(
      width: MediaQuery.of(context).size.width / 2 - 24,
      child: _statCard("Active Today", stats!['actifs'] ?? 0, Colors.green, Icons.check_circle),
    ),
    SizedBox(
      width: MediaQuery.of(context).size.width / 2 - 24,
      child: _statCard("On Leave", stats!['conges'] ?? 0, Colors.teal, Icons.access_time),
    ),
  ],
),

          const SizedBox(height: 24),
          const Text("Staff Directory", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),

          const SizedBox(height: 12),
          employees.isEmpty
              ? _emptyEmployees()
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width < 600 ? 1 : 2,
                  childAspectRatio: 0.85, // ✅ réduit la hauteur relative
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                  itemCount: employees.length,
                  itemBuilder: (context, i) => _employeeCard(employees[i], i),
                ),
        ]),
      ),
    );
  }

  // Stat Card
  Widget _statCard(String title, int value, Color color, IconData icon) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [color.withOpacity(0.9), color.withOpacity(0.6)]),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(8),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(color: Colors.white70)),
            Text("$value", style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ]),
          CircleAvatar(backgroundColor: Colors.white.withOpacity(0.2), child: Icon(icon, color: Colors.white)),
        ]),
      ),
    );
  }

  // Employee Card
  Widget _employeeCard(Map<String, dynamic> emp, int index) {
    final colors = [Colors.indigo, Colors.green, Colors.orange, Colors.red];
    final color = colors[index % colors.length];
    final name = emp['name'] ?? "??";
    final initials = name.isNotEmpty
        ? name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase()
        : "??";

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
           mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: [
          Row(children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: color.withOpacity(0.1),
              child: Text(initials, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 18)),
            ),
            const SizedBox(width: 8),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(emp['name'] ?? "Sans nom", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              _roleBadge(emp['role'] ?? "inconnu"),
            ]),
          ]),
          const SizedBox(height: 8),
          _infoRow(Icons.email, emp['email'] ?? "no-email@example.com"),
          _infoRow(Icons.phone, emp['telephone'] ?? "(555) 123-4567"),
          _infoRow(Icons.access_time, emp['horaire'] ?? "Morning (8AM-4PM)"),
          _infoRow(Icons.calendar_today, "Joined: ${emp['created_at'] ?? "N/A"}"),
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            // Statut
            (emp['statut'] ?? 0) == 1
                ? const Text("Active Today", style: TextStyle(color: Colors.green))
                : const Text("On Leave", style: TextStyle(color: Colors.grey)),

            Row(children: [
              // 🔹 Vue
              IconButton(
                onPressed: () async {
                  await Navigator.pushNamed(
                    context,
                    "/employees/detail",
                    arguments: emp,
                  );
                },
                icon: const Icon(Icons.visibility, color: Colors.teal),
              ),

              // 🔹 Éditer
              IconButton(
                onPressed: () async {
                  await Navigator.pushNamed(
                    context,
                    "/employees/edit",
                    arguments: emp,
                  ).then((_) => _loadEmployees());
                },
                icon: const Icon(Icons.edit, color: Colors.blue),
              ),

              // 🔹 Supprimer
              IconButton(
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text("Supprimer l'employé"),
                      content: Text("Voulez-vous vraiment supprimer ${emp['name']} ?"),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Annuler")),
                        ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Supprimer")),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    try {
                      await EmployeeService.deleteEmployee(emp['id']);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Employé supprimé avec succès")),
                      );
                      _loadEmployees();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Erreur lors de la suppression: $e")),
                      );
                    }
                  }
                },
                icon: const Icon(Icons.delete, color: Colors.red),
              ),
            ]),
          ])
        ]),
      ),
    );
  }

  Widget _roleBadge(String role) {
    final roleLabels = {"admin": "Administrateur", "gerant": "Gérant", "caissier": "Caissier"};
    final roleColors = {"admin": Colors.red, "gerant": Colors.orange, "caissier": Colors.blue};
    final label = roleLabels[role] ?? role.toUpperCase();
    final color = roleColors[role] ?? Colors.grey;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12)),
    );
  }

   Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 12)),
      ]),
    );
  }

  Widget _emptyEmployees() {
    return Center(
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(children: const [
            Icon(Icons.group_off, size: 48, color: Colors.grey),
            SizedBox(height: 12),
            Text("No employees found", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("Start by adding your first employee", style: TextStyle(color: Colors.grey)),
          ]),
        ),
      ),
    );
  }
}