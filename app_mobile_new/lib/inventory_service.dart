import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class InventoryService {
  // ⚠️ Si tu testes sur le même PC que Laravel, garde 127.0.0.1
  // Si tu testes sur un autre appareil, mets l’IP locale de ta machine (ex: 192.168.1.10)
  static final String baseUrl = dotenv.env['API_BASE_URL'] ?? "";

  /// 🔹 Étape 1 : Récupérer stats + produits + catégories (inventaire.index)
  static Future<Map<String, dynamic>> getIndex() async {
    final uri = Uri.parse("$baseUrl/inventaire/index");

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Erreur lors du chargement de l'inventaire");
    }
  }

  /// 🔹 Étape 2 : Recherche + filtre côté serveur (inventaire.search)
  /// ⚠️ Renvoie maintenant tous les résultats sans pagination
  static Future<List<Map<String, dynamic>>> searchProduits({
    String search = "",
    int? categorieId,
  }) async {
    final uri = Uri.parse("$baseUrl/inventaire/search").replace(queryParameters: {
      "search": search,
      "categorie_id": categorieId?.toString() ?? "",
    });

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // ✅ Laravel renvoie directement une liste (get())
      if (data is List) {
        return List<Map<String, dynamic>>.from(data);
      }

      // ✅ Si jamais tu gardes paginate() quelque part
      if (data is Map<String, dynamic> && data.containsKey('data')) {
        return List<Map<String, dynamic>>.from(data['data']);
      }

      return [];
    } else {
      throw Exception("Erreur lors de la recherche des produits");
    }
  }

  /// 🔹 Récupérer les stats seules
  static Future<Map<String, dynamic>> getInventoryStats() async {
    final response = await http.get(Uri.parse("$baseUrl/inventaire/stats"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Erreur lors du chargement des stats inventaire");
    }
  }

  /// 🔹 Récupérer la liste des catégories
  static Future<List<Map<String, dynamic>>> getCategories() async {
    final response = await http.get(Uri.parse("$baseUrl/inventaire/categories"));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception("Erreur lors du chargement des catégories");
    }
  }

  /// 🔹 Supprimer un produit
  static Future<void> deleteProduit(int id) async {
    final response = await http.delete(Uri.parse("$baseUrl/produits/$id"));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception("Erreur lors de la suppression du produit");
    }
  }

  /// 🔹 Récupérer les fournisseurs
  static Future<List<Map<String, dynamic>>> getFournisseurs() async {
    final response = await http.get(Uri.parse("$baseUrl/fournisseurs"));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception("Erreur lors du chargement des fournisseurs");
    }
  }
}