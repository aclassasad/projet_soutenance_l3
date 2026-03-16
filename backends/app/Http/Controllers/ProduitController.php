<?php

namespace App\Http\Controllers;

use App\Models\Produit;
use Illuminate\Http\Request;

class ProduitController extends Controller
{
    // 🔹 Liste des produits avec relations
    public function index()
    {
        try {
            $produits = Produit::with(['categorie', 'fournisseur'])->get();
            return response()->json($produits, 200);
        } catch (\Exception $e) {
            return response()->json([
                'error' => 'Erreur lors du chargement des produits',
                'details' => $e->getMessage(),
            ], 500);
        }
    }

    // 🔹 Créer un produit
    public function store(Request $request)
    {
        $validated = $request->validate([
            'nom' => 'required|string|max:255',
            'description' => 'nullable|string',
            'prix_achat' => 'required|numeric|min:0',
            'prix_vente' => 'required|numeric|min:0',
            'stock' => 'required|integer|min:0',
            'seuil_alerte' => 'required|integer|min:0',
            'categorie_id' => 'required|integer|exists:categories,id',
            'fournisseur_id' => 'required|integer|exists:fournisseurs,id',
        ]);

        $produit = Produit::create($validated);
        return response()->json($produit->load(['categorie', 'fournisseur']), 201);
    }

    // 🔹 Détail d’un produit
    public function show($id)
    {
        $produit = Produit::with(['categorie', 'fournisseur'])->findOrFail($id);
        return response()->json($produit, 200);
    }

    // 🔹 Mettre à jour un produit
    public function update(Request $request, $id)
    {
        $produit = Produit::findOrFail($id);

        $validated = $request->validate([
            'nom' => 'required|string|max:255',
            'description' => 'nullable|string',
            'prix_achat' => 'required|numeric|min:0',
            'prix_vente' => 'required|numeric|min:0',
            'stock' => 'required|integer|min:0',
            'seuil_alerte' => 'required|integer|min:0',
            'categorie_id' => 'required|integer|exists:categories,id',
            'fournisseur_id' => 'required|integer|exists:fournisseurs,id',
        ]);

        $produit->update($validated);
        return response()->json($produit->load(['categorie', 'fournisseur']), 200);
    }

    // 🔹 Supprimer un produit
    public function destroy($id)
    {
        $produit = Produit::findOrFail($id);
        $produit->delete();
        return response()->json(null, 204);
    }
}