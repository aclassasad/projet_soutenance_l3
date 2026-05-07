import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dashboard_service.dart';
import 'loading_widget.dart';
import 'theme_provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Map<String, dynamic>? stats;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboard();
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

  Future<void> _loadDashboard() async {
    try {
      final data = await DashboardService.getDashboardStats();
      debugPrint("Données reçues: ${data?.keys}");
      setState(() {
        stats = data;
        loading = false;
      });
    } catch (e) {
      debugPrint("Erreur: $e");
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
    if (loading || stats == null) {
      return const LoadingWidget(
        message: "Chargement du dashboard...",
        backgroundColor: Color(0xFF4361EE),
      );
    }

    final isMobile = MediaQuery.of(context).size.width < 600;
    final isDarkMode = ThemeProvider.instance.themeMode == 'dark';

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          "Tableau de bord",
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
            onPressed: _loadDashboard,
            tooltip: "Actualiser",
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Message de bienvenue
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                "Bonjour ! Voici l'activité du jour.",
                style: TextStyle(
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ),

            const SizedBox(height: 24),

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
            
            // Cartes métriques
            _metricCard(
              "Chiffre d'affaires",
              "${_formatNumber(stats?['total_revenu'] ?? 0)} FCFA",
              "",
              Icons.attach_money,
              const Color(0xFF10B981),
              isDarkMode,
            ),
            const SizedBox(height: 12),
            
            _metricCard(
              "Catégories",
              "${_formatNumber(stats?['nombre_categories'] ?? 0)}",
              "⚠️ Stock faible",
              Icons.category,
              const Color(0xFFF59E0B),
              isDarkMode,
            ),
            const SizedBox(height: 12),
            
            _metricCard(
              "Produits en stock",
              "${_formatNumber(stats?['total_produits_stock'] ?? 0)}",
              "-3.2%",
              Icons.inventory,
              const Color(0xFF4361EE),
              isDarkMode,
            ),
            const SizedBox(height: 12),
            
            _metricCard(
              "Employés actifs",
              "${_formatNumber(stats?['employes_actifs'] ?? 0)}",
              "+2",
              Icons.people,
              const Color(0xFF06B6D4),
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
                    "Analyses",
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

            if (isMobile) ...[
              _buildChartCard(
                "Ventes hebdomadaires",
                _lineChart(isDarkMode),
                isDarkMode,
              ),
              const SizedBox(height: 16),
              _buildChartCard(
                "Fréquentation du magasin",
                _barChart(isDarkMode),
                isDarkMode,
              ),
            ] else ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildChartCard(
                      "Ventes hebdomadaires",
                      _lineChart(isDarkMode),
                      isDarkMode,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildChartCard(
                      "Fréquentation du magasin",
                      _barChart(isDarkMode),
                      isDarkMode,
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 24),

            // Section alertes et activités
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
                    "Flux d'activité",
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

            if (isMobile) ...[
              _buildSectionCard(
                "Alertes récentes",
                _alertsList(isDarkMode),
                isDarkMode,
                showViewAll: true,
              ),
              const SizedBox(height: 16),
              _buildSectionCard(
                "Activité récente",
                _activityList(isDarkMode),
                isDarkMode,
                showViewAll: true,
              ),
            ] else ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildSectionCard(
                      "Alertes récentes",
                      _alertsList(isDarkMode),
                      isDarkMode,
                      showViewAll: true,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSectionCard(
                      "Activité récente",
                      _activityList(isDarkMode),
                      isDarkMode,
                      showViewAll: true,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatNumber(dynamic value) {
    if (value == null) return "0";
    if (value is int) return value.toString();
    if (value is double) return value.toStringAsFixed(0);
    return value.toString();
  }

  // Carte métrique améliorée
  Widget _metricCard(String title, String value, String subtitle, IconData icon, Color color, bool isDarkMode) {
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isDarkMode ? Colors.grey[400] : const Color(0xFF64748B),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: (subtitle.contains('+') || subtitle.contains('⚠️'))
                          ? color.withOpacity(0.1)
                          : subtitle.contains('-')
                              ? Colors.red.withOpacity(0.1)
                              : color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      subtitle,
                      style: TextStyle(
                        color: (subtitle.contains('+') || subtitle.contains('⚠️'))
                            ? color
                            : subtitle.contains('-')
                                ? Colors.red
                                : color,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [color, color.withOpacity(0.7)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
          ],
        ),
      ),
    );
  }

  // Carte pour les graphiques
  Widget _buildChartCard(String title, Widget chart, bool isDarkMode) {
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
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.white : const Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: chart,
            ),
          ],
        ),
      ),
    );
  }

  // Graphique linéaire - avec données de test si nécessaire
  Widget _lineChart(bool isDarkMode) {
    // Récupérer les données ou utiliser des données de test
    List<dynamic> weeklyData = stats?['weekly_sales_data'];
    
    if (weeklyData == null || weeklyData.isEmpty) {
      // Données de test
      weeklyData = [8000, 6000, 4000, 2000, 8500, 9500, 7000];
    }
    
    final salesData = weeklyData.map((e) {
      if (e is num) return e.toDouble();
      if (e is String) return double.tryParse(e) ?? 0.0;
      return 0.0;
    }).toList();
    
    final days = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < days.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      days[index],
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
            spots: List.generate(
              salesData.length,
              (i) => FlSpot(i.toDouble(), salesData[i]),
            ),
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
                  radius: 3,
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

  // Graphique à barres - avec données de test si nécessaire
  Widget _barChart(bool isDarkMode) {
    List<dynamic> traffic = stats?['store_traffic'] ?? [];
    
    if (traffic.isEmpty) {
      // Données de test
      traffic = [
        {'hour': '9AM', 'value': 160},
        {'hour': '11AM', 'value': 120},
        {'hour': '1PM', 'value': 80},
        {'hour': '3PM', 'value': 40},
        {'hour': '5PM', 'value': 140},
        {'hour': '7PM', 'value': 90},
      ];
    }

    final List<double> values = [];
    final List<String> hours = [];

    for (var item in traffic) {
      if (item is Map) {
        var value = item['value'];
        var hour = item['hour'];
        if (value != null && hour != null) {
          double numValue = 0;
          if (value is num) numValue = value.toDouble();
          else if (value is String) numValue = double.tryParse(value) ?? 0;
          values.add(numValue);
          hours.add(hour.toString());
        }
      }
    }

    if (values.isEmpty) {
      return Center(
        child: Text(
          "Aucune donnée disponible",
          style: TextStyle(color: isDarkMode ? Colors.grey[500] : const Color(0xFF94A3B8), fontSize: 12),
        ),
      );
    }

    return BarChart(
      BarChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < hours.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      hours[index],
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
        barGroups: List.generate(
          values.length,
          (i) => BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: values[i],
                color: const Color(0xFF06B6D4),
                width: 20,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Carte pour les sections
  Widget _buildSectionCard(String title, Widget content, bool isDarkMode, {bool showViewAll = false}) {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
                if (showViewAll)
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(50, 30),
                    ),
                    child: const Text(
                      "Voir tout",
                      style: TextStyle(
                        color: Color(0xFF4361EE),
                        fontSize: 13,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            content,
          ],
        ),
      ),
    );
  }

  // Liste des alertes
  Widget _alertsList(bool isDarkMode) {
    List<dynamic> alerts = stats?['alerts'] ?? [];
    
    if (alerts.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            "Aucune alerte récente",
            style: TextStyle(color: isDarkMode ? Colors.grey[500] : const Color(0xFF94A3B8)),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: alerts.length > 4 ? 4 : alerts.length,
      separatorBuilder: (_, __) => const Divider(height: 16),
      itemBuilder: (context, i) {
        final a = alerts[i];
        return Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: _mapColor(a['color'] ?? "grey"),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    a['text'] ?? "Aucun message",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isDarkMode ? Colors.white : const Color(0xFF1E293B),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    a['time'] ?? "",
                    style: TextStyle(
                      color: isDarkMode ? Colors.grey[400] : const Color(0xFF94A3B8),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: isDarkMode ? Colors.grey[400] : const Color(0xFF94A3B8), size: 18),
          ],
        );
      },
    );
  }

  // Liste des activités
  Widget _activityList(bool isDarkMode) {
    List<dynamic> transactions = stats?['transactions_recentes'] ?? [];
    
    if (transactions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            "Aucune activité récente",
            style: TextStyle(color: isDarkMode ? Colors.grey[500] : const Color(0xFF94A3B8)),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: transactions.length > 4 ? 4 : transactions.length,
      separatorBuilder: (_, __) => const Divider(height: 16),
      itemBuilder: (context, i) {
        final t = transactions[i];
        return InkWell(
          onTap: () => _showSaleDetails(t, isDarkMode),
          borderRadius: BorderRadius.circular(8),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF4361EE),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Vente • ${t['user']?['name'] ?? 'Inconnu'}",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isDarkMode ? Colors.white : const Color(0xFF1E293B),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "${_formatNumber(t['total'])} FCFA",
                      style: TextStyle(
                        color: isDarkMode ? Colors.grey[400] : const Color(0xFF64748B),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                _formatTime(t['created_at'] ?? ""),
                style: TextStyle(
                  color: isDarkMode ? Colors.grey[500] : const Color(0xFF94A3B8),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Formatage du temps
  String _formatTime(String dateTime) {
    if (dateTime.isEmpty) return "";
    try {
      if (dateTime.contains('T')) {
        final timePart = dateTime.split('T')[1].substring(0, 5);
        return timePart;
      }
      return dateTime;
    } catch (e) {
      return dateTime;
    }
  }

  // Détails de la vente
  void _showSaleDetails(Map<String, dynamic> vente, bool isDarkMode) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Vente #${vente['id'] ?? ''}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: isDarkMode ? Colors.grey[400] : const Color(0xFF64748B)),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),
            _buildDetailRow("Caissier", vente['user']?['name'] ?? 'Inconnu', isDarkMode),
            _buildDetailRow("Date", vente['created_at'] ?? '', isDarkMode),
            _buildDetailRow("Total", "${_formatNumber(vente['total'])} FCFA", isDarkMode),
            const SizedBox(height: 16),
            const Text(
              "Produits :",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            ...(vente['lignes'] ?? []).map<Widget>((ligne) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      ligne['produit']?['nom'] ?? 'Produit inconnu',
                      style: TextStyle(fontSize: 13, color: isDarkMode ? Colors.grey[300] : const Color(0xFF1E293B)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      "${ligne['quantite'] ?? 0} x ${ligne['prix_unitaire'] ?? 0}",
                      style: TextStyle(fontSize: 13, color: isDarkMode ? Colors.grey[400] : const Color(0xFF64748B)),
                      textAlign: TextAlign.end,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      "= ${_formatNumber(ligne['sous_total'])}",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isDarkMode ? Colors.grey[300] : const Color(0xFF1E293B),
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            )),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4361EE),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text("Fermer"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(
              "$label :",
              style: TextStyle(color: isDarkMode ? Colors.grey[400] : const Color(0xFF64748B), fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: isDarkMode ? Colors.white : const Color(0xFF1E293B)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // Mapper les couleurs
  Color _mapColor(String color) {
    switch (color.toLowerCase()) {
      case "red":
        return Colors.red;
      case "orange":
        return Colors.orange;
      case "green":
        return Colors.green;
      case "blue":
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
