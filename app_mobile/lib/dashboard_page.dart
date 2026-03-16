import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dashboard_service.dart';

// Global navigator key pour showDialog
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const SecureStoreApp());
}

class SecureStoreApp extends StatelessWidget {
  const SecureStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "SecureStore Pro",
      navigatorKey: navigatorKey,
      theme: ThemeData.light(),
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
        SnackBar(content: Text("Erreur: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text("Dashboard", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text("Welcome back! Here's what's happening today.", style: TextStyle(color: Colors.grey)),

          // Metrics Cards
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              _metricCard("Total Revenue", "\$${stats?['total_revenu'] ?? 0}", Colors.green, Icons.attach_money, "+12.5%"),
              _metricCard("Categories", "${stats?['nombre_categories'] ?? 0}", Colors.orange, Icons.category, "⚠️ Some low stock"),
              _metricCard("Products in Stock", "${stats?['total_produits_stock'] ?? 0}", Colors.blue, Icons.inventory, "-3.2%"),
              _metricCard("Active Employees", "${stats?['employes_actifs'] ?? 0}", Colors.teal, Icons.people, "+2"),
            ],
          ),

          // Graphs
          const SizedBox(height: 24),
          Row(children: [
            Expanded(child: _lineChartCard("Weekly Sales", stats?['weekly_sales_labels'] ?? [], stats?['weekly_sales_data'] ?? [])),
            const SizedBox(width: 12),
            Expanded(child: _barChartCard("Store Traffic Today", stats?['store_traffic'] ?? [])),
          ]),

          // Alerts & Activity
          const SizedBox(height: 24),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: _alertsCard(stats?['alerts'] ?? [])),
            const SizedBox(width: 12),
            Expanded(child: _activityCard(stats?['transactions_recentes'] ?? [])),
          ]),
        ]),
      ),
    );
  }

  // Metric Card
  Widget _metricCard(String title, String value, Color color, IconData icon, String subtitle) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 6),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(subtitle, style: TextStyle(color: color)),
          ]),
          CircleAvatar(backgroundColor: color.withOpacity(0.1), child: Icon(icon, color: color)),
        ]),
      ),
    );
  }

  // Line Chart
  Widget _lineChartCard(String title, List<dynamic> labels, List<dynamic> data) {
    final salesData = (data).cast<double>();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          SizedBox(
            height: 200,
            child: LineChart(LineChartData(
              titlesData: FlTitlesData(show: true),
              lineBarsData: [
                LineChartBarData(
                  spots: List.generate(salesData.length, (i) => FlSpot(i.toDouble(), salesData[i])),
                  isCurved: true,
                  color: Colors.indigo,
                  barWidth: 3,
                  belowBarData: BarAreaData(show: true, color: Colors.indigo.withOpacity(0.1)),
                )
              ],
            )),
          ),
        ]),
      ),
    );
  }

  // Bar Chart
  Widget _barChartCard(String title, List<dynamic> traffic) {
    final trafficData = traffic;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          SizedBox(
            height: 200,
            child: BarChart(BarChartData(
              titlesData: FlTitlesData(show: true),
              barGroups: List.generate(
                trafficData.length,
                (i) => BarChartGroupData(
                  x: i,
                  barRods: [BarChartRodData(toY: (trafficData[i]['value'] as num).toDouble(), color: Colors.cyan)],
                ),
              ),
            )),
          ),
        ]),
      ),
    );
  }

  // Alerts
  Widget _alertsCard(List<dynamic> alerts) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: alerts.map((a) => ListTile(
            leading: Icon(Icons.warning, color: _mapColor(a['color'] ?? "grey")),
            title: Text(a['text'] ?? "No text"),
            subtitle: Text(a['time'] ?? ""),
          )).toList(),
        ),
      ),
    );
  }

  // Activity
  Widget _activityCard(List<dynamic> transactions) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: transactions.map((t) => ListTile(
            leading: const Icon(Icons.circle, color: Colors.blue, size: 10),
            title: Text("Sale Transaction • ${t['user']?['name'] ?? 'Unknown'}"),
            subtitle: Text("\$${t['total'] ?? 0}"),
            trailing: Text(t['created_at'] ?? ""),
            onTap: () => _showSaleDetails(t),
          )).toList(),
        ),
      ),
    );
  }

  void _showSaleDetails(Map<String, dynamic> vente) {
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (_) => AlertDialog(
        title: Text("Détails de la vente #${vente['id'] ?? ''}"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Caissier : ${vente['user']?['name'] ?? 'Unknown'}"),
            Text("Date : ${vente['created_at'] ?? ''}"),
            Text("Total : \$${vente['total'] ?? 0}"),
            const SizedBox(height: 12),
            const Text("Produits :"),
            ...(vente['lignes'] ?? []).map<Widget>((ligne) => ListTile(
              title: Text(ligne['produit']?['nom'] ?? 'Produit inconnu'),
              subtitle: Text("${ligne['quantite'] ?? 0} x ${ligne['prix_unitaire'] ?? 0} = ${ligne['sous_total'] ?? 0}"),
            )),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(navigatorKey.currentContext!), child: const Text("Fermer")),
          ElevatedButton(onPressed: () {
            DashboardService.downloadSalePdf(vente['id']);
          }, child: const Text("Télécharger PDF")),
        ],
      ),
    );
  }

   

  Color _mapColor(String? colorName) {
    switch (colorName) {
      case "red": return Colors.red;
      case "orange": return Colors.orange;
      case "green": return Colors.green;
      default: return Colors.grey;
    }
  }
}