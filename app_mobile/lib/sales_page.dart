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
      setState(() {
        stats = statsData;
        categories = categoriesData;
        topProducts = topProductsData;
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
              _kpiCard("Total Revenue",
                  "\$${stats?['total_revenu']?.toString() ?? "0"}", Colors.blue,
                  Icons.attach_money, "+15.3%"),
              _kpiCard("Total Orders",
                  "\$${stats?['total_commandes']?.toString() ?? "0"}",
                  Colors.teal, Icons.shopping_cart, "+8.2%"),
              _kpiCard("Avg. Order Value",
                  "\$${stats?['moyenne_commande']?.toString() ?? "0"}",
                  Colors.green, Icons.receipt, "+6.5%"),
              _kpiCard("Unique Customers",
                  "\$${stats?['clients_uniques']?.toString() ?? "0"}",
                  Colors.orange, Icons.people, "+12.1%"),
            ],
          ),

          const SizedBox(height: 20),

          // Revenue Trend Chart (exemple statique)
          Card(
            child: SizedBox(
              height: 200,
              child: LineChart(LineChartData(
                titlesData: FlTitlesData(show: true),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      FlSpot(0, 80000),
                      FlSpot(1, 60000),
                      FlSpot(2, 40000),
                      FlSpot(3, 20000),
                      FlSpot(4, 50000),
                      FlSpot(5, 70000)
                    ],
                    isCurved: true,
                    color: Colors.indigo,
                    barWidth: 3,
                    belowBarData: BarAreaData(
                        show: true, color: Colors.indigo.withOpacity(0.1)),
                  )
                ],
              )),
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
                          value:
                              (c['revenu'] as num?)?.toDouble() ?? 0.0, // ✅ safe cast
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
                    .map((tp) =>
                        (tp['revenue'] as num?)?.toDouble() ?? 0.0)
                    .reduce((a, b) => a > b ? a : b);
                final percentage =
                    maxRevenue > 0 ? (revenue / maxRevenue) : 0.0;

                return DataRow(cells: [
                  DataCell(Text("${i + 1}")),
                  DataCell(Text(p['nom'] ?? "Sans nom")),
                  DataCell(Text("${p['units'] ?? 0} units")),
                  DataCell(Text("\$${revenue.toStringAsFixed(2)}")),
                  DataCell(Row(children: [
                    Expanded(
                        child: LinearProgressIndicator(
                      value: percentage.toDouble(), // ✅ cast en double
                      color: Colors.green,
                    )),
                    const SizedBox(width: 8),
                    Text("${(percentage * 100).toStringAsFixed(0)}%"),
                  ])),
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
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: const TextStyle(color: Colors.grey)),
                Text(value,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                Text(subtitle, style: TextStyle(color: color)),
              ]),
              CircleAvatar(
                  backgroundColor: color.withOpacity(0.1),
                  child: Icon(icon, color: color)),
            ]),
      ),
    );
  }
}