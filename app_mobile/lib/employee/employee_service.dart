import 'dart:convert';
import 'package:http/http.dart' as http;

class EmployeeService {
  static const String baseUrl = 'http://172.25.200.129:8000/api';


  /// 🔹 Récupérer la liste des employés
  static Future<List<Map<String, dynamic>>> getEmployees() async {
    final response = await http.get(Uri.parse("$baseUrl/users"));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception("Erreur lors du chargement des employés");
    }
  }

  /// 🔹 Récupérer le détail d’un employé
  static Future<Map<String, dynamic>> getEmployeeDetail(int id) async {
    final response = await http.get(Uri.parse("$baseUrl/users/$id"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Erreur lors du chargement de l'employé");
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
      Uri.parse("$baseUrl/users"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": nom,
        "email": email,
        "password": password,
        "role": role,
        "statut": statut,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception("Erreur lors de la création de l'employé");
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
      Uri.parse("$baseUrl/users/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": nom,
        "email": email,
        "role": role,
        "statut": statut,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Erreur lors de la mise à jour de l'employé");
    }
  }

  /// 🔹 Supprimer un employé
  static Future<void> deleteEmployee(int id) async {
    final response = await http.delete(Uri.parse("$baseUrl/users/$id"));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception("Erreur lors de la suppression de l'employé");
    }
  }
}