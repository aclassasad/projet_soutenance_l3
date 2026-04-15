import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dashboard_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  const envFile = String.fromEnvironment('ENV', defaultValue: '.env.local');
  await dotenv.load(fileName: envFile);
  runApp(const SecureStoreApp());
}

class SecureStoreApp extends StatelessWidget {
  const SecureStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "SecureStore Pro",
      navigatorKey: navigatorKey,
      theme: ThemeData.light().copyWith(
        primaryColor: const Color(0xFF4361EE),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Color(0xFF64748B)),
        ),
        cardTheme: const CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          clipBehavior: Clip.antiAlias,
        ),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF4361EE),
          secondary: Color(0xFF06B6D4),
          surface: Colors.white,
        ),
      ),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      initialRoute: "/dashboard",
      routes: {
        "/dashboard": (context) => const DashboardPage(),
      },
    );
  }
}

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
  }

  Future<void> _loadDashboard() async {
    try {
      final data = await DashboardService.getDashboardStats();
      setState(() {
        stats = data;
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: Color(0xFF4361EE)),
              const SizedBox(height: 16),
              Text(
                "Chargement du tableau de bord...",
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title:  const Text(
              "Dashboard",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header avec bienvenue
           
            const SizedBox(height: 4),
            Text(
              "Welcome back! Here's what's happening today.",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 24),

            // Metrics Cards - Disposition verticale
            const Text(
              "Aperçu rapide",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 12),
            
            // Cartes métriques les unes au-dessus des autres
            _metricCard(
              "Total Revenue",
              "\$${stats?['total_revenu'] ?? 0}",
              "+12.5%",
              Icons.attach_money,
              const Color(0xFF10B981),
            ),
            const SizedBox(height: 12),
            
            _metricCard(
              "Categories",
              "${stats?['nombre_categories'] ?? 0}",
              "⚠️ Low stock",
              Icons.category,
              const Color(0xFFF59E0B),
            ),
            const SizedBox(height: 12),
            
            _metricCard(
              "Products in Stock",
              "${stats?['total_produits_stock'] ?? 0}",
              "-3.2%",
              Icons.inventory,
              const Color(0xFF4361EE),
            ),
            const SizedBox(height: 12),
            
            _metricCard(
              "Active Employees",
              "${stats?['employes_actifs'] ?? 0}",
              "+2",
              Icons.people,
              const Color(0xFF06B6D4),
            ),

            const SizedBox(height: 24),

            // Graphiques
            if (isMobile) ...[
              _buildChartCard(
                "Weekly Sales",
                _lineChart(stats?['weekly_sales_data'] ?? [8000, 6000, 4000, 2000, 8500, 9500, 7000]),
              ),
              const SizedBox(height: 16),
              _buildChartCard(
                "Store Traffic Today",
                _barChart(stats?['store_traffic'] ?? []),
              ),
            ] else ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildChartCard(
                      "Weekly Sales",
                      _lineChart(stats?['weekly_sales_data'] ?? [8000, 6000, 4000, 2000, 8500, 9500, 7000]),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildChartCard(
                      "Store Traffic Today",
                      _barChart(stats?['store_traffic'] ?? []),
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 24),

            // Alertes et Activités
            if (isMobile) ...[
              _buildSectionCard(
                "Recent Alerts",
                _alertsList(stats?['alerts'] ?? []),
                showViewAll: true,
              ),
              const SizedBox(height: 16),
              _buildSectionCard(
                "Recent Activity",
                _activityList(stats?['transactions_recentes'] ?? []),
                showViewAll: true,
              ),
            ] else ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildSectionCard(
                      "Recent Alerts",
                      _alertsList(stats?['alerts'] ?? []),
                      showViewAll: true,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSectionCard(
                      "Recent Activity",
                      _activityList(stats?['transactions_recentes'] ?? []),
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

  // Carte pour les métriques - Version verticale avec largeur pleine
  Widget _metricCard(String title, String value, String subtitle, IconData icon, Color color) {
    return Container(
      width: double.infinity,  // Prend toute la largeur
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: subtitle.contains('+') || subtitle.contains('⚠️')
                          ? color
                          : subtitle.contains('-')
                              ? Colors.red
                              : color,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color, size: 30),
            ),
          ],
        ),
      ),
    );
  }

  // Carte pour les graphiques
  Widget _buildChartCard(String title, Widget chart) {
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
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
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

  // Graphique linéaire
  Widget _lineChart(List<dynamic> data) {
    final salesData = data.map((e) => (e as num).toDouble()).toList();
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value >= 0 && value < days.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      days[value.toInt()],
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

// Graphique à barres - CORRIGÉ
Widget _barChart(List<dynamic> traffic) {
  // Vérifier si traffic est vide
  if (traffic.isEmpty) {
    return const Center(
      child: Text(
        "Aucune donnée disponible",
        style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
      ),
    );
  }

  // Extraire les valeurs et les heures de manière sécurisée
  final List<double> values = [];
  final List<String> hours = [];

  for (var item in traffic) {
    if (item != null && item.containsKey('value') && item.containsKey('hour')) {
      final value = item['value'];
      final hour = item['hour'];
      if (value != null && hour != null) {
        values.add((value is num ? value : 0).toDouble());
        hours.add(hour.toString());
      }
    }
  }

  // Vérifier si on a des données valides
  if (values.isEmpty) {
    return const Center(
      child: Text(
        "Données invalides",
        style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
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

  // Carte pour les sections (alertes, activités)
  Widget _buildSectionCard(String title, Widget content, {bool showViewAll = false}) {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
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
                      "View All",
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
  Widget _alertsList(List<dynamic> alerts) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: alerts.length > 4 ? 4 : alerts.length,
      separatorBuilder: (_, _) => const Divider(height: 16),
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
                    a['text'] ?? "No text",
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    a['time'] ?? "",
                    style: const TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF94A3B8), size: 18),
          ],
        );
      },
    );
  }

  // Liste des activités
  Widget _activityList(List<dynamic> transactions) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: transactions.length > 4 ? 4 : transactions.length,
      separatorBuilder: (_, _) => const Divider(height: 16),
      itemBuilder: (context, i) {
        final t = transactions[i];
        return InkWell(
          onTap: () => _showSaleDetails(t),
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
                      "Sale Transaction • ${t['user']?['name'] ?? 'Unknown'}",
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "\$${t['total'] ?? 0}",
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                _formatTime(t['created_at'] ?? ""),
                style: const TextStyle(
                  color: Color(0xFF94A3B8),
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
  void _showSaleDetails(Map<String, dynamic> vente) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),
            _buildDetailRow("Caissier", vente['user']?['name'] ?? 'Unknown'),
            _buildDetailRow("Date", vente['created_at'] ?? ''),
            _buildDetailRow("Total", "\$${vente['total'] ?? 0}"),
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
                      style: const TextStyle(fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      "${ligne['quantite'] ?? 0} x ${ligne['prix_unitaire'] ?? 0}",
                      style: const TextStyle(fontSize: 13),
                      textAlign: TextAlign.end,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      "= ${ligne['sous_total'] ?? 0}",
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(
              "$label :",
              style: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
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