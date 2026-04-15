import 'package:flutter/material.dart';
import 'settings_service.dart';

class ThemeProvider extends ChangeNotifier {
  static ThemeProvider? _instance;
  
  String _themeMode = 'light';
  
  String get themeMode => _themeMode;
  
  // Singleton pattern pour avoir une instance unique
  static ThemeProvider get instance {
    _instance ??= ThemeProvider._();
    return _instance!;
  }
  
  ThemeProvider._() {
    _loadTheme();
    SettingsService.themeNotifier.addListener(_onThemeChanged);
  }
  
  Future<void> _loadTheme() async {
    _themeMode = await SettingsService.getCurrentTheme();
    notifyListeners();
  }
  
  void _onThemeChanged() {
    _themeMode = SettingsService.themeNotifier.value;
    notifyListeners();
  }
  
  ThemeMode getThemeMode() {
    return _themeMode == 'dark' ? ThemeMode.dark : ThemeMode.light;
  }
  
  // Méthode pour changer le thème immédiatement
  Future<void> toggleTheme() async {
    final newTheme = _themeMode == 'light' ? 'dark' : 'light';
    _themeMode = newTheme;
    await SettingsService.saveSettings({'theme': newTheme});
    notifyListeners();
  }
  
  // Méthode pour accéder au provider depuis n'importe quel widget
  static ThemeProvider of(BuildContext context) {
    // Cherche dans l'arbre des widgets
    final inheritedProvider = context.dependOnInheritedWidgetOfExactType<_InheritedThemeProvider>();
    if (inheritedProvider != null) {
      return inheritedProvider.provider;
    }
    // Fallback sur l'instance singleton
    return instance;
  }
  
  @override
  void dispose() {
    SettingsService.themeNotifier.removeListener(_onThemeChanged);
    super.dispose();
  }
}

// InheritedWidget pour partager le provider sans package provider
class _InheritedThemeProvider extends InheritedWidget {
  final ThemeProvider provider;
  
  const _InheritedThemeProvider({
    required this.provider,
    required super.child,
    super.key,
  });
  
  @override
  bool updateShouldNotify(_InheritedThemeProvider oldWidget) {
    return provider.themeMode != oldWidget.provider.themeMode;
  }
  
  static _InheritedThemeProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_InheritedThemeProvider>();
  }
}

// Widget à placer en haut de l'arbre pour partager le provider
class ThemeProviderWidget extends StatefulWidget {
  final Widget child;
  
  const ThemeProviderWidget({super.key, required this.child});
  
  @override
  State<ThemeProviderWidget> createState() => _ThemeProviderWidgetState();
}

class _ThemeProviderWidgetState extends State<ThemeProviderWidget> {
  late final ThemeProvider _themeProvider;
  
  @override
  void initState() {
    super.initState();
    _themeProvider = ThemeProvider.instance;
    _themeProvider.addListener(_onThemeChanged);
  }
  
  void _onThemeChanged() {
    if (mounted) {
      setState(() {});
    }
  }
  
  @override
  void dispose() {
    _themeProvider.removeListener(_onThemeChanged);
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return _InheritedThemeProvider(
      provider: _themeProvider,
      child: widget.child,
    );
  }
}