import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'sales_service.dart';
import 'loading_widget.dart';
import 'theme_provider.dart';

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
    final isDarkMode = ThemeProvider.instance.themeMode == 'dark';
    
    if (loading || stats == null) {
      return const LoadingWidget(
        message: "Chargement des ventes...",
        backgroundColor: Color(0xFF4361EE),
      );
    }

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          "Analyses des ventes",
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
            icon: Icon(Icons.refresh_outlined, color: isDarkMode ? Colors.grey[400] : const Color(0xFF64748B)),
            onPressed: _loadSalesData,
            tooltip: "Actualiser",
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
              "Suivez les performances de vos ventes",
              style: TextStyle(
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 20),

            // Section indicateurs clés
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
                    "Indicateurs clés",
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

            _buildKpiCard(
              "Chiffre d'affaires",
              "${_formatNumber(stats?['total_revenu'] ?? 0)} FCFA",
              "+15.3%",
              Icons.attach_money,
              const Color(0xFF4361EE),
              isDarkMode,
            ),
            const SizedBox(height: 10),

            _buildKpiCard(
              "Commandes totales",
              _formatNumber(stats?['total_commandes'] ?? 0),
              "+8.2%",
              Icons.shopping_cart,
              const Color(0xFF06B6D4),
              isDarkMode,
            ),
            const SizedBox(height: 10),

            _buildKpiCard(
              "Panier moyen",
              "${_formatNumber(stats?['moyenne_commande'] ?? 0)} FCFA",
              "+6.5%",
              Icons.receipt,
              const Color(0xFF10B981),
              isDarkMode,
            ),
            const SizedBox(height: 10),

            _buildKpiCard(
              "Clients uniques",
              _formatNumber(stats?['clients_uniques'] ?? 0),
              "+12.1%",
              Icons.people,
              const Color(0xFFF59E0B),
              isDarkMode,
            ),

            const SizedBox(height: 24),

            // Section graphiques
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
                    "Tendances",
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

            _buildChartCard(_buildLineChart(isDarkMode), isDarkMode),

            const SizedBox(height: 24),

            // Section ventes par catégorie
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
                    "Ventes par catégorie",
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

            _buildMobileCategoryChart(isDarkMode),

            const SizedBox(height: 24),

            // Section top produits
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
                    "Produits les plus vendus",
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

            _buildTopProductsCard(isDarkMode),
          ],
        ),
      ),
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
    bool isDarkMode,
  ) {
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
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
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
                  const SizedBox(height: 6),
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
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [color, color.withOpacity(0.7)],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: Colors.white, size: 26),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard(Widget chart, bool isDarkMode) {
    return Container(
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
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 220,
          child: chart,
        ),
      ),
    );
  }

  Widget _buildLineChart(bool isDarkMode) {
    if (revenueTrend.isEmpty) {
      return Center(
        child: Text(
          "Aucune donnée disponible",
          style: TextStyle(color: isDarkMode ? Colors.grey[500] : const Color(0xFF94A3B8), fontSize: 12),
        ),
      );
    }

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
              color: isDarkMode ? Colors.grey[800] : Colors.grey.shade200,
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
                  style: TextStyle(
                    color: isDarkMode ? Colors.grey[400] : const Color(0xFF64748B),
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
                      style: TextStyle(
                        color: isDarkMode ? Colors.grey[400] : const Color(0xFF64748B),
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
                  color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
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

  Widget _buildMobileCategoryChart(bool isDarkMode) {
    if (categories.isEmpty) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            "Aucune donnée disponible",
            style: TextStyle(color: isDarkMode ? Colors.grey[500] : const Color(0xFF94A3B8)),
          ),
        ),
      );
    }

    final total = categories.fold(0.0, (sum, c) => sum + ((c['revenu'] as num?)?.toDouble() ?? 0));
    
    final colors = [
      const Color(0xFF4361EE),
      const Color(0xFF06B6D4),
      const Color(0xFF10B981),
      const Color(0xFFF59E0B),
      const Color(0xFFEF4444),
      const Color(0xFF8B5CF6),
    ];

    final displayedCategories = categories.take(5).toList();

    return Container(
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
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ...List.generate(displayedCategories.length, (index) {
              final category = displayedCategories[index];
              final value = (category['revenu'] as num?)?.toDouble() ?? 0;
              final percentage = total > 0 ? (value / total * 100) : 0;
              final color = colors[index % colors.length];
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(width: 10),
                    
                    SizedBox(
                      width: 100,
                      child: Text(
                        category['nom'] ?? "Sans nom",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isDarkMode ? Colors.white : const Color(0xFF1E293B),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    
                    const SizedBox(width: 10),
                    
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Container(
                                height: 8,
                                decoration: BoxDecoration(
                                  color: isDarkMode ? Colors.grey[800] : Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              Container(
                                height: 8,
                                width: percentage * 2.5,
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
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: isDarkMode ? Colors.white : const Color(0xFF1E293B),
                                ),
                              ),
                              Text(
                                "${value.toStringAsFixed(0)} FCFA",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: isDarkMode ? Colors.grey[400] : const Color(0xFF64748B),
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
                  style: TextStyle(
                    fontSize: 12,
                    color: isDarkMode ? Colors.grey[400] : const Color(0xFF64748B),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              
            const SizedBox(height: 8),
            
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF4361EE).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total des ventes",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? Colors.white : const Color(0xFF1E293B),
                    ),
                  ),
                  Text(
                    "${total.toStringAsFixed(0)} FCFA",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF4361EE),
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

  Widget _buildTopProductsCard(bool isDarkMode) {
    return Container(
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: isDarkMode ? Colors.grey[800]! : Colors.grey.shade200),
                ),
              ),
              child: Row(
                children: [
                  Expanded(flex: 1, child: Text("Rang", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: isDarkMode ? Colors.grey[400] : const Color(0xFF64748B)))),
                  Expanded(flex: 3, child: Text("Produit", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: isDarkMode ? Colors.grey[400] : const Color(0xFF64748B)))),
                  Expanded(flex: 2, child: Text("Vendus", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: isDarkMode ? Colors.grey[400] : const Color(0xFF64748B)))),
                  Expanded(flex: 2, child: Text("Chiffre", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: isDarkMode ? Colors.grey[400] : const Color(0xFF64748B)))),
                ],
              ),
            ),

            ...topProducts.isEmpty 
              ? [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text(
                        "Aucun produit trouvé",
                        style: TextStyle(color: isDarkMode ? Colors.grey[500] : const Color(0xFF94A3B8)),
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
                          ? Border(bottom: BorderSide(color: isDarkMode ? Colors.grey[800]! : Colors.grey.shade100))
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
                                              : (isDarkMode ? Colors.grey[400] : const Color(0xFF64748B)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            p['nom'] ?? "Sans nom",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: isDarkMode ? Colors.white : const Color(0xFF1E293B),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            "${p['units'] ?? 0}",
                            style: TextStyle(
                              fontSize: 12,
                              color: isDarkMode ? Colors.grey[400] : const Color(0xFF64748B),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            "${revenue.toStringAsFixed(0)} FCFA",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF10B981),
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