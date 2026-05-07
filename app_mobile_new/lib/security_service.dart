import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SecurityService {
  static final String baseUrl = dotenv.env['API_BASE_URL'] ?? "";

  /// 🔹 Récupérer les stats de sécurité (état système, incidents actifs)
static Future<Map<String, dynamic>> getSecurityStats() async {
  final response = await http.get(Uri.parse("$baseUrl/equipements/stats"));
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    if (data is Map<String, dynamic>) {
      return data;
    } else {
      throw Exception("Réponse API stats invalide : attendu un objet JSON");
    }
  } else {
    throw Exception("Erreur lors du chargement des stats sécurité");
  }
}


  /// 🔹 Récupérer la liste des incidents récents
static Future<List<Map<String, dynamic>>> getIncidents() async {
  final response = await http.get(Uri.parse("$baseUrl/equipements/incidents"));
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    print("Réponse incidents: $data"); // Debug console

    if (data is List) {
      return data.map((e) => Map<String, dynamic>.from(e)).toList();
    } else {
      throw Exception("Réponse API incidents invalide : attendu une liste JSON");
    }
  } else {
    throw Exception("Erreur lors du chargement des incidents");
  }
}



  /// 🔹 Récupérer les statistiques par type d’incident
static Future<Map<String, dynamic>> getIncidentStats() async {
  final response = await http.get(Uri.parse("$baseUrl/equipements/incident-stats"));
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    if (data is Map<String, dynamic>) {
      return data;
    } else {
      throw Exception("Réponse API incident-stats invalide : attendu un objet JSON");
    }
  } else {
    throw Exception("Erreur lors du chargement des statistiques d’incidents");
  }
}


  /// 🔹 Déclencher une action d’investigation sur un incident
  static Future<void> investigateIncident(int id) async {
    final response = await http.post(Uri.parse("$baseUrl/equipements/incidents/$id/investigate"));
    if (response.statusCode != 200) {
      throw Exception("Erreur lors de l’investigation de l’incident");
    }
  }

  /// 🔹 Activer/Désactiver la détection de mouvement
  static Future<void> toggleMotionDetection(bool enabled) async {
    final response = await http.post(
      Uri.parse("$baseUrl/equipements/toggle-motion"),
      body: jsonEncode({"enabled": enabled}),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode != 200) {
      throw Exception("Erreur lors du changement d’état de la détection de mouvement");
    }
  }

  /// 🔹 Activer/Désactiver l’alarme
  static Future<void> toggleAlarm(bool active) async {
    final response = await http.post(
      Uri.parse("$baseUrl/equipements/toggle-alarm"),
      body: jsonEncode({"active": active}),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode != 200) {
      throw Exception("Erreur lors du changement d’état de l’alarme");
    }
  }
  /// 🔹 Activer/Désactiver l’alarme auto

static Future<Map<String, dynamic>> getAlarmStatus() async {
  final response = await http.get(Uri.parse("$baseUrl/equipements/alarme/status"));
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    // 🔹 Debug : afficher la valeur et son type
    print("DEBUG getAlarmStatus: ${data['etat']} (${data['etat'].runtimeType})");

    // 🔹 Normalisation : toujours renvoyer un booléen
    bool etatBool;
    final etat = data['etat'];
    if (etat is bool) {
      etatBool = etat;
    } else if (etat is int) {
      etatBool = etat == 1;
    } else if (etat is String) {
      etatBool = etat.toLowerCase() == "true" || etat == "1";
    } else {
      etatBool = false;
    }

    // 🔹 Retourne un objet avec etat normalisé
    return {
      ...data,
      "etat": etatBool,
    };
  } else {
    throw Exception("Erreur lors de la récupération du statut de l’alarme");
  }
}


}
