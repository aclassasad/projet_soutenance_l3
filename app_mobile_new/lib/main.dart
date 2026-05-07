import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Pages globales
import 'dashboard_page.dart';
import 'inventory_page.dart';
import 'notifications_page.dart';
import 'sales_page.dart';
import 'security_page.dart';
import 'settings_page.dart';
import 'employees_page.dart';
import 'app_layout.dart';

// Catégorie
import 'categorie/categories_page.dart';
import 'categorie/category_detail_page.dart';
import 'categorie/create_category_page.dart';
import 'categorie/edit_category_page.dart';

// Employé
import 'employee/add_employee_page.dart';
import 'employee/edit_employee_page.dart';
import 'employee/employee_detail_page.dart';

// Fournisseur
import 'fournisseur/create_fournisseur_page.dart';
import 'fournisseur/edit_fournisseur_page.dart';
import 'fournisseur/fournisseur_detail_page.dart';
import 'fournisseur/fournisseurs_page.dart';

// Produit
import 'produit/create_product_page.dart';
import 'produit/edit_product_page.dart';
import 'produit/product_detail_page.dart';
import 'produit/products_page.dart';

// Auth
import 'auth/login_page.dart';
import 'auth/password_reset_page.dart';
import 'auth/verify_code_page.dart';
import 'auth/reset_password_page.dart';

// Services et providers
import 'settings_service.dart';
import 'theme_provider.dart';




Future<void> main() async {
  const envFile = String.fromEnvironment('ENV', defaultValue: '.env.local');
  await dotenv.load(fileName: envFile);
  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Écouter les changements de thème
    ThemeProvider.instance.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    ThemeProvider.instance.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SecureStore Pro',
      debugShowCheckedModeBanner: false,
      theme: _lightTheme,
      darkTheme: _darkTheme,
      themeMode: ThemeProvider.instance.getThemeMode(),
      initialRoute: '/login',
      routes: {
        // Auth
        '/login': (context) => const LoginPage(),
        '/password-reset': (context) => const PasswordResetPage(),
        '/verify-code': (context) => const VerifyCodePage(),
        '/reset-password': (context) => const ResetPasswordPage(),

        // Global
        '/dashboard': (context) => AppLayout(child: const DashboardPage()),
        '/inventory': (context) => AppLayout(child: const InventoryPage()),
        '/notifications': (context) => AppLayout(child: const NotificationsPage()),
        '/sales': (context) => AppLayout(child: const SalesPage()),
        '/security': (context) => AppLayout(child: const SecurityPage()),
        '/employees': (context) => AppLayout(child: const EmployeesPage()),
        '/settings': (context) => AppLayout(child: const SettingsPage()),

        // Catégorie
        '/categories': (context) => AppLayout(child: const CategoriesPage()),
        '/categories/detail': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return AppLayout(child: CategoryDetailPage(categorie: args));
        },
        '/categories/create': (context) => AppLayout(child: const CreateCategoryPage()),
        '/categories/edit': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return AppLayout(child: EditCategoryPage(categorie: args));
        },

        // Employé
        '/employees/add': (context) => AppLayout(child: const AddEmployeePage()),
        '/employees/edit': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return AppLayout(child: EditEmployeePage(user: args));
        },
        '/employees/detail': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return AppLayout(child: EmployeeDetailPage(user: args));
        },

        // Fournisseur
        '/fournisseurs': (context) => AppLayout(child: const FournisseursPage()),
        '/fournisseurs/detail': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return AppLayout(child: FournisseurDetailPage(fournisseur: args));
        },
        '/fournisseurs/create': (context) => AppLayout(child: const CreateFournisseurPage()),
        '/fournisseurs/edit': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return AppLayout(child: EditFournisseurPage(fournisseur: args));
        },

        // Produit
        '/produits': (context) => AppLayout(child: const ProductsPage()),
        '/produits/detail': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return AppLayout(
            child: ProductDetailPage(
              produit: args["produit"] as Map<String, dynamic>,
              categories: List<Map<String, dynamic>>.from(args["categories"] ?? []),
              fournisseurs: List<Map<String, dynamic>>.from(args["fournisseurs"] ?? []),
            ),
          );
        },
        '/produits/create': (context) => AppLayout(child: const CreateProductPage()),
        '/produits/edit': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return AppLayout(
            child: EditProductPage(
              produit: args["produit"] as Map<String, dynamic>,
              categories: List<Map<String, dynamic>>.from(args["categories"] ?? []),
              fournisseurs: List<Map<String, dynamic>>.from(args["fournisseurs"] ?? []),
            ),
          );
        },
      },
    );
  }

  // Thème clair (Light Theme)
  static final ThemeData _lightTheme = ThemeData.light().copyWith(
    primaryColor: const Color(0xFF4361EE),
    scaffoldBackgroundColor: const Color(0xFFF8FAFC),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: Color(0xFF1E293B),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Color(0xFF64748B)),
    ),
    cardTheme: const CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      clipBehavior: Clip.antiAlias,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF4361EE), width: 1.5),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4361EE),
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF64748B),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        side: BorderSide(color: Colors.grey.shade300),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
    ),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF4361EE),
      secondary: Color(0xFF06B6D4),
      surface: Colors.white,
    ),
  );

  // Thème sombre (Dark Theme)
  static final ThemeData _darkTheme = ThemeData.dark().copyWith(
    primaryColor: const Color(0xFF4361EE),
    scaffoldBackgroundColor: const Color(0xFF0F172A),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E293B),
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Color(0xFF94A3B8)),
    ),
    cardTheme: const CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      clipBehavior: Clip.antiAlias,
      color: Color(0xFF1E293B),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF334155),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF4361EE), width: 1.5),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4361EE),
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF94A3B8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        side: const BorderSide(color: Color(0xFF475569)),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
    ),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF4361EE),
      secondary: Color(0xFF06B6D4),
      surface: Color(0xFF1E293B),
    ),
  );
}