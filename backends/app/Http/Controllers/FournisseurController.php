<?php

namespace App\Http\Controllers;

use App\Models\Fournisseur;
use Illuminate\Http\Request;

class FournisseurController extends Controller
{
    // 🔹 Liste des fournisseurs
    public function index()
    {
        return response()->json(Fournisseur::all(), 200);
    }

    // 🔹 Créer un fournisseur
    public function store(Request $request)
    {
        $validated = $request->validate([
            'nom' => 'required|string|max:255',
            'email' => 'nullable|email',
            'telephone' => 'nullable|string|max:20',
            'adresse' => 'nullable|string|max:255',
        ]);

        $fournisseur = Fournisseur::create($validated);
        return response()->json($fournisseur, 201);
    }

    // 🔹 Détail d’un fournisseur
    public function show($id)
    {
        $fournisseur = Fournisseur::findOrFail($id);
        return response()->json($fournisseur, 200);
    }

    // 🔹 Mettre à jour un fournisseur
    public function update(Request $request, $id)
    {
        $fournisseur = Fournisseur::findOrFail($id);

        $validated = $request->validate([
            'nom' => 'required|string|max:255',
            'email' => 'nullable|email',
            'telephone' => 'nullable|string|max:20',
            'adresse' => 'nullable|string|max:255',
        ]);

        $fournisseur->update($validated);
        return response()->json($fournisseur, 200);
    }

    // 🔹 Supprimer un fournisseur
    public function destroy($id)
    {
        $fournisseur = Fournisseur::findOrFail($id);
        $fournisseur->delete();
        return response()->json(null, 204);
    }
}