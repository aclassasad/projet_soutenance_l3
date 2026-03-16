import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EmployeeService {
  static final String baseUrl = dotenv.env['API_BASE_URL'] ?? "";

  /// 🔹 Récupérer les stats globales des employés
  static Future<Map<String, dynamic>> getEmployeeStats() async {
    final response = await http.get(Uri.parse("$baseUrl/employees/stats"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Erreur lors du chargement des stats employés: ${response.body}");
    }
  }

  /// 🔹 Récupérer la liste des employés
  static Future<List<Map<String, dynamic>>> getEmployees() async {
    final response = await http.get(Uri.parse("$baseUrl/employees"));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception("Erreur lors du chargement des employés: ${response.body}");
    }
  }

  /// 🔹 Récupérer le détail d’un employé
  static Future<Map<String, dynamic>> getEmployeeDetail(int id) async {
    final response = await http.get(Uri.parse("$baseUrl/employees/$id"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Erreur lors du chargement de l'employé: ${response.body}");
    }
  }

  /// 🔹 Créer un nouvel employé
  static Future<void> createEmployee({
    required String nom,
    required String email,
    required String password,
    required String role,
    required String statut,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/employees"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": nom,       // ⚠️ Laravel attend "name"
        "email": email,
        "password": password,
        "role": role,
        "statut": statut,  // ⚠️ Laravel attend "status"
      }),
    );

    if (response.statusCode != 201) {
      throw Exception("Erreur lors de la création de l'employé: ${response.body}");
    }
  }

  /// 🔹 Mettre à jour un employé existant
  static Future<void> updateEmployee({
    required int id,
    required String nom,
    required String email,
    required String role,
    required String statut,
  }) async {
    final response = await http.put(
      Uri.parse("$baseUrl/employees/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": nom,
        "email": email,
        "role": role,
        "statut": statut,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Erreur lors de la mise à jour de l'employé: ${response.body}");
    }
  }

  /// 🔹 Supprimer un employé
  static Future<void> deleteEmployee(int id) async {
    final response = await http.delete(Uri.parse("$baseUrl/employees/$id"));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception("Erreur lors de la suppression de l'employé: ${response.body}");
    }
  }

   // 🔹 Récupérer les ventes d’un employé (caissier)
  static Future<List<Map<String, dynamic>>> getEmployeeSales(int userId) async {
    final response = await http.get(Uri.parse("$baseUrl/employees/$userId/ventes"));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception("Erreur lors du chargement des ventes de l’employé");
    }
  }

}