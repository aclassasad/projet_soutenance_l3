import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLayout extends StatelessWidget {
  final Widget child;

  const AppLayout({super.key, required this.child});

  Future<void> _logout(BuildContext context) async {
    try {
      final baseUrl = dotenv.env['API_BASE_URL'] ?? "";

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token") ?? "";

      final response = await http.post(
        Uri.parse("$baseUrl/logout"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await prefs.remove("auth_token");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data["message"] ?? "Déconnexion réussie"),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
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

  String _getCurrentRoute(BuildContext context) {
    return ModalRoute.of(context)?.settings.name ?? '/dashboard';
  }

  @override
  Widget build(BuildContext context) {
    final currentRoute = _getCurrentRoute(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            
            const SizedBox(width: 12),
            const Text(
              "Secure Store Pro",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 12, 24, 79),
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              Navigator.pushNamed(context, "/notifications");
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.pushNamed(context, "/settings");
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/logo.jpeg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.7),
                BlendMode.darken,
              ),
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // En-tête du drawer avec image de fond
              Container(
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color.fromARGB(255, 45, 70, 183).withOpacity(0.9),
                      const Color(0xFF1E293B).withOpacity(0.9),
                    ],
                  ),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "SecureStore Pro",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Système de gestion",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              _buildNavItem(
                context,
                Icons.speed,
                "Tableau de bord",
                "/dashboard",
                currentRoute,
              ),
              _buildNavItem(
                context,
                Icons.inventory,
                "Inventaire",
                "/inventory",
                currentRoute,
              ),
              _buildNavItem(
                context,
                Icons.security,
                "Sécurité",
                "/security",
                currentRoute,
              ),
              _buildNavItem(
                context,
                Icons.shopping_cart,
                "Ventes",
                "/sales",
                currentRoute,
              ),
              _buildNavItem(
                context,
                Icons.people,
                "Employés",
                "/employees",
                currentRoute,
              ),
              const Divider(
                color: Colors.white24,
                thickness: 1,
                height: 16,
              ),
              _buildNavItem(
                context,
                Icons.notifications,
                "Notifications",
                "/notifications",
                currentRoute,
              ),
              _buildNavItem(
                context,
                Icons.settings,
                "Paramètres",
                "/settings",
                currentRoute,
              ),
              const Divider(
                color: Colors.white24,
                thickness: 1,
                height: 16,
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.redAccent),
                title: const Text(
                  "Déconnexion",
                  style: TextStyle(color: Colors.redAccent),
                ),
                onTap: () => _logout(context),
              ),
            ],
          ),
        ),
      ),
      body: child,
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    IconData icon,
    String title,
    String route,
    String currentRoute,
  ) {
    final isActive = currentRoute == route;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF4361EE).withOpacity(0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? const Color(0xFF4361EE) : Colors.white70,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isActive ? const Color(0xFF4361EE) : Colors.white70,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        trailing: isActive
            ? Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: const Color(0xFF4361EE),
                  borderRadius: BorderRadius.circular(2),
                ),
              )
            : null,
        onTap: () {
          Navigator.pushNamed(context, route);
        },
      ),
    );
  }
}