import 'package:flutter/material.dart';

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

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SecureStore Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/login',
      routes: {
        // Auth
        '/login': (context) => const LoginPage(),
        '/password-reset': (context) => const PasswordResetPage(),
        '/verify-code': (context) => const VerifyCodePage(),
        '/reset-password': (context) => const ResetPasswordPage(),

        // Global
        '/dashboard': (context) => AppLayout(child: DashboardPage()),
        '/inventory': (context) => AppLayout(child: InventoryPage()),
        '/notifications': (context) => AppLayout(child: NotificationsPage()),
        '/sales': (context) => AppLayout(child: SalesPage()),
        '/security': (context) => AppLayout(child: SecurityPage()),
        '/employees': (context) => AppLayout(child: EmployeesPage()),
        '/settings': (context) => AppLayout(child: SettingsPage()),

      // Catégorie
'/categories': (context) => AppLayout(child: CategoriesPage()),

// ✅ On passe directement le Map complet et non un int
'/categories/detail': (context) {
  final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
  return AppLayout(child: CategoryDetailPage(categorie: args));
},

'/categories/create': (context) => AppLayout(child: CreateCategoryPage()),

// ✅ On passe aussi le Map complet à EditCategoryPage
'/categories/edit': (context) {
  final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
  return AppLayout(child: EditCategoryPage(categorie: args));
},

        // Employé
        '/employees/add': (context) => AppLayout(child: AddEmployeePage()),
        '/employees/edit': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return AppLayout(child: EditEmployeePage(user: args));
        },
        '/employees/detail': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return AppLayout(child: EmployeeDetailPage(user: args));
        },

        // Fournisseur
'/fournisseurs': (context) => AppLayout(child: FournisseursPage(fournisseurs: [])),        '/fournisseurs/detail': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return AppLayout(child: FournisseurDetailPage(fournisseur: args));
        },
        '/fournisseurs/create': (context) => AppLayout(child: CreateFournisseurPage()),
        '/fournisseurs/edit': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return AppLayout(child: EditFournisseurPage(fournisseur: args));
        },

        // Produit
        '/produits': (context) => AppLayout(child: ProductsPage()),
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
        '/produits/create': (context) => AppLayout(child: CreateProductPage()),
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
}