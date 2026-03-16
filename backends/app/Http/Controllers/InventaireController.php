<?php

namespace App\Http\Controllers;

use App\Models\Produit;
use App\Models\Categorie;
use Illuminate\Support\Facades\DB;
use Illuminate\Http\Request;

class InventaireController extends Controller
{
    // 🔹 Statistiques d’inventaire

    public function index()
{
    try {
        $stats = [
            'total_produits' => Produit::count(),
            'produits_stock_baisse' => Produit::whereColumn('stock', '<=', 'seuil_alerte')->count(),
            'produits_stock_fini' => Produit::where('stock', 0)->count(),
            'valeur_totale' => Produit::select(DB::raw('SUM(stock * prix_vente) as total'))->value('total'),
        ];

        $produits = Produit::with('categorie:id,nom')->paginate(10);
        $categories = Categorie::select('id','nom')->get();

        return response()->json([
            'stats' => $stats,
            'produits' => $produits,
            'categories' => $categories,
        ], 200);
    } catch (\Exception $e) {
        return response()->json(['error' => $e->getMessage()], 500);
    }
}
    public function stats()
    {
        try {
            return response()->json([
                'total_produits' => Produit::count(),
                'low_stock' => Produit::whereColumn('stock', '<=', 'seuil_alerte')->count(),
                'out_of_stock' => Produit::where('stock', 0)->count(),
                'valeur_totale' => Produit::select(DB::raw('SUM(stock * prix_vente) as total'))->value('total'),
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'error' => 'Erreur lors du calcul des statistiques',
                'details' => $e->getMessage(),
            ], 500);
        }
    }

    // 🔹 Liste des produits avec pagination
    public function produits()
    {
        try {
            $produits = Produit::with('categorie:id,nom')
                ->paginate(10); // ✅ pagination comme côté web

            return response()->json($produits, 200);
        } catch (\Exception $e) {
            return response()->json([
                'error' => 'Erreur lors du chargement des produits',
                'details' => $e->getMessage(),
            ], 500);
        }
    }

    // 🔹 Liste des catégories
    public function categories()
    {
        try {
            $categories = Categorie::select('id', 'nom')->get();
            return response()->json($categories, 200);
        } catch (\Exception $e) {
            return response()->json([
                'error' => 'Erreur lors du chargement des catégories',
                'details' => $e->getMessage(),
            ], 500);
        }
    }

    // 🔹 Recherche + filtre avec pagination
public function search(Request $request)
{
    try {
        $query = Produit::with('categorie:id,nom');

        if ($request->filled('search')) {
            $query->where('nom', 'LIKE', "%{$request->search}%");
        }

        if ($request->filled('categorie_id')) {
            $query->where('categorie_id', $request->categorie_id);
        }

        // ✅ appliquer les filtres et récupérer les résultats
        $produits = $query->get();

        return response()->json($produits, 200);
    } catch (\Exception $e) {
        return response()->json(['error' => $e->getMessage()], 500);
    }
}
}