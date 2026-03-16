import 'dart:convert';
import 'package:http/http.dart' as http;

class NotificationsService {
  static const String baseUrl = 'http://172.25.200.129:8000/api';


  /// 🔹 Récupérer toutes les notifications
  static Future<List<Map<String, dynamic>>> getNotifications() async {
    final response = await http.get(Uri.parse("$baseUrl/notifications"));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception("Erreur lors du chargement des notifications");
    }
  }

  /// 🔹 Effacer toutes les notifications
  static Future<void> clearNotifications() async {
    final response = await http.post(Uri.parse("$baseUrl/notifications/clear"));
    if (response.statusCode != 200) {
      throw Exception("Erreur lors de l’effacement des notifications");
    }
  }

  /// 🔹 Marquer une notification comme lue
  static Future<void> markAsRead(int id) async {
    final response = await http.put(Uri.parse("$baseUrl/notifications/$id/read"));
    if (response.statusCode != 200) {
      throw Exception("Erreur lors du marquage de la notification");
    }
  }

  /// 🔹 Supprimer une notification spécifique
  static Future<void> deleteNotification(int id) async {
    final response = await http.delete(Uri.parse("$baseUrl/notifications/$id"));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception("Erreur lors de la suppression de la notification");
    }
  }
}