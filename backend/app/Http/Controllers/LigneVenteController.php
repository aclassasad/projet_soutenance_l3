<?php

namespace App\Http\Controllers;

use App\Models\LigneVente;
use Illuminate\Http\Request;

class LigneVenteController extends Controller
{
    // Afficher la liste des lignes de vente
    public function index()
    {
        $lignes = LigneVente::with(['vente', 'produit'])->get();
        return view('ligneventes.index', compact('lignes'));
    }

    // Formulaire de création
    public function create()
    {
        return view('ligneventes.create');
    }

    // Sauvegarder une nouvelle ligne de vente
    public function store(Request $request)
    {
        LigneVente::create($request->all());
        return redirect()->route('ligneventes.index')->with('success', 'Ligne de vente créée avec succès.');
    }

    // Afficher une ligne de vente
    public function show(LigneVente $ligneVente)
    {
        return view('ligneventes.show', compact('ligneVente'));
    }

    // Formulaire d’édition
    public function edit(LigneVente $ligneVente)
    {
        return view('ligneventes.edit', compact('ligneVente'));
    }

    // Mettre à jour une ligne de vente
    public function update(Request $request, LigneVente $ligneVente)
    {
        $ligneVente->update($request->all());
        return redirect()->route('ligneventes.index')->with('success', 'Ligne de vente mise à jour.');
    }

    // Supprimer une ligne de vente
    public function destroy(LigneVente $ligneVente)
    {
        $ligneVente->delete();
        return redirect()->route('ligneventes.index')->with('success', 'Ligne de vente supprimée.');
    }
}