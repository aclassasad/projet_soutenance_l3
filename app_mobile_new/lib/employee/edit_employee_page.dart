import 'package:flutter/material.dart';
import 'employee_service.dart';

class EditEmployeePage extends StatefulWidget {
  final Map<String, dynamic> user;

  const EditEmployeePage({required this.user, super.key});

  @override
  State<EditEmployeePage> createState() => _EditEmployeePageState();
}

class _EditEmployeePageState extends State<EditEmployeePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  String _role = "admin";
  String _statut = "1";
  bool loading = false;

  // Mapping des rôles pour l'affichage
  final Map<String, String> _roleLabels = {
    "admin": "Administrateur",
    "gerant": "Gérant",
    "caissier": "Caissier",
  };

  final Map<String, Color> _roleColors = {
    "admin": const Color(0xFFEF4444),
    "gerant": const Color(0xFFF59E0B),
    "caissier": const Color(0xFF4361EE),
  };

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user["name"]);
    _emailController = TextEditingController(text: widget.user["email"]);
    _role = widget.user["role"] ?? "admin";
    _statut = widget.user["statut"]?.toString() ?? "1";
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _updateEmployee() async {
    if (_formKey.currentState!.validate()) {
      setState(() => loading = true);
      try {
        await EmployeeService.updateEmployee(
          id: widget.user["id"],
          nom: _nameController.text,
          email: _emailController.text,
          role: _role,
          statut: _statut,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("Employé mis à jour avec succès"),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
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
      } finally {
        setState(() => loading = false);
      }
    }
  }

  String _getRoleDisplayName() {
    return _roleLabels[_role] ?? _role.toUpperCase();
  }

  Color _getRoleColor() {
    return _roleColors[_role] ?? const Color(0xFF64748B);
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.user["name"] ?? "Employé";

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          "Modifier l'employé",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF64748B)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // En-tête avec avatar et informations
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 24),
              child: Column(
                children: [
                  // Avatar
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _getRoleColor().withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      _getInitials(name),
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: _getRoleColor(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getRoleColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _getRoleDisplayName(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _getRoleColor(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _statut == "1"
                          ? const Color(0xFF10B981).withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.circle,
                          size: 8,
                          color: _statut == "1" ? const Color(0xFF10B981) : Colors.grey,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _statut == "1" ? "Actif" : "En congé",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: _statut == "1" ? const Color(0xFF10B981) : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Formulaire
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 1,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Champ Nom
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: "Nom complet",
                          hintText: "Entrez le nom de l'employé",
                          prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF64748B)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF4361EE), width: 1.5),
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        validator: (val) => val == null || val.isEmpty ? "Nom requis" : null,
                      ),
                      const SizedBox(height: 16),

                      // Champ Email
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Email",
                          hintText: "exemple@email.com",
                          prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF64748B)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF4361EE), width: 1.5),
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        validator: (val) {
                          if (val == null || val.isEmpty) return "Email requis";
                          final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                          if (!regex.hasMatch(val)) return "Email invalide";
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Rôle
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButtonFormField<String>(
                          initialValue: _role,
                          items: const [
                            DropdownMenuItem(value: "admin", child: Text("Administrateur")),
                            DropdownMenuItem(value: "gerant", child: Text("Gérant")),
                            DropdownMenuItem(value: "caissier", child: Text("Caissier")),
                          ],
                          onChanged: (val) => setState(() => _role = val!),
                          decoration: const InputDecoration(
                            labelText: "Rôle",
                            prefixIcon: Icon(Icons.badge_outlined, color: Color(0xFF64748B)),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Statut
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButtonFormField<String>(
                          initialValue: _statut,
                          items: const [
                            DropdownMenuItem(value: "1", child: Text("Actif")),
                            DropdownMenuItem(value: "0", child: Text("En congé")),
                          ],
                          onChanged: (val) => setState(() => _statut = val!),
                          decoration: const InputDecoration(
                            labelText: "Statut",
                            prefixIcon: Icon(Icons.circle_notifications_outlined, color: Color(0xFF64748B)),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Boutons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: loading ? null : _updateEmployee,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4361EE),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: loading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      "Mettre à jour",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF64748B),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                side: BorderSide(color: Colors.grey.shade300),
                              ),
                              child: const Text(
                                "Annuler",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return "??";
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
  }
}