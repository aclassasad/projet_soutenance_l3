<?php

namespace App\Http\Controllers;

use App\Models\Categorie;
use Illuminate\Http\Request;

class CategorieController extends Controller
{
    // Afficher la liste des catégories
    public function index()
    {
        $categories = Categorie::all();
        return view('categories.index', compact('categories'));
    }

    // Formulaire de création
    public function create()
    {
        return view('categories.create');
    }

    // Sauvegarder une nouvelle catégorie
    public function store(Request $request)
    {
        $categorie = Categorie::create($request->all());
        return redirect()->route('categories.index')->with('success', 'Catégorie créée avec succès.');
    }

    // Afficher une catégorie
    public function show(Categorie $categorie)
    {
        return view('categories.show', compact('categorie'));
    }

    // Formulaire d’édition
    public function edit(Categorie $categorie)
    {
        return view('categories.edit', compact('categorie'));
    }

    // Mettre à jour une catégorie
    public function update(Request $request, Categorie $categorie)
    {
        $categorie->update($request->all());
        return redirect()->route('categories.index')->with('success', 'Catégorie mise à jour.');
    }

    // Supprimer une catégorie
    public function destroy(Categorie $categorie)
    {
        $categorie->delete();
        return redirect()->route('categories.index')->with('success', 'Catégorie supprimée.');
    }
}