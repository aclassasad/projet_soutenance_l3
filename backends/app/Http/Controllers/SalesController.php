<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Vente;
use Illuminate\Support\Facades\DB;

class SalesController extends Controller
{
    // 🔹 Statistiques globales des ventes
    public function stats()
    {
        try {
            $stats = [
                'total_revenu'    => (float) Vente::sum('total'),
                'total_commandes' => (int) Vente::count(),
                'moyenne_commande'=> (float) Vente::avg('total'),
                'clients_uniques' => (int) Vente::distinct('user_id')->count('user_id'),
            ];

            return response()->json($stats, 200);
        } catch (\Exception $e) {
            return response()->json([
                'error'   => 'Erreur lors du calcul des statistiques',
                'details' => $e->getMessage(),
            ], 500);
        }
    }

    // 🔹 Produits les plus vendus
    public function topProducts()
    {
        try {
            $produits = DB::table('produits')
                ->join('ligne_ventes', 'produits.id', '=', 'ligne_ventes.produit_id')
                ->select(
                    'produits.nom',
                    DB::raw('SUM(ligne_ventes.quantite) as units'),
                    DB::raw('SUM(ligne_ventes.sous_total) as revenue')
                )
                ->groupBy('produits.nom')
                ->orderByDesc('units')
                ->take(5)
                ->get()
                ->map(function ($produit) {
                    return [
                        'nom'     => $produit->nom,
                        'units'   => (int) $produit->units,
                        'revenue' => (float) $produit->revenue,
                    ];
                });

            return response()->json($produits, 200);
        } catch (\Exception $e) {
            return response()->json([
                'error'   => 'Erreur lors du chargement des produits les plus vendus',
                'details' => $e->getMessage(),
            ], 500);
        }
    }

    // 🔹 Tendance des revenus par mois
    public function revenueTrend()
    {
        try {
            $revenus = Vente::select(
                DB::raw('MONTH(created_at) as mois'),
                DB::raw('SUM(total) as revenu')
            )
            ->groupBy('mois')
            ->orderBy('mois')
            ->get()
            ->map(function ($row) {
                return [
                    'mois'   => (int) $row->mois,
                    'revenu' => (float) $row->revenu,
                ];
            });

            return response()->json($revenus, 200);
        } catch (\Exception $e) {
            return response()->json([
                'error'   => 'Erreur lors du calcul de la tendance des revenus',
                'details' => $e->getMessage(),
            ], 500);
        }
    }

    // 🔹 Ventes par catégorie
    public function salesByCategory()
    {
        try {
            $categories = DB::table('ligne_ventes')
                ->join('produits', 'ligne_ventes.produit_id', '=', 'produits.id')
                ->join('categories', 'produits.categorie_id', '=', 'categories.id')
                ->select(
                    'categories.nom as nom',
                    DB::raw('SUM(ligne_ventes.sous_total) as revenu')
                )
                ->groupBy('categories.nom')
                ->get()
                ->map(function ($categorie) {
                    return [
                        'nom'    => $categorie->nom,
                        'revenu' => (float) $categorie->revenu,
                    ];
                });

            return response()->json($categories, 200);
        } catch (\Exception $e) {
            return response()->json([
                'error'   => 'Erreur lors du calcul des ventes par catégorie',
                'details' => $e->getMessage(),
            ], 500);
        }
    }

    // 🔹 Création d’une vente
    public function store(Request $request)
    {
        try {
            $vente = Vente::create([
                'date_vente' => now(),
                'total'      => $request->input('total'),
                'user_id'    => $request->input('user_id'),
            ]);

            return response()->json([
                'message' => 'Vente enregistrée.',
                'vente'   => $vente
            ], 201);
        } catch (\Exception $e) {
            return response()->json([
                'error'   => 'Erreur lors de l’enregistrement de la vente',
                'details' => $e->getMessage(),
            ], 500);
        }
    }
}