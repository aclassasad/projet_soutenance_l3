import 'package:flutter/material.dart';
import '../theme_provider.dart';

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

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ThemeProvider.instance.themeMode == 'dark';

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          "Détails du fournisseur",
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
          onPressed: () => Navigator.pop(context, fournisseur),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête avec icône
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 20),
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
                    fournisseur["nom"] ?? "Fournisseur sans nom",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : const Color(0xFF1E293B),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Informations du fournisseur",
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // Carte d'informations
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nom
                    _buildInfoRow(
                      "Nom",
                      fournisseur["nom"] ?? "Non renseigné",
                      Icons.business_outlined,
                      isDarkMode,
                    ),
                    const SizedBox(height: 16),

                    // Email
                    _buildInfoRow(
                      "Email",
                      fournisseur["email"] ?? "Non renseigné",
                      Icons.email_outlined,
                      isDarkMode,
                    ),
                    const SizedBox(height: 16),

                    // Téléphone
                    _buildInfoRow(
                      "Téléphone",
                      fournisseur["telephone"] ?? "Non renseigné",
                      Icons.phone_outlined,
                      isDarkMode,
                    ),
                    const SizedBox(height: 16),

                    // Adresse
                    _buildInfoRow(
                      "Adresse",
                      fournisseur["adresse"] ?? "Non renseignée",
                      Icons.location_on_outlined,
                      isDarkMode,
                    ),
                    const SizedBox(height: 16),

                    // Date de création (si disponible)
                    if (fournisseur["created_at"] != null)
                      _buildInfoRow(
                        "Date d'ajout",
                        _formatDate(fournisseur["created_at"]),
                        Icons.calendar_today_outlined,
                        isDarkMode,
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Boutons d'action
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context, fournisseur),
                    icon: const Icon(Icons.arrow_back, size: 18),
                    label: const Text("Retour"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: isDarkMode ? Colors.grey[400] : const Color(0xFF64748B),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(
                        color: isDarkMode ? const Color(0xFF475569) : Colors.grey.shade300,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final updated = await Navigator.pushNamed(
                        context,
                        "/fournisseurs/edit",
                        arguments: fournisseur,
                      );

                      if (updated != null && updated is Map<String, dynamic> && mounted) {
                        setState(() {
                          fournisseur = updated;
                        });
                      }
                    },
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text("Modifier"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4361EE),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon, bool isDarkMode) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: isDarkMode ? Colors.grey[400] : const Color(0xFF64748B)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.white : const Color(0xFF1E293B),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(String? dateTime) {
    if (dateTime == null || dateTime.isEmpty) return "Non renseignée";
    try {
      if (dateTime.contains('T')) {
        final date = dateTime.split('T')[0];
        return date;
      }
      return dateTime;
    } catch (e) {
      return dateTime;
    }
  }
}