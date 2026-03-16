<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Models\Produit;
use App\Models\Vente;
use App\Models\Categorie;
use Illuminate\Http\Request;
use Carbon\Carbon;

class DashboardController extends Controller
{
    public function stats()
    {
        try {
            // 🔹 Weekly sales (ventes par jour de la semaine)
$labels = ['Lun','Mar','Mer','Jeu','Ven','Sam','Dim'];
$weeklySales = [];
foreach (range(0,6) as $i) {
    $day = Carbon::now()->startOfWeek()->addDays($i);
    $weeklySales[] = (float) Vente::whereDate('date_vente', $day)->sum('total');
}

// 🔹 Store traffic (nombre de ventes par heure aujourd’hui)
$traffic = [];
foreach (range(8,20) as $hour) {
    $traffic[] = [
        'value' => Vente::whereDate('date_vente', Carbon::today())
                        ->whereRaw('HOUR(date_vente) = ?', [$hour])
                        ->count()
    ];
}

            // 🔹 Alerts (produits en stock bas ou fini)
            $alerts = [];
            foreach (Produit::whereColumn('stock', '<=', 'seuil_alerte')->get() as $p) {
                $alerts[] = [
                    'color' => $p->stock == 0 ? 'red' : 'orange',
                    'text' => "Stock bas : {$p->nom}",
                    'time' => $p->updated_at->diffForHumans(),
                ];
            }

            return response()->json([
                'total_revenu' => Vente::sum('total'),
                'total_produits_stock' => Produit::sum('stock'),
                'employes_actifs' => User::whereIn('role', ['gerant','caissier'])
                                         ->where('statut', true)
                                         ->count(),
                'nombre_categories' => Categorie::count(),
                'produits_stock_baisse' => Produit::whereColumn('stock', '<=', 'seuil_alerte')->count(),
                'produits_stock_fini' => Produit::where('stock', 0)->count(),
                'total_ventes' => Vente::count(),

                // 🔹 Données attendues par Flutter
                'weekly_sales_labels' => $labels,
                'weekly_sales_data' => $weeklySales,
                'store_traffic' => $traffic,
                'alerts' => $alerts,

                'transactions_recentes' => Vente::latest()
                    ->take(5)
                    ->with(['user','lignes.produit'])
                    ->get(),
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'error' => 'Erreur lors du calcul des statistiques',
                'details' => $e->getMessage(),
            ], 500);
        }
    }
}