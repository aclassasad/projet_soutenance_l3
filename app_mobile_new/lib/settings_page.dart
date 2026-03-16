import 'package:flutter/material.dart';
import 'settings_service.dart';

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
    setState(() {
      settings = loaded;
      loading = false;
    });
  }

  Future<void> _saveSettings() async {
    await SettingsService.saveSettings(settings);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Paramètres sauvegardés")),
    );
  }

  Future<void> _resetSettings() async {
    await SettingsService.resetSettings();
    await _loadSettings();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Paramètres réinitialisés")),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Paramètres")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField(
            initialValue: settings["language"],
            decoration: const InputDecoration(labelText: "Langue"),
            items: const [
              DropdownMenuItem(value: "fr", child: Text("Français")),
              DropdownMenuItem(value: "en", child: Text("Anglais")),
            ],
            onChanged: (val) => setState(() => settings["language"] = val),
          ),
          DropdownButtonFormField(
            initialValue: settings["theme"],
            decoration: const InputDecoration(labelText: "Thème"),
            items: const [
              DropdownMenuItem(value: "light", child: Text("Clair")),
              DropdownMenuItem(value: "dark", child: Text("Sombre")),
            ],
            onChanged: (val) => setState(() => settings["theme"] = val),
          ),
          SwitchListTile(
            title: const Text("Notifications Email"),
            value: settings["email_notifications"],
            onChanged: (val) => setState(() => settings["email_notifications"] = val),
          ),
          SwitchListTile(
            title: const Text("Notifications Push"),
            value: settings["push_notifications"],
            onChanged: (val) => setState(() => settings["push_notifications"] = val),
          ),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: _saveSettings, child: const Text("Sauvegarder")),
          OutlinedButton(onPressed: _resetSettings, child: const Text("Réinitialiser")),
        ],
      ),
    );
  }
}