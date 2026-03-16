<?php

namespace App\Http\Controllers;

use App\Models\LigneVente;
use Illuminate\Http\Request;

class LigneVenteController extends Controller
{
    // 🔹 Liste des lignes de vente avec relations
    public function index()
    {
        try {
            $lignes = LigneVente::with(['vente', 'produit'])->get();
            return response()->json($lignes, 200);
        } catch (\Exception $e) {
            return response()->json([
                'error' => 'Erreur lors du chargement des lignes de vente',
                'details' => $e->getMessage(),
            ], 500);
        }
    }

    // 🔹 Créer une ligne de vente
    public function store(Request $request)
    {
        $validated = $request->validate([
            'vente_id' => 'required|integer|exists:ventes,id',
            'produit_id' => 'required|integer|exists:produits,id',
            'quantite' => 'required|integer|min:1',
            'prix_unitaire' => 'required|numeric|min:0',
        ]);

        $ligne = LigneVente::create($validated);
        return response()->json($ligne->load(['vente', 'produit']), 201);
    }

    // 🔹 Détail d’une ligne de vente
    public function show($id)
    {
        $ligneVente = LigneVente::with(['vente', 'produit'])->findOrFail($id);
        return response()->json($ligneVente, 200);
    }

    // 🔹 Mettre à jour une ligne de vente
    public function update(Request $request, $id)
    {
        $ligneVente = LigneVente::findOrFail($id);

        $validated = $request->validate([
            'vente_id' => 'required|integer|exists:ventes,id',
            'produit_id' => 'required|integer|exists:produits,id',
            'quantite' => 'required|integer|min:1',
            'prix_unitaire' => 'required|numeric|min:0',
        ]);

        $ligneVente->update($validated);
        return response()->json($ligneVente->load(['vente', 'produit']), 200);
    }

    // 🔹 Supprimer une ligne de vente
    public function destroy($id)
    {
        $ligneVente = LigneVente::findOrFail($id);
        $ligneVente->delete();
        return response()->json(null, 204);
    }
}