import 'dart:convert';
import 'package:http/http.dart' as http;

class EmployeeService {
  static const String baseUrl = 'http://172.25.200.129:8000/api';


  /// 🔹 Récupérer les stats globales des employés
  static Future<Map<String, dynamic>> getEmployeeStats() async {
    final response = await http.get(Uri.parse("$baseUrl/employees/stats"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Erreur lors du chargement des stats employés");
    }
  }

  /// 🔹 Récupérer la liste des employés
  static Future<List<Map<String, dynamic>>> getEmployees() async {
    final response = await http.get(Uri.parse("$baseUrl/employees"));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception("Erreur lors du chargement des employés");
    }
  }

  /// 🔹 Créer un nouvel employé
  static Future<void> createEmployee(Map<String, dynamic> emp) async {
    final response = await http.post(
      Uri.parse("$baseUrl/employees"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(emp),
    );
    if (response.statusCode != 201) {
      throw Exception("Erreur lors de la création de l’employé");
    }
  }

  /// 🔹 Mettre à jour un employé
  static Future<void> updateEmployee(int id, Map<String, dynamic> emp) async {
    final response = await http.put(
      Uri.parse("$baseUrl/employees/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(emp),
    );
    if (response.statusCode != 200) {
      throw Exception("Erreur lors de la mise à jour de l’employé");
    }
  }

  /// 🔹 Supprimer un employé
  static Future<void> deleteEmployee(int id) async {
    final response = await http.delete(Uri.parse("$baseUrl/employees/$id"));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception("Erreur lors de la suppression de l’employé");
    }
  }
}