<?php
namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Vente;
use App\Models\Produit;
use App\Models\LigneVente;

class SalesController extends Controller
{
    public function index()
    {
        $stats = [
            'total_revenu' => Vente::sum('total'),
            'total_commandes' => Vente::count(),
            'moyenne_commande' => Vente::avg('total'),
        ];

        $topProducts = Produit::withCount('lignesVente')
                              ->orderByDesc('lignes_vente_count')
                              ->take(5)
                              ->get();

        $trend = Vente::selectRaw('MONTH(created_at) as mois, SUM(total) as revenu')
                      ->groupBy('mois')
                      ->orderBy('mois')
                      ->get();

        $categories = \DB::table('categories')
            ->select(
                'categories.nom as nom',
                \DB::raw('SUM(ligne_ventes.quantite * ligne_ventes.prix_unitaire) as revenu')
            )
            ->join('produits', 'categories.id', '=', 'produits.categorie_id')
            ->join('ligne_ventes', 'produits.id', '=', 'ligne_ventes.produit_id')
            ->groupBy('categories.nom')
            ->get();

        return view('sales', compact('stats', 'topProducts', 'trend', 'categories'));
    }

    public function store(Request $request)
    {
        // Exemple : création d’une vente
        $vente = Vente::create([
            'total' => $request->input('total'),
            // autres champs...
        ]);

        // Ajouter une notification en session
        session()->push('notifications', [
            'title' => 'Nouvelle vente',
            'message' => 'Une vente de ' . $vente->total . ' FCFA a été enregistrée.',
            'type' => 'info',
        ]);

        return redirect()->route('sales')->with('success', 'Vente enregistrée.');
    }
}