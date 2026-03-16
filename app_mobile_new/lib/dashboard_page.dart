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

    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text("Dashboard", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text("Welcome back! Here's what's happening today.", style: TextStyle(color: Colors.grey)),

          const SizedBox(height: 16),
          // Metrics Cards en une seule ligne scrollable
// 🔹 Metrics Cards en une seule ligne scrollable
// 🔹 Metrics Cards en une seule ligne scrollable
SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Row(
    children: [
      _metricCard("Total Revenue", "\$${stats?['total_revenu'] ?? 0}", Colors.green, Icons.attach_money, "+12.5%"),
      _metricCard("Categories", "${stats?['nombre_categories'] ?? 0}", Colors.orange, Icons.category, "⚠️ Some low stock"),
      _metricCard("Products in Stock", "${stats?['total_produits_stock'] ?? 0}", Colors.blue, Icons.inventory, "-3.2%"),
      _metricCard("Active Employees", "${stats?['employes_actifs'] ?? 0}", Colors.teal, Icons.people, "+2"),
    ].map((card) => Padding(
      padding: const EdgeInsets.only(right: 12),
      child: card, // ✅ plus besoin de SizedBox externe
    )).toList(),
  ),
),

          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              SizedBox(
                width: isMobile ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.width / 2 - 24,
                child: _lineChartCard("Weekly Sales", stats?['weekly_sales_labels'] ?? [], stats?['weekly_sales_data'] ?? []),
              ),
              SizedBox(
                width: isMobile ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.width / 2 - 24,
                child: _barChartCard("Store Traffic Today", stats?['store_traffic'] ?? []),
              ),
            ],
          ),

          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              SizedBox(
                width: isMobile ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.width / 2 - 24,
                child: _alertsCard(stats?['alerts'] ?? []),
              ),
              SizedBox(
                width: isMobile ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.width / 2 - 24,
                child: _activityCard(stats?['transactions_recentes'] ?? []),
              ),
            ],
          ),
        ]),
      ),
    );
  }

 Widget _metricCard(String title, String value, Color color, IconData icon, String subtitle) {
  return Card(
    elevation: 3,
    child: SizedBox(
      width: 180,
      height: 120, // hauteur uniforme
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 6),
                Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(
                  subtitle,
                  style: TextStyle(color: color, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color),
            ),
          ],
        ),
      ),
    ),
  );
}

  Widget _lineChartCard(String title, List<dynamic> labels, List<dynamic> data) {
    final salesData = (data ?? []).map((e) => (e as num).toDouble()).toList();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          SizedBox(
            height: 200,
            child: LineChart(LineChartData(
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              gridData: FlGridData(show: false), // ✅ supprime les lignes de grille
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

  Widget _barChartCard(String title, List<dynamic> traffic) {
    final trafficData = traffic ?? [];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          SizedBox(
            height: 200,
            child: BarChart(BarChartData(
              titlesData: FlTitlesData(show: false), // ✅ pas de labels inutiles
              gridData: FlGridData(show: false), // ✅ pas de grilles
              barGroups: List.generate(
                trafficData.length,
                (i) => BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: ((trafficData[i]['value'] ?? 0) as num).toDouble(),
                      color: Colors.cyan,
                      width: 12,
                      borderRadius: BorderRadius.circular(4),
                    )
                  ],
                ),
              ),
            )),
          ),
        ]),
      ),
    );
  }

  Widget _alertsCard(List<dynamic> alerts) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: alerts.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, i) {
            final a = alerts[i];
            return ListTile(
              leading: Icon(Icons.warning, color: _mapColor(a['color'] ?? "grey")),
              title: Text(a['text'] ?? "No text"),
              subtitle: Text(a['time'] ?? ""),
              trailing: const Icon(Icons.chevron_right),
            );
          },
        ),
      ),
    );
  }
  Widget _activityCard(List<dynamic> transactions) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: transactions.length,
          separatorBuilder: (_, __) => const Divider(), // ✅ ajoute un séparateur
          itemBuilder: (context, i) {
            final t = transactions[i];
            return ListTile(
              leading: const Icon(Icons.circle, color: Colors.blue, size: 10),
              title: Text("Sale Transaction • ${t['user']?['name'] ?? 'Unknown'}"),
              subtitle: Text("\$${t['total'] ?? 0}"),
              trailing: SizedBox(
                width: 100,
                child: Text(
                  t['created_at'] ?? "",
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
              onTap: () => _showSaleDetails(t),
            );
          },
        ),
      ),
    );
  }

  void _showSaleDetails(Map<String, dynamic> vente) {
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (_) => AlertDialog(
        title: Text("Détails de la vente #${vente['id'] ?? ''}"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Caissier : ${vente['user']?['name'] ?? 'Unknown'}"),
              Text("Date : ${vente['created_at'] ?? ''}"),
              Text("Total : \$${vente['total'] ?? 0}"),
              const SizedBox(height: 12),
              const Text("Produits :", style: TextStyle(fontWeight: FontWeight.bold)),
              ...(vente['lignes'] ?? []).map<Widget>((ligne) => ListTile(
                title: Text(ligne['produit']?['nom'] ?? 'Produit inconnu'),
                subtitle: Text(
                  "${ligne['quantite'] ?? 0} x ${ligne['prix_unitaire'] ?? 0} = ${ligne['sous_total'] ?? 0}",
                ),
                trailing: SizedBox(
                  width: 80,
                  child: Text(
                    ligne['prix_unitaire']?.toString() ?? '',
                    textAlign: TextAlign.end,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(navigatorKey.currentContext!),
            child: const Text("Fermer"),
          ),
        ],
      ),
    );
  }

  // 🔹 Helper pour mapper les couleurs des alertes
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