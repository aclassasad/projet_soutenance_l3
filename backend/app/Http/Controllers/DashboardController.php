<?php

namespace App\Http\Controllers;

use App\Models\Vente;
use App\Models\Produit;
use App\Models\User;
use App\Models\Categorie;
use Illuminate\Support\Facades\DB;

class DashboardController extends Controller
{
    public function index()
    {
        $user = auth()->user();

        // ✅ Vérifie que l'utilisateur est admin ou gérant
        if (!in_array($user->role, ['admin', 'gerant'])) {
            return redirect()->route('login')->withErrors('Accès interdit');
        }

        // Requête pour les ventes hebdomadaires
        $weeklySales = Vente::select(
                DB::raw('DAYNAME(created_at) as day'),
                DB::raw('SUM(total) as value')
            )
            ->whereBetween('created_at', [now()->startOfWeek(), now()->endOfWeek()])
            ->groupBy('day')
            ->get()
            ->pluck('value','day'); // clé = jour, valeur = total

        // Liste fixe des jours de la semaine
        $days = ["Lundi","Mardi","Mercredi","Jeudi","Vendredi","Samedi","Dimande"];

        $weeklySalesLabels = $days;
        $weeklySalesData   = [];

        foreach ($days as $day) {
            $weeklySalesData[] = $weeklySales[$day] ?? 0; // 0 si pas de ventes
        }

        $stats = [
            'total_revenu' => Vente::sum('total'),
            'total_produits_stock' => Produit::sum('stock'),
            'employes_actifs' => User::whereIn('role', ['gerant','caissier'])->where('statut', 1)->count(),
            'nombre_categories' => Categorie::count(),
            'produits_alertes' => Produit::whereColumn('stock', '<=', 'seuil_alerte')->count(),
            'produits_epuises' => Produit::where('stock', 0)->count(),
            'total_commandes' => Vente::count(),
            'transactions_recentes' => Vente::with('user') // relation vers le caissier
                ->orderBy('created_at','desc')
                ->take(5)
                ->get(),
            // Graphique ventes hebdomadaires (7 jours fixes)
            'weekly_sales_labels' => $weeklySalesLabels,
            'weekly_sales_data'   => $weeklySalesData,

            // Trafic en magasin (exemple simulé)
            'store_traffic' => Vente::select(
                    DB::raw('HOUR(created_at) as hour'),
                    DB::raw('COUNT(*) as value')
                )
                ->whereDate('created_at', now()) // trafic du jour
                ->groupBy('hour')
                ->orderBy('hour')
                ->get()
                ->map(function($item) {
                    return [
                        'hour' => $item->hour . 'h',
                        'value' => $item->value
                    ];
                })
                ->toArray(),
        ];

        return view('dashboard', compact('stats'));
    }
}
