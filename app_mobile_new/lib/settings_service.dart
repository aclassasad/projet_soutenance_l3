import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  /// 🔹 Charger les paramètres
  static Future<Map<String, dynamic>> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      "language": prefs.getString("language") ?? "fr",
      "theme": prefs.getString("theme") ?? "light",
      "email_notifications": prefs.getBool("email_notifications") ?? true,
      "push_notifications": prefs.getBool("push_notifications") ?? true,
    };
  }

  /// 🔹 Sauvegarder les paramètres
  static Future<void> saveSettings(Map<String, dynamic> settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("language", settings["language"]);
    await prefs.setString("theme", settings["theme"]);
    await prefs.setBool("email_notifications", settings["email_notifications"]);
    await prefs.setBool("push_notifications", settings["push_notifications"]);
  }

  /// 🔹 Réinitialiser les paramètres par défaut
  static Future<void> resetSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}