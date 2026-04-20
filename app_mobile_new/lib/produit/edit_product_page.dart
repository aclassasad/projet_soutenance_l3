import 'package:flutter/material.dart';
import 'product_service.dart';
import '../theme_provider.dart';

class EditProductPage extends StatefulWidget {
  final Map<String, dynamic> produit;
  final List<Map<String, dynamic>> categories;
  final List<Map<String, dynamic>> fournisseurs;

  const EditProductPage({
    required this.produit,
    required this.categories,
    required this.fournisseurs,
    super.key,
  });

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomController;
  late TextEditingController _descriptionController;
  late TextEditingController _prixAchatController;
  late TextEditingController _prixVenteController;
  late TextEditingController _stockController;
  late TextEditingController _seuilController;

  String? categorieId;
  String? fournisseurId;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _nomController = TextEditingController(text: widget.produit["nom"]);
    _descriptionController = TextEditingController(text: widget.produit["description"]);
    _prixAchatController = TextEditingController(text: widget.produit["prix_achat"].toString());
    _prixVenteController = TextEditingController(text: widget.produit["prix_vente"].toString());
    _stockController = TextEditingController(text: widget.produit["stock"].toString());
    _seuilController = TextEditingController(text: widget.produit["seuil_alerte"].toString());

    categorieId = widget.produit["categorie_id"].toString();
    fournisseurId = widget.produit["fournisseur_id"].toString();
    
    // Écouter les changements de thème
    ThemeProvider.instance.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    ThemeProvider.instance.removeListener(_onThemeChanged);
    _nomController.dispose();
    _descriptionController.dispose();
    _prixAchatController.dispose();
    _prixVenteController.dispose();
    _stockController.dispose();
    _seuilController.dispose();
    super.dispose();
  }

  void _onThemeChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _updateProduct() async {
    if (_formKey.currentState!.validate()) {
      setState(() => loading = true);
      try {
        final updatedProduct = await ProductService.updateProduct(
          id: widget.produit["id"],
          nom: _nomController.text,
          description: _descriptionController.text,
          prixAchat: double.parse(_prixAchatController.text),
          prixVente: double.parse(_prixVenteController.text),
          stock: int.parse(_stockController.text),
          seuilAlerte: int.parse(_seuilController.text),
          categorieId: categorieId!,
          fournisseurId: fournisseurId!,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("Produit mis à jour avec succès"),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, updatedProduct);
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
          "Modifier le produit",
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
                      Icons.inventory_2_outlined,
                      size: 48,
                      color: Color(0xFF4361EE),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Modifier le produit",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Mettez à jour les informations du produit",
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
                        controller: _nomController,
                        decoration: InputDecoration(
                          labelText: "Nom du produit",
                          hintText: "Entrez le nom du produit",
                          prefixIcon: const Icon(Icons.label_outline, color: Color(0xFF64748B)),
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
                      ),
                      const SizedBox(height: 20),

                      // Champ Description
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: "Description",
                          hintText: "Entrez une description du produit",
                          prefixIcon: const Icon(Icons.description_outlined, color: Color(0xFF64748B)),
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
                      ),
                      const SizedBox(height: 20),

                      // Champ Prix d'achat
                      TextFormField(
                        controller: _prixAchatController,
                        decoration: InputDecoration(
                          labelText: "Prix d'achat",
                          hintText: "Entrez le prix d'achat",
                          prefixIcon: const Icon(Icons.shopping_cart_outlined, color: Color(0xFF64748B)),
                          suffixText: "FCFA",
                          suffixStyle: TextStyle(color: isDarkMode ? Colors.grey[500] : Colors.grey[600]),
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
                        keyboardType: TextInputType.number,
                        validator: (val) => val == null || val.isEmpty ? "Prix requis" : null,
                      ),
                      const SizedBox(height: 20),

                      // Champ Prix de vente
                      TextFormField(
                        controller: _prixVenteController,
                        decoration: InputDecoration(
                          labelText: "Prix de vente",
                          hintText: "Entrez le prix de vente",
                          prefixIcon: const Icon(Icons.attach_money_outlined, color: Color(0xFF64748B)),
                          suffixText: "FCFA",
                          suffixStyle: TextStyle(color: isDarkMode ? Colors.grey[500] : Colors.grey[600]),
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
                        keyboardType: TextInputType.number,
                        validator: (val) {
                          if (val == null || val.isEmpty) return "Prix requis";
                          final prixVente = double.tryParse(val) ?? 0;
                          final prixAchat = double.tryParse(_prixAchatController.text) ?? 0;
                          if (prixVente < prixAchat) {
                            return "Le prix de vente doit être supérieur ou égal au prix d'achat";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Champ Stock
                      TextFormField(
                        controller: _stockController,
                        decoration: InputDecoration(
                          labelText: "Stock",
                          hintText: "Entrez la quantité en stock",
                          prefixIcon: const Icon(Icons.inventory_outlined, color: Color(0xFF64748B)),
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
                        keyboardType: TextInputType.number,
                        validator: (val) => val == null || val.isEmpty ? "Stock requis" : null,
                      ),
                      const SizedBox(height: 20),

                      // Champ Seuil d'alerte
                      TextFormField(
                        controller: _seuilController,
                        decoration: InputDecoration(
                          labelText: "Seuil d'alerte",
                          hintText: "Entrez le seuil d'alerte",
                          prefixIcon: const Icon(Icons.warning_outlined, color: Color(0xFF64748B)),
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
                        keyboardType: TextInputType.number,
                        validator: (val) => val == null || val.isEmpty ? "Seuil requis" : null,
                      ),
                      const SizedBox(height: 20),

                      // Catégorie
                      Container(
                        decoration: BoxDecoration(
                          color: isDarkMode ? const Color(0xFF334155) : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButtonFormField<String>(
                          value: categorieId,
                          decoration: const InputDecoration(
                            labelText: "Catégorie",
                            prefixIcon: Icon(Icons.category_outlined, color: Color(0xFF64748B)),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                          ),
                          items: widget.categories.map((c) {
                            return DropdownMenuItem(
                              value: c["id"].toString(),
                              child: Text(c["nom"]),
                            );
                          }).toList(),
                          onChanged: (val) => setState(() => categorieId = val),
                          dropdownColor: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
                          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Fournisseur
                      Container(
                        decoration: BoxDecoration(
                          color: isDarkMode ? const Color(0xFF334155) : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButtonFormField<String>(
                          value: fournisseurId,
                          decoration: const InputDecoration(
                            labelText: "Fournisseur",
                            prefixIcon: Icon(Icons.local_shipping_outlined, color: Color(0xFF64748B)),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                          ),
                          items: widget.fournisseurs.map((f) {
                            return DropdownMenuItem(
                              value: f["id"].toString(),
                              child: Text(f["nom"]),
                            );
                          }).toList(),
                          onChanged: (val) => setState(() => fournisseurId = val),
                          dropdownColor: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
                          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Boutons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: loading ? null : _updateProduct,
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