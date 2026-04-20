import 'package:flutter/material.dart';
import 'inventory_service.dart';
import 'loading_widget.dart';
import 'theme_provider.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  Map<String, dynamic>? stats;
  List<Map<String, dynamic>> produits = [];
  List<Map<String, dynamic>> categories = [];
  List<Map<String, dynamic>> fournisseurs = [];
  bool loading = true;

  String searchText = "";
  int? selectedCategory;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
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

  Future<void> _loadInitialData() async {
    try {
      final statsData = await InventoryService.getInventoryStats();
      final categoriesData = await InventoryService.getCategories();
      final produitsData = await InventoryService.searchProduits();
      final fournisseursData = await InventoryService.getFournisseurs();

      setState(() {
        stats = statsData;
        categories = categoriesData;
        produits = produitsData;
        fournisseurs = fournisseursData;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
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
    }
  }

  Future<void> _loadInventory({String search = "", int? categorieId}) async {
    try {
      final produitsData = await InventoryService.searchProduits(
        search: search,
        categorieId: categorieId,
      );

      if (mounted) {
        setState(() {
          produits = produitsData;
          loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erreur: $e"),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _deleteProduct(int id, String nom) async {
    try {
      await InventoryService.deleteProduit(id);
      if (mounted) {
        setState(() {
          produits.removeWhere((p) => p["id"] == id);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Produit $nom supprimé"),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erreur suppression: $e"),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _getStatusText(int stock) {
    if (stock <= 0) return "RUPTURE";
    if (stock < 10) return "STOCK FAIBLE";
    return "EN STOCK";
  }

  Color _getStatusColor(int stock) {
    if (stock <= 0) return Colors.red;
    if (stock < 10) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    if (loading || stats == null) {
      return const LoadingWidget(
        message: "Chargement de l'inventaire...",
        backgroundColor: Color(0xFF4361EE),
      );
    }

    final isDarkMode = ThemeProvider.instance.themeMode == 'dark';

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          "Gestion de l'inventaire",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: isDarkMode ? Colors.grey[400] : const Color(0xFF64748B)),
            onPressed: () {},
            tooltip: "Notifications",
          ),
          IconButton(
            icon: Icon(Icons.settings_outlined, color: isDarkMode ? Colors.grey[400] : const Color(0xFF64748B)),
            onPressed: () {},
            tooltip: "Paramètres",
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sous-titre
                    Text(
                      "Gérez l'inventaire de votre magasin",
                      style: TextStyle(
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Titre des métriques
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 4,
                            height: 20,
                            decoration: BoxDecoration(
                              color: const Color(0xFF4361EE),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Aperçu de l'inventaire",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: isDarkMode ? Colors.white : const Color(0xFF1E293B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Cartes métriques
                    _buildMetricCard(
                      title: "Produits totaux",
                      value: (stats?['total_produits'] ?? 0).toString(),
                      subtitle: "Tous les produits",
                      icon: Icons.inventory,
                      color: const Color(0xFF4361EE),
                      isDarkMode: isDarkMode,
                    ),
                    const SizedBox(height: 12),

                    _buildMetricCard(
                      title: "Stock faible",
                      value: (stats?['low_stock'] ?? 0).toString(),
                      subtitle: "Produits en dessous du seuil",
                      icon: Icons.warning,
                      color: const Color(0xFFF59E0B),
                      isDarkMode: isDarkMode,
                    ),
                    const SizedBox(height: 12),

                    _buildMetricCard(
                      title: "Rupture de stock",
                      value: (stats?['out_of_stock'] ?? 0).toString(),
                      subtitle: "Produits en rupture",
                      icon: Icons.cancel,
                      color: Colors.red,
                      isDarkMode: isDarkMode,
                    ),
                    const SizedBox(height: 12),

                    _buildMetricCard(
                      title: "Valeur totale",
                      value: "${(double.tryParse(stats?['valeur_totale']?.toString() ?? '0') ?? 0.0).toStringAsFixed(2)} FCFA",
                      subtitle: "Valeur totale du stock",
                      icon: Icons.attach_money,
                      color: const Color(0xFF10B981),
                      isDarkMode: isDarkMode,
                    ),

                    const SizedBox(height: 20),

                    // Section Recherche et Filtres
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 4,
                            height: 20,
                            decoration: BoxDecoration(
                              color: const Color(0xFF4361EE),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Recherche et filtres",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: isDarkMode ? Colors.white : const Color(0xFF1E293B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    _buildSearchAndFilterSection(isDarkMode),

                    const SizedBox(height: 20),

                    // Liste des produits
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 4,
                            height: 20,
                            decoration: BoxDecoration(
                              color: const Color(0xFF4361EE),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Catalogue produits",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: isDarkMode ? Colors.white : const Color(0xFF1E293B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Liste des produits
                    produits.isEmpty
                        ? _buildEmptyState(isDarkMode)
                        : _buildProductList(isDarkMode),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget pour la carte métrique
  Widget _buildMetricCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isDarkMode,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.black.withOpacity(0.3) : color.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isDarkMode ? Colors.grey[400] : const Color(0xFF64748B),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : const Color(0xFF1E293B),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      subtitle,
                      style: TextStyle(
                        color: color,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [color, color.withOpacity(0.7)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
          ],
        ),
      ),
    );
  }

  // Widget pour la section recherche et filtres
  Widget _buildSearchAndFilterSection(bool isDarkMode) {
    return Container(
      width: double.infinity,
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
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Champ de recherche
            TextField(
              decoration: InputDecoration(
                hintText: "Rechercher un produit...",
                hintStyle: TextStyle(fontSize: 14, color: isDarkMode ? Colors.grey[400] : Colors.grey[600]),
                prefixIcon: Icon(Icons.search, size: 20, color: isDarkMode ? Colors.grey[400] : const Color(0xFF64748B)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: isDarkMode ? const Color(0xFF334155) : Colors.grey.shade50,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                isDense: true,
              ),
              style: TextStyle(fontSize: 14, color: isDarkMode ? Colors.white : Colors.black),
              onChanged: (val) {
                searchText = val;
                _loadInventory(search: searchText, categorieId: selectedCategory);
              },
            ),
            const SizedBox(height: 10),
            
            // Filtre par catégorie
            Container(
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xFF334155) : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int?>(
                  value: selectedCategory,
                  isExpanded: true,
                  hint: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      "Toutes les catégories",
                      style: TextStyle(fontSize: 14, color: isDarkMode ? Colors.grey[400] : Colors.grey[600]),
                    ),
                  ),
                  items: [
                    const DropdownMenuItem<int?>(
                      value: null,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text("Toutes les catégories", style: TextStyle(fontSize: 14)),
                      ),
                    ),
                    ...categories.map((c) => DropdownMenuItem<int?>(
                      value: c['id'],
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(c['nom'] ?? '', style: TextStyle(fontSize: 14)),
                      ),
                    )),
                  ],
                  onChanged: (val) {
                    setState(() {
                      selectedCategory = val;
                    });
                    _loadInventory(search: searchText, categorieId: selectedCategory);
                  },
                  dropdownColor: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
            
            // Menu Mon gestionnaire
            Container(
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xFF334155) : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      "Mon gestionnaire",
                      style: TextStyle(fontSize: 14, color: isDarkMode ? Colors.grey[400] : Colors.grey[600]),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: "produits",
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text("Gérer les produits", style: TextStyle(fontSize: 14)),
                      ),
                    ),
                    DropdownMenuItem(
                      value: "categories",
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text("Gérer les catégories", style: TextStyle(fontSize: 14)),
                      ),
                    ),
                    DropdownMenuItem(
                      value: "fournisseurs",
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text("Gérer les fournisseurs", style: TextStyle(fontSize: 14)),
                      ),
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null) Navigator.pushNamed(context, "/$val");
                  },
                  dropdownColor: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget pour l'état vide
  Widget _buildEmptyState(bool isDarkMode) {
    return SizedBox(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 64,
              color: isDarkMode ? Colors.grey[600] : Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              "Aucun produit trouvé",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[500],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Modifiez vos critères de recherche",
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.grey[500] : Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget pour la liste des produits
  Widget _buildProductList(bool isDarkMode) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: produits.length,
      itemBuilder: (context, index) {
        final p = produits[index];
        final stock = p['stock'] ?? 0;
        final statusText = _getStatusText(stock);
        final statusColor = _getStatusColor(stock);

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: isDarkMode ? Colors.black.withOpacity(0.3) : Colors.grey.withOpacity(0.05),
                blurRadius: 5,
                spreadRadius: 1,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Identifiant du produit
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4361EE).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      p['id']?.toString() ?? "0",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4361EE),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                
                // Informations du produit
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nom du produit
                      Text(
                        p['nom']?.toString() ?? "Sans nom",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: isDarkMode ? Colors.white : const Color(0xFF1E293B),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      
                      // Catégorie, stock et prix
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          _buildCompactChip(
                            Icons.category_outlined,
                            p['categorie']?['nom'] ?? 'N/A',
                            isDarkMode,
                          ),
                          _buildCompactChip(
                            Icons.inventory_2_outlined,
                            "Stock: $stock",
                            isDarkMode,
                          ),
                          _buildCompactChip(
                            Icons.attach_money_outlined,
                            "${p['prix_vente'] ?? '0'} FCFA",
                            isDarkMode,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      
                      // Badge de statut
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          statusText,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Menu d'actions
                PopupMenuButton<String>(
                  onSelected: (val) async {
                    if (val == "edit") {
                      final updatedProduct = await Navigator.pushNamed(
                        context,
                        "/produits/edit",
                        arguments: {
                          "produit": p,
                          "categories": categories,
                          "fournisseurs": fournisseurs,
                        },
                      );

                      if (updatedProduct != null && updatedProduct is Map<String, dynamic> && mounted) {
                        setState(() {
                          final index = produits.indexWhere((prod) => prod["id"] == updatedProduct["id"]);
                          if (index != -1) {
                            produits[index] = updatedProduct;
                          }
                        });
                      }
                    } else if (val == "delete") {
                      _showDeleteConfirmation(p['id'], p['nom']);
                    }
                  },
                  icon: Icon(Icons.more_vert, size: 20, color: isDarkMode ? Colors.grey[400] : const Color(0xFF64748B)),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: "edit",
                      height: 36,
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 16, color: Color(0xFF4361EE)),
                          SizedBox(width: 8),
                          Text("Modifier", style: TextStyle(fontSize: 13)),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: "delete",
                      height: 36,
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 16, color: Colors.red),
                          SizedBox(width: 8),
                          Text("Supprimer", style: TextStyle(fontSize: 13)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Widget pour les chips compacts
  Widget _buildCompactChip(IconData icon, String label, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF334155) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: isDarkMode ? Colors.grey[400] : const Color(0xFF64748B)),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isDarkMode ? Colors.grey[400] : const Color(0xFF64748B),
            ),
            maxLines: 1,
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteConfirmation(int id, String nom) async {
    final isDarkMode = ThemeProvider.instance.themeMode == 'dark';
    
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        title: Text(
          "Confirmer la suppression",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : const Color(0xFF1E293B),
          ),
        ),
        content: Text(
          "Voulez-vous vraiment supprimer le produit '$nom' ?",
          style: TextStyle(fontSize: 14, color: isDarkMode ? Colors.grey[300] : Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: Text("Annuler", style: TextStyle(fontSize: 14, color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteProduct(id, nom);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text("Supprimer", style: TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }
}