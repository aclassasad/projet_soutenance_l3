import 'package:flutter/material.dart';
import 'notifications_service.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<Map<String, dynamic>> notifications = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    try {
      final data = await NotificationsService.getNotifications();
      setState(() {
        notifications = data;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur: $e")),
      );
    }
  }

  Color _badgeColor(String type) {
    switch (type) {
      case "urgent":
        return Colors.red;
      case "warning":
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text("Notifications", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

          const SizedBox(height: 20),

          Expanded(
            child: notifications.isEmpty
                ? const Center(child: Text("Aucune notification disponible", style: TextStyle(color: Colors.grey)))
                : ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, i) {
                      final notif = notifications[i];
                      return Card(
                        child: ListTile(
                          title: Text(notif['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(notif['message'], style: const TextStyle(color: Colors.grey)),
                          trailing: Chip(
                            label: Text(notif['type'].toUpperCase()),
                            backgroundColor: _badgeColor(notif['type']),
                            labelStyle: const TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    },
                  ),
          ),

          const SizedBox(height: 12),

          ElevatedButton.icon(
            onPressed: () async {
              await NotificationsService.clearNotifications();
              setState(() {
                notifications.clear();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Toutes les notifications ont été effacées")),
              );
            },
            icon: const Icon(Icons.delete),
            label: const Text("Effacer les notifications"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        ]),
      ),
    );
  }
}