import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';


class SecurityService {
static final String baseUrl = dotenv.env['API_BASE_URL'] ?? "";


  /// 🔹 Récupérer les stats de sécurité (cameras, incidents, etc.)
  static Future<Map<String, dynamic>> getSecurityStats() async {
    final response = await http.get(Uri.parse("$baseUrl/security/stats"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Erreur lors du chargement des stats sécurité");
    }
  }

  /// 🔹 Récupérer la liste des incidents récents
  static Future<List<Map<String, dynamic>>> getIncidents() async {
    final response = await http.get(Uri.parse("$baseUrl/security/incidents"));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception("Erreur lors du chargement des incidents");
    }
  }

  /// 🔹 Récupérer les statistiques par type d’incident
  static Future<List<Map<String, dynamic>>> getIncidentStats() async {
    final response = await http.get(Uri.parse("$baseUrl/security/incident-stats"));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception("Erreur lors du chargement des statistiques d’incidents");
    }
  }

  /// 🔹 Déclencher une action d’investigation sur un incident
  static Future<void> investigateIncident(int id) async {
    final response = await http.post(Uri.parse("$baseUrl/security/incidents/$id/investigate"));
    if (response.statusCode != 200) {
      throw Exception("Erreur lors de l’investigation de l’incident");
    }
  }
}