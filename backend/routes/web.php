<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\DashboardController;
use App\Http\Controllers\CaissierController;
use App\Http\Controllers\EmployeeController;
use App\Http\Controllers\InventoryController;
use App\Http\Controllers\SalesController;
use App\Http\Controllers\SecurityController;
use App\Http\Controllers\NotificationController;
use App\Http\Controllers\SettingsController;
use App\Http\Controllers\UserController;
use App\Http\Controllers\ProduitController;
use App\Http\Controllers\CategorieController;
use App\Http\Controllers\FournisseurController;
use App\Http\Controllers\VenteController;
use App\Http\Controllers\LigneVenteController;
use Illuminate\Support\Facades\Password;


// ========================
// 🔑 Authentification
// ========================
Route::get('/login', [AuthController::class, 'showLoginForm'])->name('login');
Route::post('/login', [AuthController::class, 'login'])->name('login.post');
Route::post('/logout', [AuthController::class, 'logout'])->name('logout');

// ========================
// 📊 Page d’accueil
// ========================
Route::get('/', function () {
    return redirect()->route('login');
});

// ========================
// 🔒 Routes protégées
// ========================
Route::middleware(['auth'])->group(function () {

    // ✅ Dashboard admin/gérant
    Route::get('/dashboard', [DashboardController::class, 'index'])->name('dashboard');

    // ✅ Dashboard caissier
    Route::get('/caissier', [CaissierController::class, 'dashboard'])->name('caissier.dashboard');
    Route::get('/caissier/recherche', [CaissierController::class, 'recherche'])->name('caissier.recherche');
    Route::post('/caissier/vente', [CaissierController::class, 'store'])->name('caissier.store');
Route::get('/caissier/ventes/{vente}/pdf', [VenteController::class, 'show'])->name('caissier.pdf');
    Route::get('/caissier/stock', [CaissierController::class, 'stock'])->name('caissier.stock');
    Route::get('/caissier/stats', [CaissierController::class, 'stats'])->name('caissier.stats');
     Route::get('/caissier/historique', [VenteController::class, 'index'])->name('caissier.historique');


    // ✅ Historique des ventes
    Route::get('/ventes', [CaissierController::class, 'index'])->name('ventes.index');

    // ✅ Gestion des employés
    Route::get('/employees', [EmployeeController::class, 'index'])->name('employees');

    // ✅ Inventaire
    Route::get('/inventory', [InventoryController::class, 'index'])->name('inventory');
    Route::get('/inventory/search', [InventoryController::class, 'search'])->name('inventory.search');

    // ✅ Ventes
    Route::get('/sales', [SalesController::class, 'index'])->name('sales');

    // ✅ Sécurité
    Route::get('/security', [SecurityController::class, 'index'])->name('security');

    // ✅ Notifications
    Route::get('/notifications', [NotificationController::class, 'index'])->name('notifications');
    Route::post('/notifications/clear', [NotificationController::class, 'clear'])->name('notifications.clear');

    // ✅ Paramètres
    Route::get('/settings', [SettingsController::class, 'index'])->name('settings');
    Route::post('/settings/update', [SettingsController::class, 'update'])->name('settings.update');
    Route::post('/settings/security', [SettingsController::class, 'security'])->name('settings.security');

    // ✅ CRUD Ressources
    Route::resource('users', UserController::class);
    Route::resource('produits', ProduitController::class);
    Route::resource('categories', CategorieController::class)->parameters(['categories' => 'categorie']);
    Route::resource('fournisseurs', FournisseurController::class);
    Route::resource('ventes', VenteController::class);
    Route::resource('ligneventes', LigneVenteController::class);
});

// ========================
// 🔑 Reset mot de passe
// ========================

use App\Http\Controllers\PasswordController;

    // Étape 1 : saisie email
    Route::get('/password/request', [PasswordController::class, 'showEmailForm'])->name('password.request');
    Route::post('/password/request', [PasswordController::class, 'sendCode'])->name('password.sendCode');

    // Étape 2 : saisie code + nouveau mot de passe
    Route::get('/password/code', [PasswordController::class, 'showCodeForm'])->name('password.code');
    Route::post('/password/code', [PasswordController::class, 'verifyCodeAndReset'])->name('password.verifyCode');

    // Étape alternative : lien direct dans le mail
    Route::get('/password/reset/{token}', [PasswordController::class, 'showResetForm'])->name('password.reset');
    Route::post('/password/reset', [PasswordController::class, 'resetWithToken'])->name('password.update');
