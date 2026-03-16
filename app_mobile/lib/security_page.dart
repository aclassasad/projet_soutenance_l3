import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'security_service.dart';

class SecurityPage extends StatefulWidget {
  const SecurityPage({super.key});

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  Map<String, dynamic>? stats;
  List<Map<String, dynamic>> incidents = [];
  List<Map<String, dynamic>> incidentStats = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadSecurityData();
  }

  Future<void> _loadSecurityData() async {
    try {
      final statsData = await SecurityService.getSecurityStats();
      final incidentsData = await SecurityService.getIncidents();
      final incidentStatsData = await SecurityService.getIncidentStats();
      setState(() {
        stats = statsData;
        incidents = incidentsData;
        incidentStats = incidentStatsData;
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

       // ✅ Amélioration : affichage lisible pour recording et system_status
    String recordingText = stats?['recording'] == true ? "Yes" : "No";
    String status = stats?['system_status']?.toString() ?? "Unknown";
    Color statusColor = status == "OK" ? Colors.green : Colors.red;



    return Scaffold(
      appBar: AppBar(title: const Text("Security Monitoring")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text("Security Monitoring", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

          const SizedBox(height: 20),

        // Stats Cards
          Row(children: [
            Expanded(child: _statCard("Cameras Online", stats?['cameras_online']?.toString() ?? "0", Colors.blue)),
            const SizedBox(width: 12),
            Expanded(child: _statCard("Active Incidents", stats?['active_incidents']?.toString() ?? "0", Colors.red)),
            const SizedBox(width: 12),
            Expanded(child: _statCard("Recording", recordingText, Colors.orange)),
            const SizedBox(width: 12),
            Expanded(child: _statCard("System Status", status, statusColor)),
          ]),



          const SizedBox(height: 20),

          // Camera Feed
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("Main Entrance - Front Door", style: TextStyle(fontWeight: FontWeight.w600)),
                    Chip(label: Text("REC"), backgroundColor: Colors.red),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  height: 200,
                  color: Colors.black87,
                  alignment: Alignment.center,
                  child: const Text("[Live Camera Feed Placeholder]", style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 12),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  ElevatedButton(onPressed: () {}, child: const Text("Play")),
                  const SizedBox(width: 8),
                  ElevatedButton(onPressed: () {}, child: const Text("Pause")),
                  const SizedBox(width: 8),
                  ElevatedButton(onPressed: () {}, child: const Text("Fullscreen")),
                ]),
              ]),
            ),
          ),

          const SizedBox(height: 20),
// Incidents
Column(
  children: incidents.map((i) => Card(
    child: ListTile(
      title: Text(i['description'] ?? "Sans description"),
      subtitle: Text("Location: ${i['location'] ?? "N/A"} • Date: ${i['date'] ?? "N/A"}"),
      trailing: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        onPressed: () async {
          await SecurityService.investigateIncident(i['id'] ?? 0);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Incident ${i['id'] ?? "?"} en investigation")),
          );
        },
        child: const Text("Investigate"),
      ),
    ),
  )).toList(),
),


          const SizedBox(height: 20),

         // Incident Types Chart
          const Text("Incident Types Overview", style: TextStyle(fontWeight: FontWeight.w600)),
          SizedBox(
            height: 200,
            child: BarChart(BarChartData(
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final type = incidentStats[value.toInt()]['type'] ?? "";
                      return Text(type, style: const TextStyle(fontSize: 10));
                    },
                  ),
                ),
              ),
              barGroups: List.generate(incidentStats.length, (i) => BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: (incidentStats[i]['count'] ?? 0).toDouble(),
                    color: Colors.red,
                  )
                ],
              )),
            )),

 ),
        ]),
      ),
    );
  }

  Widget _statCard(String title, dynamic value, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          Text("$value", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        ]),
      ),
    );
  }
}