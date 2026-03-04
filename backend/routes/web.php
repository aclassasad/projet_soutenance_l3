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
Route::resource('categories', CategorieController::class);
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