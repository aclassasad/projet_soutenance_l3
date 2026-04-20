import 'package:flutter/material.dart';
import 'fournisseur_service.dart';
import '../theme_provider.dart';

class CreateFournisseurPage extends StatefulWidget {
  const CreateFournisseurPage({super.key});

  @override
  State<CreateFournisseurPage> createState() => _CreateFournisseurPageState();
}

class _CreateFournisseurPageState extends State<CreateFournisseurPage> {
  final _formKey = GlobalKey<FormState>();
  String nom = "";
  String email = "";
  String telephone = "";
  String adresse = "";
  bool loading = false;

  @override
  void initState() {
    super.initState();
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

  Future<void> _saveFournisseur() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => loading = true);

      try {
        await FournisseurService.createFournisseur(
          nom: nom,
          email: email,
          telephone: telephone,
          adresse: adresse,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("Fournisseur enregistré avec succès"),
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

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ThemeProvider.instance.themeMode == 'dark';

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          "Nouveau fournisseur",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDarkMode ? Colors.grey[400] : const Color(0xFF64748B)),
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
                      Icons.local_shipping_outlined,
                      size: 48,
                      color: Color(0xFF4361EE),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Créer un fournisseur",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Ajoutez un nouveau fournisseur à votre base",
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // Formulaire
            Container(
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: isDarkMode ? Colors.black.withOpacity(0.3) : Colors.grey.withOpacity(0.1),
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
                        decoration: InputDecoration(
                          labelText: "Nom du fournisseur",
                          hintText: "Entrez le nom du fournisseur",
                          prefixIcon: const Icon(Icons.business_outlined, color: Color(0xFF64748B)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: isDarkMode ? const Color(0xFF334155) : Colors.grey.shade50,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF4361EE), width: 1.5),
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                        validator: (val) => val == null || val.isEmpty ? "Nom requis" : null,
                        onSaved: (val) => nom = val!,
                      ),
                      const SizedBox(height: 20),

                      // Champ Email
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Email",
                          hintText: "Entrez l'email du fournisseur",
                          prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF64748B)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: isDarkMode ? const Color(0xFF334155) : Colors.grey.shade50,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF4361EE), width: 1.5),
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (val) => email = val ?? "",
                      ),
                      const SizedBox(height: 20),

                      // Champ Téléphone
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Téléphone",
                          hintText: "Entrez le numéro de téléphone",
                          prefixIcon: const Icon(Icons.phone_outlined, color: Color(0xFF64748B)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: isDarkMode ? const Color(0xFF334155) : Colors.grey.shade50,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF4361EE), width: 1.5),
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                        keyboardType: TextInputType.phone,
                        onSaved: (val) => telephone = val ?? "",
                      ),
                      const SizedBox(height: 20),

                      // Champ Adresse
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Adresse",
                          hintText: "Entrez l'adresse du fournisseur",
                          prefixIcon: const Icon(Icons.location_on_outlined, color: Color(0xFF64748B)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: isDarkMode ? const Color(0xFF334155) : Colors.grey.shade50,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF4361EE), width: 1.5),
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                        maxLines: 3,
                        onSaved: (val) => adresse = val ?? "",
                      ),
                      const SizedBox(height: 28),

                      // Boutons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: loading ? null : _saveFournisseur,
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
                                      "Enregistrer",
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
                                foregroundColor: isDarkMode ? Colors.grey[400] : const Color(0xFF64748B),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                side: BorderSide(
                                  color: isDarkMode ? const Color(0xFF475569) : Colors.grey.shade300,
                                ),
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