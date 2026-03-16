<?php

namespace App\Http\Controllers;

use App\Models\Categorie;
use Illuminate\Http\Request;

class CategorieController extends Controller
{
    // 🔹 Liste des catégories
    public function index()
    {
        return response()->json(Categorie::all(), 200);
    }

    // 🔹 Créer une catégorie
    public function store(Request $request)
    {
        $validated = $request->validate([
            'nom' => 'required|string|max:255',
            'description' => 'nullable|string',
        ]);

        $categorie = Categorie::create($validated);

        // Charger les produits liés (vide au départ)
        $categorie = Categorie::with('produits')->find($categorie->id);

        return response()->json($categorie, 201);
    }

    // 🔹 Afficher une catégorie
    public function show($id)
    {
        $categorie = Categorie::with('produits')->find($id);

        if (!$categorie) {
            return response()->json(['message' => 'Catégorie introuvable'], 404);
        }

        return response()->json($categorie, 200);
    }

    // 🔹 Mettre à jour une catégorie
public function update(Request $request, $id)
{
    $validated = $request->validate([
        'nom' => 'required|string|max:255',
        'description' => 'nullable|string',
    ]);

    $categorie = Categorie::findOrFail($id);
    $categorie->update($validated);

    // Recharger l'objet complet avec ses relations
    $categorie = Categorie::with('produits')->find($categorie->id);

    return response()->json($categorie, 200);
}
    // 🔹 Supprimer une catégorie
    public function destroy(Categorie $categorie)
    {
        $categorie->delete();
        return response()->json(null, 204);
    }
}