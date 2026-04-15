import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'sales_service.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({super.key});

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  Map<String, dynamic>? stats;
  List<Map<String, dynamic>> categories = [];
  List<Map<String, dynamic>> topProducts = [];
  List<Map<String, dynamic>> revenueTrend = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadSalesData();
  }

  Future<void> _loadSalesData() async {
    try {
      final statsData = await SalesService.getSalesStats();
      final categoriesData = await SalesService.getSalesByCategory();
      final topProductsData = await SalesService.getTopProducts();
      final revenueTrendData = await SalesService.getRevenueTrend();

      setState(() {
        stats = statsData;
        categories = categoriesData;
        topProducts = topProductsData;
        revenueTrend = revenueTrendData;
        loading = false;
      });
    } catch (e) {
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

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: Color(0xFF4361EE)),
              const SizedBox(height: 16),
              Text(
                "Chargement des statistiques...",
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          "Sales Analytics",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_outlined, color: Color(0xFF64748B)),
            onPressed: _loadSalesData,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sous-titre
            Text(
              "Track your store's sales performance",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 20),

            // KPIs - Disposition verticale
            const Text(
              "Aperçu des ventes",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 12),

            _buildKpiCard(
              "Total Revenue",
              "\$${_formatNumber(stats?['total_revenu'] ?? 0)}",
              "+15.3%",
              Icons.attach_money,
              const Color(0xFF4361EE),
            ),
            const SizedBox(height: 10),

            _buildKpiCard(
              "Total Orders",
              _formatNumber(stats?['total_commandes'] ?? 0),
              "+8.2%",
              Icons.shopping_cart,
              const Color(0xFF06B6D4),
            ),
            const SizedBox(height: 10),

            _buildKpiCard(
              "Avg. Order Value",
              "\$${_formatNumber(stats?['moyenne_commande'] ?? 0)}",
              "+6.5%",
              Icons.receipt,
              const Color(0xFF10B981),
            ),
            const SizedBox(height: 10),

            _buildKpiCard(
              "Unique Customers",
              _formatNumber(stats?['clients_uniques'] ?? 0),
              "+12.1%",
              Icons.people,
              const Color(0xFFF59E0B),
            ),

            const SizedBox(height: 24),

            // Revenue Trend Chart
            _buildSectionTitle("Revenue Trend"),
            const SizedBox(height: 12),
            _buildChartCard(
              _buildLineChart(),
            ),

            const SizedBox(height: 24),

            // Sales by Category - Version mobile optimisée
            _buildSectionTitle("Sales by Category"),
            const SizedBox(height: 12),
            _buildMobileCategoryChart(),

            const SizedBox(height: 24),

            // Top Selling Products
            _buildSectionTitle("Top Selling Products"),
            const SizedBox(height: 12),
            _buildTopProductsCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF4361EE).withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            "Cette année",
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF4361EE),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  String _formatNumber(dynamic value) {
    if (value == null) return "0";
    if (value is int) {
      return value.toString();
    } else if (value is double) {
      return value.toStringAsFixed(0);
    }
    return value.toString();
  }

  Widget _buildKpiCard(
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Container(
      width: double.infinity,
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
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      subtitle,
                      style: TextStyle(
                        color: color,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 26),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard(Widget chart) {
    return Container(
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
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 220,
          child: chart,
        ),
      ),
    );
  }

  Widget _buildLineChart() {
    if (revenueTrend.isEmpty) {
      return const Center(
        child: Text(
          "Aucune donnée disponible",
          style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
        ),
      );
    }

    // Créer les spots sans utiliser asMap()
    final spots = <FlSpot>[];
    for (int i = 0; i < revenueTrend.length; i++) {
      spots.add(FlSpot(
        i.toDouble(),
        (revenueTrend[i]['revenu'] as num?)?.toDouble() ?? 0,
      ));
    }

    final maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    final interval = (maxY / 4).ceilToDouble();

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          drawVerticalLine: false,
          horizontalInterval: interval,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.shade200,
              strokeWidth: 1,
              dashArray: [5, 5],
            );
          },
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: interval,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 10,
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < revenueTrend.length) {
                  final mois = revenueTrend[index]['mois']?.toString() ?? '';
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      mois.length > 3 ? mois.substring(0, 3) : mois,
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 10,
                      ),
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: const Color(0xFF4361EE),
            barWidth: 3,
            belowBarData: BarAreaData(
              show: true,
              color: const Color(0xFF4361EE).withOpacity(0.1),
            ),
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: Colors.white,
                  strokeWidth: 2,
                  strokeColor: const Color(0xFF4361EE),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Version mobile optimisée pour Sales by Category
  Widget _buildMobileCategoryChart() {
    if (categories.isEmpty) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text(
            "Aucune donnée disponible",
            style: TextStyle(color: Color(0xFF94A3B8)),
          ),
        ),
      );
    }

    final total = categories.fold(0.0, (sum, c) => sum + ((c['revenu'] as num?)?.toDouble() ?? 0));
    
    // Palette de couleurs harmonisée
    final colors = [
      const Color(0xFF4361EE), // Bleu
      const Color(0xFF06B6D4), // Cyan
      const Color(0xFF10B981), // Vert
      const Color(0xFFF59E0B), // Orange
      const Color(0xFFEF4444), // Rouge
      const Color(0xFF8B5CF6), // Violet
    ];

    // Prendre les 5 premières catégories
    final displayedCategories = categories.take(5).toList();

    return Container(
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
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Barres horizontales pour les catégories
            ...List.generate(displayedCategories.length, (index) {
              final category = displayedCategories[index];
              final value = (category['revenu'] as num?)?.toDouble() ?? 0;
              final percentage = total > 0 ? (value / total * 100) : 0;
              final color = colors[index % colors.length];
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    // Indicateur de couleur
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(width: 10),
                    
                    // Nom de la catégorie
                    SizedBox(
                      width: 100,
                      child: Text(
                        category['nom'] ?? "Sans nom",
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    
                    const SizedBox(width: 10),
                    
                    // Barre de progression
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Container(
                                height: 8,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              Container(
                                height: 8,
                                width: percentage * 2.5, // Échelle pour mobile
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${percentage.toStringAsFixed(1)}%",
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              Text(
                                "\$${value.toStringAsFixed(0)}",
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
            
            if (categories.length > 5)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  "+ ${categories.length - 5} autres catégories",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              
            const SizedBox(height: 8),
            
            // Total
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF4361EE).withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total des ventes",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  Text(
                    "\$${total.toStringAsFixed(0)}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4361EE),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopProductsCard() {
    return Container(
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête du tableau
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade200),
                ),
              ),
              child: const Row(
                children: [
                  Expanded(flex: 1, child: Text("Rank", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: Color(0xFF64748B)))),
                  Expanded(flex: 3, child: Text("Product", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: Color(0xFF64748B)))),
                  Expanded(flex: 2, child: Text("Sold", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: Color(0xFF64748B)))),
                  Expanded(flex: 2, child: Text("Revenue", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: Color(0xFF64748B)))),
                ],
              ),
            ),

            // Lignes du tableau
            ...topProducts.isEmpty 
              ? [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text(
                        "Aucun produit trouvé",
                        style: TextStyle(color: Color(0xFF94A3B8)),
                      ),
                    ),
                  )
                ]
              : List.generate(topProducts.length > 5 ? 5 : topProducts.length, (index) {
                  final p = topProducts[index];
                  final revenue = (p['revenue'] as num?)?.toDouble() ?? 0.0;

                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      border: index < (topProducts.length > 5 ? 4 : topProducts.length - 1)
                          ? Border(bottom: BorderSide(color: Colors.grey.shade100))
                          : null,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: index == 0 
                                  ? const Color(0xFFF59E0B).withOpacity(0.1)
                                  : index == 1
                                      ? Colors.grey.withOpacity(0.1)
                                      : index == 2
                                          ? Colors.brown.withOpacity(0.1)
                                          : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                "${index + 1}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: index == 0
                                      ? const Color(0xFFF59E0B)
                                      : index == 1
                                          ? Colors.grey
                                          : index == 2
                                              ? Colors.brown
                                              : const Color(0xFF64748B),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            p['nom'] ?? "Sans nom",
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            "${p['units'] ?? 0}",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            "\$${revenue.toStringAsFixed(0)}",
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF10B981),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}