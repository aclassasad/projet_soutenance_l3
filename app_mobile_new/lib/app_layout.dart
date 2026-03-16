import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart'; // ✅ import ajouté

class AppLayout extends StatelessWidget {
  final Widget child;

  const AppLayout({super.key, required this.child});

  Future<void> _logout(BuildContext context) async {
    try {
      final baseUrl = dotenv.env['API_BASE_URL'] ?? "";

      // ✅ Récupération du token stocké au login
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token") ?? "";

      final response = await http.post(
        Uri.parse("$baseUrl/logout"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // ✅ ajout du token
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // ✅ Supprimer le token après déconnexion
        await prefs.remove("auth_token");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"] ?? "Déconnexion réussie")),
        );

        Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erreur lors de la déconnexion")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SecureStore Pro")),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.black87),
              child: Text(
                "SecureStore Pro",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            _buildNavItem(context, Icons.speed, "Dashboard", "/dashboard"),
            _buildNavItem(context, Icons.inventory, "Inventory", "/inventory"),
            _buildNavItem(context, Icons.security, "Security", "/security"),
            _buildNavItem(context, Icons.shopping_cart, "Sales", "/sales"),
            _buildNavItem(context, Icons.people, "Employees", "/employees"),
            const Divider(),
            _buildNavItem(context, Icons.notifications, "Notifications", "/notifications"),
            _buildNavItem(context, Icons.settings, "Settings", "/settings"),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout", style: TextStyle(color: Colors.red)),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),
      body: child,
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String title, String route) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pushNamed(context, route);
      },
    );
  }
}