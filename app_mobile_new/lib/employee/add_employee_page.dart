import 'package:flutter/material.dart';
import 'employee_service.dart';

class AddEmployeePage extends StatefulWidget {
  const AddEmployeePage({super.key});

  @override
  State<AddEmployeePage> createState() => _AddEmployeePageState();
}

class _AddEmployeePageState extends State<AddEmployeePage> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _showPassword = false;
  bool _showConfirm = false;
  int _strength = 0;
  String _role = "admin";
  String _statut = "1";
  bool loading = false;

  // Vérification email
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return "Email requis";
    final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!regex.hasMatch(value)) return "Email invalide";
    return null;
  }

  // Vérification force mot de passe
  void _checkPasswordStrength(String value) {
    int strength = 0;
    if (value.length >= 8) strength++;
    if (RegExp(r'[A-Z]').hasMatch(value)) strength++;
    if (RegExp(r'[a-z]').hasMatch(value)) strength++;
    if (RegExp(r'\d').hasMatch(value)) strength++;
    if (RegExp(r'[@$!%*?&]').hasMatch(value)) strength++;
    setState(() => _strength = strength);
  }

  // Vérification confirmation
  String? _validateConfirm(String? value) {
    if (value != _passwordController.text) return "Les mots de passe ne correspondent pas";
    return null;
  }

  Future<void> _createEmployee() async {
    if (_formKey.currentState!.validate()) {
      setState(() => loading = true);
      try {
        await EmployeeService.createEmployee(
          nom: _nomController.text,
          email: _emailController.text,
          password: _passwordController.text,
          role: _role,
          statut: _statut,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("Employé créé avec succès"),
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

  String _getStrengthText() {
    if (_strength <= 2) return "Faible";
    if (_strength == 3) return "Moyen";
    if (_strength == 4) return "Bon";
    return "Fort";
  }

  Color _getStrengthColor() {
    if (_strength <= 2) return Colors.red;
    if (_strength == 3) return Colors.orange;
    if (_strength == 4) return const Color(0xFF06B6D4);
    return const Color(0xFF10B981);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          "Ajouter un employé",
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
            // En-tête avec icône
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 24),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4361EE).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_add_alt_rounded,
                      size: 48,
                      color: Color(0xFF4361EE),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Nouvel employé",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Remplissez les informations ci-dessous",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
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
                        controller: _nomController,
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
                        validator: _validateEmail,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 16),

                      // Champ Mot de passe
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_showPassword,
                        decoration: InputDecoration(
                          labelText: "Mot de passe",
                          hintText: "Entrez un mot de passe sécurisé",
                          prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF64748B)),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _showPassword ? Icons.visibility_off : Icons.visibility,
                              color: const Color(0xFF64748B),
                            ),
                            onPressed: () => setState(() => _showPassword = !_showPassword),
                          ),
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
                        onChanged: _checkPasswordStrength,
                        validator: (val) => val == null || val.isEmpty ? "Mot de passe requis" : null,
                      ),
                      const SizedBox(height: 8),

                      // Barre de force du mot de passe
                      if (_passwordController.text.isNotEmpty) ...[
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: LinearProgressIndicator(
                                  value: _strength / 5,
                                  backgroundColor: Colors.grey.shade200,
                                  color: _getStrengthColor(),
                                  minHeight: 6,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: _getStrengthColor().withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _getStrengthText(),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: _getStrengthColor(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Text(
                            "8+ caractères, majuscule, minuscule, chiffre, caractère spécial",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[500],
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),

                      // Champ Confirmation mot de passe
                      TextFormField(
                        controller: _confirmController,
                        obscureText: !_showConfirm,
                        decoration: InputDecoration(
                          labelText: "Confirmer le mot de passe",
                          hintText: "Répétez le mot de passe",
                          prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF64748B)),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _showConfirm ? Icons.visibility_off : Icons.visibility,
                              color: const Color(0xFF64748B),
                            ),
                            onPressed: () => setState(() => _showConfirm = !_showConfirm),
                          ),
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
                        validator: _validateConfirm,
                      ),
                      const SizedBox(height: 16),

                      // Rôle
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButtonFormField(
                          initialValue: _role,
                          items: const [
                            DropdownMenuItem(value: "admin", child: Text("Admin")),
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
                        child: DropdownButtonFormField(
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
                              onPressed: loading ? null : _createEmployee,
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
                                      "Créer l'employé",
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
}