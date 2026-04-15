import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String _keyLanguage = 'app_language';
  static const String _keyTheme = 'app_theme';
  static const String _keyEmailNotifications = 'email_notifications';
  static const String _keyPushNotifications = 'push_notifications';

  static final ValueNotifier<String> themeNotifier = ValueNotifier('light');

  static Future<Map<String, dynamic>> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    return {
      "language": prefs.getString(_keyLanguage) ?? "fr",
      "theme": prefs.getString(_keyTheme) ?? "light",
      "email_notifications": prefs.getBool(_keyEmailNotifications) ?? true,
      "push_notifications": prefs.getBool(_keyPushNotifications) ?? true,
    };
  }

  static Future<void> saveSettings(Map<String, dynamic> settings) async {
    final prefs = await SharedPreferences.getInstance();
    
    if (settings.containsKey("language")) {
      await prefs.setString(_keyLanguage, settings["language"]);
    }
    if (settings.containsKey("theme")) {
      await prefs.setString(_keyTheme, settings["theme"]);
      themeNotifier.value = settings["theme"];
    }
    if (settings.containsKey("email_notifications")) {
      await prefs.setBool(_keyEmailNotifications, settings["email_notifications"]);
    }
    if (settings.containsKey("push_notifications")) {
      await prefs.setBool(_keyPushNotifications, settings["push_notifications"]);
    }
  }

  static Future<void> resetSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.setString(_keyLanguage, "fr");
    await prefs.setString(_keyTheme, "light");
    await prefs.setBool(_keyEmailNotifications, true);
    await prefs.setBool(_keyPushNotifications, true);
    
    themeNotifier.value = "light";
  }

  static Future<String> getCurrentTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyTheme) ?? "light";
  }
}