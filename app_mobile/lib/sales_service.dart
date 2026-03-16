import 'dart:convert';
import 'package:http/http.dart' as http;

class SalesService {
  static const String baseUrl = 'http://172.25.200.129:8000/api/sales';


  /// 🔹 Récupérer les stats globales des ventes
  static Future<Map<String, dynamic>> getSalesStats() async {
    final response = await http.get(Uri.parse("$baseUrl/stats"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Erreur lors du chargement des stats ventes");
    }
  }

  /// 🔹 Récupérer les ventes par catégorie
  static Future<List<Map<String, dynamic>>> getSalesByCategory() async {
    final response = await http.get(Uri.parse("$baseUrl/salesByCategory")); // ✅ corrigé
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception("Erreur lors du chargement des ventes par catégorie");
    }
  }


  /// 🔹 Récupérer les produits les plus vendus
 static Future<List<Map<String, dynamic>>> getTopProducts() async {
    final response = await http.get(Uri.parse("$baseUrl/topProducts")); // ✅ corrigé
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception("Erreur lors du chargement des produits les plus vendus");
    }
  }
}
