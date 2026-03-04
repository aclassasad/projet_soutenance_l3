<?php

namespace App\Http\Controllers;

use App\Models\Produit;
use App\Models\Categorie;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class InventoryController extends Controller
{
    public function index()
    {
        $stats = [
            'total_produits' => Produit::count(),
            'produits_stock_baisse' => Produit::whereColumn('stock', '<=', 'seuil_alerte')->count(),
            'produits_stock_fini' => Produit::where('stock', 0)->count(),
            'valeur_totale' => Produit::select(DB::raw('SUM(stock * prix_vente) as total'))->value('total'),
        ];

        $produits = Produit::paginate(10);
        $categories = Categorie::all(); // ✅ récupère toutes les catégories

        return view('inventory', compact('stats', 'produits', 'categories'));
    }

    public function search(Request $request)
    {
        $query = Produit::query();

        if ($request->filled('search')) {
            $query->where('nom', 'LIKE', "%{$request->search}%");
        }

        if ($request->filled('categorie_id')) {
            $query->where('categorie_id', $request->categorie_id);
        }

        $produits = $query->paginate(10);

        return view('partials.inventory_table', compact('produits'))->render();
    }
}