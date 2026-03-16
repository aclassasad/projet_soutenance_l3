import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FournisseurService {
static final String baseUrl = dotenv.env['API_BASE_URL'] ?? "";


  /// 🔹 Récupérer la liste des fournisseurs
  static Future<List<Map<String, dynamic>>> getFournisseurs() async {
    final response = await http.get(Uri.parse("$baseUrl/fournisseurs"));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception("Erreur lors du chargement des fournisseurs");
    }
  }

  /// 🔹 Récupérer le détail d’un fournisseur
  static Future<Map<String, dynamic>> getFournisseurDetail(int id) async {
    final response = await http.get(Uri.parse("$baseUrl/fournisseurs/$id"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Erreur lors du chargement du fournisseur");
    }
  }

  /// 🔹 Créer un nouveau fournisseur
  static Future<void> createFournisseur({
    required String nom,
    String? email,
    String? telephone,
    String? adresse,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/fournisseurs"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "nom": nom,
        "email": email ?? "",
        "telephone": telephone ?? "",
        "adresse": adresse ?? "",
      }),
    );

    if (response.statusCode != 201) {
      throw Exception("Erreur lors de la création du fournisseur");
    }
  }

  /// 🔹 Mettre à jour un fournisseur existant
static Future<Map<String, dynamic>> updateFournisseur({
  required int id,
  required String nom,
  String? email,
  String? telephone,
  String? adresse,
}) async {
  final response = await http.put( // ou patch selon ton API
    Uri.parse("$baseUrl/fournisseurs/$id"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "nom": nom,
      "email": email ?? "",
      "telephone": telephone ?? "",
      "adresse": adresse ?? "",
    }),
  );

  print("Update response: ${response.statusCode} - ${response.body}");

  if (response.statusCode == 200) {
    return jsonDecode(response.body); // ✅ retourne le fournisseur mis à jour
  } else {
    throw Exception("Erreur lors de la mise à jour: ${response.body}");
  }
}
  /// 🔹 Supprimer un fournisseur
  static Future<void> deleteFournisseur(int id) async {
    final response = await http.delete(Uri.parse("$baseUrl/fournisseurs/$id"));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception("Erreur lors de la suppression du fournisseur");
    }
  }
}