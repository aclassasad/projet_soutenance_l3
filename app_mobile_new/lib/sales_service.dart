import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SalesService {
  static final String baseUrl = dotenv.env['API_BASE_URL'] ?? "";

  static Future<Map<String, dynamic>> getSalesStats() async {
    final response = await http.get(Uri.parse("$baseUrl/sales/stats"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Erreur lors du chargement des stats ventes");
    }
  }

  static Future<List<Map<String, dynamic>>> getSalesByCategory() async {
    final response = await http.get(Uri.parse("$baseUrl/sales/salesByCategory"));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception("Erreur lors du chargement des ventes par catégorie");
    }
  }

  static Future<List<Map<String, dynamic>>> getTopProducts() async {
    final response = await http.get(Uri.parse("$baseUrl/sales/topProducts"));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception("Erreur lors du chargement des produits les plus vendus");
    }
  }

  static Future<List<Map<String, dynamic>>> getRevenueTrend() async {
    final response = await http.get(Uri.parse("$baseUrl/sales/revenueTrend"));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception("Erreur lors du chargement de la tendance des revenus");
    }
  }

 
}