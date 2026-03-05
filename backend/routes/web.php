<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\DashboardController;
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
use Illuminate\Support\Facades\Auth;
use App\Http\Controllers\CaissierController;
use App\Http\Controllers\AuthController;


// Tableau de bord
Route::get('/', [DashboardController::class, 'index'])->name('home');
Route::get('/dashboard', [DashboardController::class, 'index'])->name('dashboard');

// Gestion des employés
Route::get('/employees', [EmployeeController::class, 'index'])->name('employees');

// Inventaire
Route::get('/inventory', [InventoryController::class, 'index'])->name('inventory');

// Ventes
Route::get('/sales', [SalesController::class, 'index'])->name('sales');

// Sécurité
Route::get('/security', [SecurityController::class, 'index'])->name('security');

// Notifications
Route::get('/notifications', [NotificationController::class, 'index'])->name('notifications');
Route::post('/notifications/clear', [NotificationController::class, 'clear'])->name('notifications.clear');

// Paramètres
Route::get('/settings', [SettingsController::class, 'index'])->name('settings');
Route::post('/settings/update', [SettingsController::class, 'update'])->name('settings.update');
Route::post('/settings/security', [SettingsController::class, 'security'])->name('settings.security');

// CRUD Ressources
Route::resource('users', UserController::class);
Route::resource('produits', ProduitController::class);
Route::resource('categories', CategorieController::class)
     ->parameters(['categories' => 'categorie']);

Route::resource('fournisseurs', FournisseurController::class);
Route::resource('ventes', VenteController::class);
Route::resource('ligneventes', LigneVenteController::class);

// Logout
Route::post('/logout', function () {
    Auth::logout();
    return redirect('/login');
})->name('logout');


Route::get('/inventory', [InventoryController::class, 'index'])->name('inventory');
Route::get('/inventory/search', [InventoryController::class, 'search'])->name('inventory.search');






    
    Route::get('/caissier', [CaissierController::class, 'dashboard'])->name('caissier.dashboard');
Route::get('/caissier/recherche', [CaissierController::class, 'recherche'])->name('caissier.recherche');
Route::post('/caissier/vente', [CaissierController::class, 'store'])->name('caissier.store');
Route::get('/caissier/vente/{id}/pdf', [CaissierController::class, 'pdf'])->name('caissier.pdf');

Route::get('/ventes', [CaissierController::class, 'index'])->name('ventes.index');
Route::get('/caissier/stock', [CaissierController::class, 'stock'])->name('caissier.stock');
Route::get('/caissier/stats', [CaissierController::class, 'stats'])->name('caissier.stats');




Route::get('/login', [AuthController::class, 'showLoginForm'])->name('login');
Route::post('/login', [AuthController::class, 'login'])->name('login.post');
Route::post('/logout', [AuthController::class, 'logout'])->name('logout');



Route::get('/password/reset', function () {
    return view('auth.passwords.email'); // tu crées cette vue
})->name('password.request');




use App\Http\Controllers\EmployeeAuthController;

Route::get('/employee/login', [EmployeeAuthController::class, 'showLoginForm'])->name('employee.login');
Route::post('/employee/login', [EmployeeAuthController::class, 'login'])->name('employee.login.post');