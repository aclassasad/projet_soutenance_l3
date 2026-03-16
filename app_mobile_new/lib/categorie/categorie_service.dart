import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CategorieService {
static final String baseUrl = dotenv.env['API_BASE_URL'] ?? "";


  /// 🔹 Récupérer toutes les catégories
  static Future<List<Map<String, dynamic>>> getCategories() async {
    final response = await http.get(Uri.parse("$baseUrl/categories"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List) {
        return data.map((e) => Map<String, dynamic>.from(e)).toList();
      }
      throw Exception("Format inattendu: attendu une liste");
    } else {
      throw Exception("Erreur lors du chargement des catégories");
    }
  }

  /// 🔹 Récupérer le détail d’une catégorie
 static Future<Map<String, dynamic>> getCategorieDetail(int id) async {
  final response = await http.get(Uri.parse("$baseUrl/categories/$id"));
  print("Réponse brute detail: ${response.body}"); 
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return Map<String, dynamic>.from(data); // ✅ toujours un objet
  } else {
    throw Exception("Erreur lors du chargement de la catégorie");
  }
}


  /// 🔹 Créer une nouvelle catégorie
  static Future<Map<String, dynamic>> createCategorie(String nom, String description) async {
    final response = await http.post(
      Uri.parse("$baseUrl/categories"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "nom": nom,
        "description": description,
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return Map<String, dynamic>.from(data); // ✅ renvoie l’objet créé
    } else {
      throw Exception("Erreur lors de la création de la catégorie");
    }
  }

  /// 🔹 Mettre à jour une catégorie existante
  
static Future<Map<String, dynamic>> updateCategorie(int id, String nom, String description) async {
  final response = await http.put(
    Uri.parse("$baseUrl/categories/$id"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "nom": nom,
      "description": description,
    }),
  );
print("Réponse brute update: ${response.body}");
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return Map<String, dynamic>.from(data); // ✅ toujours un objet
  } else {
    throw Exception("Erreur lors de la mise à jour de la catégorie");
  }
}


  /// 🔹 Supprimer une catégorie
  static Future<void> deleteCategorie(int id) async {
    final response = await http.delete(Uri.parse("$baseUrl/categories/$id"));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception("Erreur lors de la suppression de la catégorie");
    }
  }
}