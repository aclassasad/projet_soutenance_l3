<?php

namespace App\Http\Controllers;

use App\Models\Vente;
use App\Models\LigneVente;
use Illuminate\Http\Request;

class VenteController extends Controller
{
    // 🔹 Liste des ventes avec leurs lignes
    public function index()
    {
        try {
            $ventes = Vente::with('lignesVente')->get();
            return response()->json($ventes, 200);
        } catch (\Exception $e) {
            return response()->json([
                'error' => 'Erreur lors du chargement des ventes',
                'details' => $e->getMessage(),
            ], 500);
        }
    }

    // 🔹 Créer une vente avec ses lignes
    public function store(Request $request)
    {
        $validated = $request->validate([
            'total' => 'required|numeric|min:0',
            'user_id' => 'required|integer|exists:users,id',
            'lignes' => 'required|array|min:1',
            'lignes.*.produit_id' => 'required|integer|exists:produits,id',
            'lignes.*.quantite' => 'required|integer|min:1',
            'lignes.*.prix_unitaire' => 'required|numeric|min:0',
        ]);

        $vente = Vente::create([
            'date_vente' => now(),
            'total' => $validated['total'],
            'user_id' => $validated['user_id'],
        ]);

        foreach ($validated['lignes'] as $ligne) {
            LigneVente::create([
                'vente_id' => $vente->id,
                'produit_id' => $ligne['produit_id'],
                'quantite' => $ligne['quantite'],
                'prix_unitaire' => $ligne['prix_unitaire'],
                'sous_total' => $ligne['quantite'] * $ligne['prix_unitaire'],
            ]);
        }

        return response()->json($vente->load('lignesVente'), 201);
    }

    // 🔹 Détail d’une vente
    public function show($id)
    {
        $vente = Vente::with('lignesVente')->findOrFail($id);
        return response()->json($vente, 200);
    }

    // 🔹 Mettre à jour une vente
    public function update(Request $request, $id)
    {
        $vente = Vente::findOrFail($id);

        $validated = $request->validate([
            'total' => 'required|numeric|min:0',
            'user_id' => 'required|integer|exists:users,id',
        ]);

        $vente->update($validated);
        return response()->json($vente->load('lignesVente'), 200);
    }

    // 🔹 Supprimer une vente
    public function destroy($id)
    {
        $vente = Vente::findOrFail($id);
        $vente->delete();
        return response()->json(null, 204);
    }
}