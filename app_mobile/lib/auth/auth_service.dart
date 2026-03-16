import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'http://172.25.200.129:8000/api';


  /// 🔹 Connexion utilisateur
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Content-Type": "application/json", "Accept": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // ⚠️ Vérifie que ton API renvoie bien "token"
      final token = data['token'];
      if (token != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", token);
      }

      return data;
    } else {
      throw Exception("Erreur lors de la connexion : ${response.body}");
    }
  }

  /// 🔹 Déconnexion
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token != null) {
      await http.post(
        Uri.parse("$baseUrl/logout"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );
      await prefs.remove("token");
    }
  }

  /// 🔹 Envoi du code de réinitialisation (forgot password)
  static Future<Map<String, dynamic>> sendResetCode(String email) async {
    final response = await http.post(
      Uri.parse("$baseUrl/password/forgot"),
      headers: {"Content-Type": "application/json", "Accept": "application/json"},
      body: jsonEncode({"email": email}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Erreur lors de l’envoi du code : ${response.body}");
    }
  }

  /// 🔹 Vérification du code (⚠️ nécessite une route côté Laravel)
  static Future<Map<String, dynamic>> verifyResetCode(String code, String newPassword) async {
    final response = await http.post(
      Uri.parse("$baseUrl/password/verify"), // ⚠️ ajoute cette route dans ton AuthController
      headers: {"Content-Type": "application/json", "Accept": "application/json"},
      body: jsonEncode({"code": code, "password": newPassword}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Erreur lors de la vérification du code : ${response.body}");
    }
  }

  /// 🔹 Réinitialisation du mot de passe
  static Future<Map<String, dynamic>> resetPassword(String email, String newPassword) async {
    final response = await http.post(
      Uri.parse("$baseUrl/password/reset"),
      headers: {"Content-Type": "application/json", "Accept": "application/json"},
      body: jsonEncode({"email": email, "password": newPassword}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Erreur lors de la réinitialisation : ${response.body}");
    }
  }
}