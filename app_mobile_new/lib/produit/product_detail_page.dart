import 'package:flutter/material.dart';
import '../theme_provider.dart';

class ProductDetailPage extends StatefulWidget {
  final Map<String, dynamic> produit;
  final List<Map<String, dynamic>> categories;
  final List<Map<String, dynamic>> fournisseurs;

  const ProductDetailPage({
    required this.produit,
    required this.categories,
    required this.fournisseurs,
    super.key,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
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

  String _getStockStatus(int stock, int seuil) {
    if (stock <= 0) return "Rupture de stock";
    if (stock <= seuil) return "Stock faible";
    return "Stock normal";
  }

  Color _getStockColor(int stock, int seuil) {
    if (stock <= 0) return Colors.red;
    if (stock <= seuil) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ThemeProvider.instance.themeMode == 'dark';
    final stock = widget.produit["stock"] ?? 0;
    final seuil = widget.produit["seuil_alerte"] ?? 10;
    final stockStatus = _getStockStatus(stock, seuil);
    final stockColor = _getStockColor(stock, seuil);

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          "Détails du produit",
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
                      Icons.inventory_2_outlined,
                      size: 48,
                      color: Color(0xFF4361EE),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.produit["nom"] ?? "Produit sans nom",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : const Color(0xFF1E293B),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Référence produit",
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
                    // Description
                    if (widget.produit["description"] != null && widget.produit["description"].isNotEmpty) ...[
                      const Text(
                        "Description",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.produit["description"],
                        style: TextStyle(
                          fontSize: 14,
                          color: isDarkMode ? Colors.grey[300] : const Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Divider(),
                      const SizedBox(height: 20),
                    ],

                    // Prix d'achat
                    _buildInfoRow(
                      "Prix d'achat",
                      "${widget.produit["prix_achat"]?.toString() ?? "0"} FCFA",
                      Icons.shopping_cart_outlined,
                      isDarkMode,
                    ),
                    const SizedBox(height: 16),

                    // Prix de vente
                    _buildInfoRow(
                      "Prix de vente",
                      "${widget.produit["prix_vente"]?.toString() ?? "0"} FCFA",
                      Icons.attach_money_outlined,
                      isDarkMode,
                    ),
                    const SizedBox(height: 16),

                    // Stock
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isDarkMode ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.inventory_outlined, size: 20, color: isDarkMode ? Colors.grey[400] : const Color(0xFF64748B)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Stock",
                                style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "${widget.produit["stock"] ?? 0} unités",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: isDarkMode ? Colors.white : const Color(0xFF1E293B),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: stockColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            stockStatus,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: stockColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Seuil d'alerte
                    _buildInfoRow(
                      "Seuil d'alerte",
                      "${widget.produit["seuil_alerte"] ?? 0} unités",
                      Icons.warning_outlined,
                      isDarkMode,
                    ),
                    const SizedBox(height: 16),

                    const Divider(),
                    const SizedBox(height: 16),

                    // Catégorie
                    _buildInfoRow(
                      "Catégorie",
                      widget.produit["categorie"]?["nom"] ?? "Non catégorisé",
                      Icons.category_outlined,
                      isDarkMode,
                    ),
                    const SizedBox(height: 16),

                    // Fournisseur
                    _buildInfoRow(
                      "Fournisseur",
                      widget.produit["fournisseur"]?["nom"] ?? "Non renseigné",
                      Icons.local_shipping_outlined,
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
                    onPressed: () => Navigator.pop(context),
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
                        "/produits/edit",
                        arguments: {
                          "produit": widget.produit,
                          "categories": widget.categories,
                          "fournisseurs": widget.fournisseurs,
                        },
                      );

                      if (updated != null && mounted) {
                        if (mounted) {
                          Navigator.pushReplacementNamed(
                            context,
                            "/produits/detail",
                            arguments: {
                              "produit": updated,
                              "categories": widget.categories,
                              "fournisseurs": widget.fournisseurs,
                            },
                          );
                        }
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
}