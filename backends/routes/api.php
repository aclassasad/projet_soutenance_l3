<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\UserController;
use App\Http\Controllers\EmployeeController;
use App\Http\Controllers\CategorieController;
use App\Http\Controllers\FournisseurController;
use App\Http\Controllers\ProduitController;
use App\Http\Controllers\InventaireController;
use App\Http\Controllers\SalesController;
use App\Http\Controllers\LigneVenteController;
use App\Http\Controllers\VenteController;
use App\Http\Controllers\SecurityController;
use App\Http\Controllers\NotificationController;
use App\Http\Controllers\DashboardController;
use App\Http\Controllers\EquipementController;


// ==========================
// 🔹 Authentification
// ==========================
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);
Route::post('/logout', [AuthController::class, 'logout'])->middleware('auth:sanctum');
Route::post('/password/forgot', [AuthController::class, 'forgotPassword']);
Route::post('/password/verify', [AuthController::class, 'verifyResetCode']);
Route::post('/password/reset', [AuthController::class, 'resetPassword'])->name('password.reset');


// ==========================
// 🔹 Utilisateurs & Employés

Route::get('/employees/stats', [EmployeeController::class, 'stats']);
Route::get('/employees', [EmployeeController::class, 'index']);
Route::post('/employees', [EmployeeController::class, 'store']);
Route::get('/employees/{id}', [EmployeeController::class, 'show']);
Route::put('/employees/{id}', [EmployeeController::class, 'update']);
Route::delete('/employees/{id}', [EmployeeController::class, 'destroy']);

// ==========================
// 🔹 Catégories & Fournisseurs
// ==========================
Route::apiResource('categories', CategorieController::class);
Route::apiResource('fournisseurs', FournisseurController::class);

// ==========================
// 🔹 Produits & Inventaire
// ==========================
Route::apiResource('produits', ProduitController::class);
Route::get('/inventaire/stats', [InventaireController::class, 'stats']);
Route::get('/inventaire/produits', [InventaireController::class, 'produits']);
Route::get('/inventaire/categories', [InventaireController::class, 'categories']);
Route::get('/inventaire/search', [InventaireController::class, 'search']);
// ==========================
// 🔹 Ventes & Lignes de vente
// ==========================
Route::apiResource('ventes', VenteController::class);
Route::apiResource('ligne-ventes', LigneVenteController::class);

// ==========================
// 🔹 Dashboard & Statistiques
// ==========================
Route::prefix('sales')->group(function () {
    Route::get('/stats', [SalesController::class, 'stats']);
    Route::get('/topProducts', [SalesController::class, 'topProducts']);
    Route::get('/revenueTrend', [SalesController::class, 'revenueTrend']);
    Route::get('/salesByCategory', [SalesController::class, 'salesByCategory']);
    Route::post('/store', [SalesController::class, 'store']);
});

// ==========================
// 🔹 Sécurité
// ==========================
Route::get('/security/stats', [SecurityController::class, 'stats']);
Route::get('/security/incidents', [SecurityController::class, 'incidents']);
Route::get('/security/incidents/stats', [SecurityController::class, 'incidentStats']);
Route::post('/security/incidents/{id}/investigate', [SecurityController::class, 'investigate']);

// ==========================
// 🔹 Notifications
// ==========================
Route::get('/notifications', [NotificationController::class, 'index']);
Route::post('/notifications', [NotificationController::class, 'store']);
Route::post('/notifications/clear', [NotificationController::class, 'clear']);

Route::put('/notifications/{id}/read', [NotificationController::class, 'markAsRead']);
Route::delete('/notifications/{id}', [NotificationController::class, 'destroy']);


Route::middleware('auth:sanctum')->get('/dashboard', [DashboardController::class, 'stats']);

// ==========================
// 🔹 Vente d'un employé
// ==========================
Route::get('/employees/{id}/ventes', [EmployeeController::class, 'ventes']);



// ==========================
// 🔹 Equipements
// ==========================



//Route::get('/equipements/update', [EquipementController::class, 'updateEtat']);


Route::match(['get','post'], '/equipements/update', [EquipementController::class, 'updateEtat']);
Route::get('/equipements/incidents', [EquipementController::class, 'getIncidents']);
Route::get('/equipements/stats', [EquipementController::class, 'getSecurityStats']);
Route::get('/equipements/incident-stats', [EquipementController::class, 'getIncidentStats']);
Route::post('/equipements/incidents/{id}/investigate', [EquipementController::class, 'investigateIncident']);
Route::post('/equipements/toggle-motion', [EquipementController::class, 'toggleMotionDetection']);
Route::post('/equipements/toggle-alarm', [EquipementController::class, 'toggleAlarm']);


Route::get('/equipements/update/{mac}', [EquipementController::class, 'updateEtatGet']);



Route::get('/equipements/alarme/status', function () {
    $alarme = \App\Models\Equipement::where('nom', 'Alarme')->first();
    return response()->json([
        'etat' => $alarme ? $alarme->etat : 0,
        'action' => $alarme ? $alarme->action : 0,
        'description' => $alarme ? $alarme->description : 'Pas d’alarme'
    ]);
});
