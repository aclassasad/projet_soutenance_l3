import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class DashboardService {
static final String baseUrl = dotenv.env['API_BASE_URL'] ?? "";


  /// 🔹 Récupérer toutes les stats du dashboard
  static Future<Map<String, dynamic>> getDashboardStats() async {
    final prefs = await SharedPreferences.getInstance();
    print("Token stocké : ${prefs.getString("token")}");

    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse("$baseUrl/dashboard"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Erreur lors du chargement des stats du dashboard");
    }
  }

  /// 🔹 Télécharger le PDF d’une vente
  static Future<void> downloadSalePdf(int saleId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse("$baseUrl/sales/$saleId/pdf"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/pdf",
      },
    );

    if (response.statusCode == 200) {
      // Ici tu peux gérer le fichier PDF (ex: sauvegarde locale ou ouverture)
      print("PDF de la vente $saleId téléchargé avec succès");
    } else {
      throw Exception("Erreur lors du téléchargement du PDF de la vente");
    }
  }
}