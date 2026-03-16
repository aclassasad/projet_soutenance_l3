import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProductService {
static final String baseUrl = dotenv.env['API_BASE_URL'] ?? "";


  /// 🔹 Récupérer la liste des produits
  static Future<List<Map<String, dynamic>>> getProducts() async {
    final response = await http.get(Uri.parse("$baseUrl/produits"));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception("Erreur lors du chargement des produits");
    }
  }

  /// 🔹 Récupérer le détail d’un produit
  static Future<Map<String, dynamic>> getProductDetail(int id) async {
    final response = await http.get(Uri.parse("$baseUrl/produits/$id"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Erreur lors du chargement du produit");
    }
  }

  /// 🔹 Créer un nouveau produit
  static Future<void> createProduct({
    required String nom,
    String? description,
    required double prixAchat,
    required double prixVente,
    required int stock,
    required int seuilAlerte,
    required int categorieId,
    required int fournisseurId,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/produits"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "nom": nom,
        "description": description ?? "",
        "prix_achat": prixAchat,
        "prix_vente": prixVente,
        "stock": stock,
        "seuil_alerte": seuilAlerte,
        "categorie_id": categorieId,
        "fournisseur_id": fournisseurId,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception("Erreur lors de la création du produit");
    }
  }

  /// 🔹 Mettre à jour un produit existant
  static Future<Map<String, dynamic>> updateProduct({
    required int id,
    required String nom,
    String? description,
    required double prixAchat,
    required double prixVente,
    required int stock,
    required int seuilAlerte,
    required String categorieId,
    required String fournisseurId,
  }) async {
    final response = await http.put(
      Uri.parse("$baseUrl/produits/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "nom": nom,
        "description": description ?? "",
        "prix_achat": prixAchat,
        "prix_vente": prixVente,
        "stock": stock,
        "seuil_alerte": seuilAlerte,
        "categorie_id": categorieId,
        "fournisseur_id": fournisseurId,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // ✅ renvoie le produit mis à jour
    } else {
      throw Exception("Erreur lors de la mise à jour du produit");
    }
  }

  /// 🔹 Supprimer un produit
  static Future<void> deleteProduct(int id) async {
    final response = await http.delete(Uri.parse("$baseUrl/produits/$id"));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception("Erreur lors de la suppression du produit");
    }
  }
}