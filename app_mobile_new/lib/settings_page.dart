import 'package:flutter/material.dart';
import 'settings_service.dart';
import 'theme_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Map<String, dynamic> settings = {
    "language": "fr",
    "theme": "light",
    "email_notifications": true,
    "push_notifications": true,
  };

  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final loaded = await SettingsService.loadSettings();
    if (mounted) {
      setState(() {
        settings = loaded;
        loading = false;
      });
    }
  }

  Future<void> _saveSettings() async {
    await SettingsService.saveSettings(settings);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Paramètres sauvegardés"),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _resetSettings() async {
    await SettingsService.resetSettings();
    await _loadSettings();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Paramètres réinitialisés"),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: const Color(0xFF4361EE),
        ),
      );
    }
  }

  String _getLanguageLabel(String code) {
    switch (code) {
      case "fr": return "Français";
      case "en": return "English";
      default: return code;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Récupérer le thème actuel via le ThemeProvider
    final themeProvider = ThemeProvider.of(context);
    final isDarkMode = themeProvider.themeMode == 'dark';
    
    if (loading) {
      return Scaffold(
        backgroundColor: isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: Color(0xFF4361EE)),
              const SizedBox(height: 16),
              Text(
                "Chargement des paramètres...",
                style: TextStyle(color: isDarkMode ? Colors.grey[400] : Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          "Paramètres",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête avec icône
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 24),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4361EE).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.settings_outlined,
                      size: 48,
                      color: Color(0xFF4361EE),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Préférences",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Personnalisez votre expérience",
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // Carte des paramètres
            Container(
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: isDarkMode 
                        ? Colors.black.withOpacity(0.3) 
                        : Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 1,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Langue
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isDarkMode ? const Color(0xFF334155) : Colors.grey.shade100,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.language_outlined, color: isDarkMode ? Colors.grey[400] : const Color(0xFF64748B)),
                            const SizedBox(width: 12),
                            Text(
                              "Langue",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: isDarkMode ? Colors.white : const Color(0xFF1E293B),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4361EE).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: settings["language"],
                              items: const [
                                DropdownMenuItem(value: "fr", child: Text("Français")),
                                DropdownMenuItem(value: "en", child: Text("English")),
                              ],
                              onChanged: (val) => setState(() => settings["language"] = val),
                              style: const TextStyle(
                                color: Color(0xFF4361EE),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Thème
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isDarkMode ? const Color(0xFF334155) : Colors.grey.shade100,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.brightness_6_outlined, color: isDarkMode ? Colors.grey[400] : const Color(0xFF64748B)),
                            const SizedBox(width: 12),
                            Text(
                              "Thème",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: isDarkMode ? Colors.white : const Color(0xFF1E293B),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4361EE).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: settings["theme"],
                              items: const [
                                DropdownMenuItem(value: "light", child: Text("Clair")),
                                DropdownMenuItem(value: "dark", child: Text("Sombre")),
                              ],
                              onChanged: (val) async {
                                setState(() => settings["theme"] = val);
                                await SettingsService.saveSettings(settings);
                                if (context.mounted) {
                                  ThemeProvider.instance.toggleTheme();
                                }
                              },
                              style: const TextStyle(
                                color: Color(0xFF4361EE),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Notifications Email
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isDarkMode ? const Color(0xFF334155) : Colors.grey.shade100,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.email_outlined, color: isDarkMode ? Colors.grey[400] : const Color(0xFF64748B)),
                            const SizedBox(width: 12),
                            Text(
                              "Notifications Email",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: isDarkMode ? Colors.white : const Color(0xFF1E293B),
                              ),
                            ),
                          ],
                        ),
                        Switch(
                          value: settings["email_notifications"],
                          onChanged: (val) => setState(() => settings["email_notifications"] = val),
                          activeColor: const Color(0xFF4361EE),
                          activeTrackColor: const Color(0xFF4361EE).withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),

                  // Notifications Push
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.notifications_outlined, color: isDarkMode ? Colors.grey[400] : const Color(0xFF64748B)),
                            const SizedBox(width: 12),
                            Text(
                              "Notifications Push",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: isDarkMode ? Colors.white : const Color(0xFF1E293B),
                              ),
                            ),
                          ],
                        ),
                        Switch(
                          value: settings["push_notifications"],
                          onChanged: (val) => setState(() => settings["push_notifications"] = val),
                          activeColor: const Color(0xFF4361EE),
                          activeTrackColor: const Color(0xFF4361EE).withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Boutons d'action
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveSettings,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4361EE),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Sauvegarder",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _resetSettings,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: isDarkMode ? Colors.grey[400] : const Color(0xFF64748B),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(
                        color: isDarkMode ? const Color(0xFF475569) : Colors.grey.shade300,
                      ),
                    ),
                    child: const Text(
                      "Réinitialiser",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Information supplémentaire
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 20, color: isDarkMode ? Colors.grey[400] : const Color(0xFF64748B)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Les modifications seront appliquées immédiatement",
                      style: TextStyle(
                        fontSize: 12,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}