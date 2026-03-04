<?php

namespace App\Http\Controllers;

use App\Models\Fournisseur;
use Illuminate\Http\Request;

class FournisseurController extends Controller
{
    // Afficher la liste des fournisseurs
    public function index()
    {
        $fournisseurs = Fournisseur::all();
        return view('fournisseurs.index', compact('fournisseurs'));
    }

    // Formulaire de création
    public function create()
    {
        return view('fournisseurs.create');
    }

    // Sauvegarder un nouveau fournisseur
    public function store(Request $request)
    {
        Fournisseur::create($request->all());
        return redirect()->route('fournisseurs.index')->with('success', 'Fournisseur créé avec succès.');
    }

    // Afficher un fournisseur
    public function show(Fournisseur $fournisseur)
    {
        return view('fournisseurs.show', compact('fournisseur'));
    }

    // Formulaire d’édition
    public function edit(Fournisseur $fournisseur)
    {
        return view('fournisseurs.edit', compact('fournisseur'));
    }

    // Mettre à jour un fournisseur
    public function update(Request $request, Fournisseur $fournisseur)
    {
        $fournisseur->update($request->all());
        return redirect()->route('fournisseurs.index')->with('success', 'Fournisseur mis à jour.');
    }

    // Supprimer un fournisseur
    public function destroy(Fournisseur $fournisseur)
    {
        $fournisseur->delete();
        return redirect()->route('fournisseurs.index')->with('success', 'Fournisseur supprimé.');
    }
}