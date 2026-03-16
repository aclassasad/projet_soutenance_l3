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
      appBar: AppBar(title: const Text("Sales Analytics")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text("Sales Analytics",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const Text("Track your store's sales performance",
              style: TextStyle(color: Colors.grey)),

          const SizedBox(height: 20),

          // KPIs
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              _kpiCard("Total Revenue", "\$${stats?['total_revenu'] ?? 0}",
                  Colors.blue, Icons.attach_money, "+15.3%"),
              _kpiCard("Total Orders", "${stats?['total_commandes'] ?? 0}",
                  Colors.teal, Icons.shopping_cart, "+8.2%"),
              _kpiCard("Avg. Order Value", "\$${stats?['moyenne_commande'] ?? 0}",
                  Colors.green, Icons.receipt, "+6.5%"),
              _kpiCard("Unique Customers", "${stats?['clients_uniques'] ?? 0}",
                  Colors.orange, Icons.people, "+12.1%"),
            ],
          ),

          const SizedBox(height: 20),

          // Revenue Trend Chart
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(children: [
                const Text("Revenue Trend",
                    style: TextStyle(fontWeight: FontWeight.w600)),
                SizedBox(
                  height: 200,
                  child: LineChart(LineChartData(
                    titlesData: FlTitlesData(show: true),
                    lineBarsData: [
                      LineChartBarData(
                        spots: revenueTrend.map((row) => FlSpot(
                          (row['mois'] as num).toDouble(),
                          (row['revenu'] as num).toDouble(),
                        )).toList(),
                        isCurved: true,
                        color: Colors.indigo,
                        barWidth: 3,
                        belowBarData: BarAreaData(
                          show: true,
                          color: Colors.indigo.withOpacity(0.1),
                        ),
                      )
                    ],
                  )),
                ),
              ]),
            ),
          ),

          const SizedBox(height: 20),

          // Sales by Category (PieChart)
          Card(
            child: SizedBox(
              height: 200,
              child: PieChart(PieChartData(
                sections: categories
                    .map((c) => PieChartSectionData(
                          value: (c['revenu'] as num?)?.toDouble() ?? 0.0,
                          title: c['nom'] ?? "Sans nom",
                          color: Colors.primaries[
                              categories.indexOf(c) % Colors.primaries.length],
                        ))
                    .toList(),
              )),
            ),
          ),

          const SizedBox(height: 20),

          // Top Selling Products
          Card(
            child: DataTable(
              columns: const [
                DataColumn(label: Text("Rank")),
                DataColumn(label: Text("Product Name")),
                DataColumn(label: Text("Units Sold")),
                DataColumn(label: Text("Revenue")),
                DataColumn(label: Text("Performance")),
              ],
              rows: topProducts.asMap().entries.map((entry) {
                final i = entry.key;
                final p = entry.value;
                final revenue = (p['revenue'] as num?)?.toDouble() ?? 0.0;
                final maxRevenue = topProducts
                    .map((tp) => (tp['revenue'] as num?)?.toDouble() ?? 0.0)
                    .reduce((a, b) => a > b ? a : b);
                final percentage = maxRevenue > 0 ? (revenue / maxRevenue) : 0.0;

                return DataRow(cells: [
                  DataCell(Text("${i + 1}")),
                  DataCell(Text(p['nom'] ?? "Sans nom")),
                  DataCell(Text("${p['units'] ?? 0} units")),
                  DataCell(Text("\$${revenue.toStringAsFixed(2)}")),
                  DataCell(SizedBox(
                    width: 120,
                    child: Row(children: [
                      Flexible(
                        child: LinearProgressIndicator(
                          value: percentage,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text("${(percentage * 100).toStringAsFixed(0)}%"),
                    ]),
                  )),
                ]);
              }).toList(),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _kpiCard(
      String title, String value, Color color, IconData icon, String subtitle) {
    return Card(
      elevation: 3,
      child: SizedBox(
        height: 120, // ✅ hauteur uniforme
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded( // ✅ empêche le texte de déborder
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(title,
                        style: const TextStyle(color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1),
                    Text(value,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1),
                    Text(subtitle,
                        style: TextStyle(color: color, fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1),
                  ],
                ),
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
}