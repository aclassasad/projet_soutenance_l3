<?php

namespace App\Http\Controllers;

use App\Models\Produit;
use Illuminate\Http\Request;

class ProduitController extends Controller
{
    // Afficher la liste des produits
    public function index()
    {
        $produits = Produit::with(['categorie', 'fournisseur'])->get();
        return view('produits.index', compact('produits'));
    }

    // Formulaire de création
    public function create()
    {
        return view('produits.create');
    }

    // Sauvegarder un nouveau produit
    public function store(Request $request)
    {
        Produit::create($request->all());
        return redirect()->route('produits.index')->with('success', 'Produit créé avec succès.');
    }

    // Afficher un produit
    public function show(Produit $produit)
    {
        return view('produits.show', compact('produit'));
    }

    // Formulaire d’édition
    public function edit(Produit $produit)
    {
        return view('produits.edit', compact('produit'));
    }

    // Mettre à jour un produit
    public function update(Request $request, Produit $produit)
    {
        $produit->update($request->all());
        return redirect()->route('produits.index')->with('success', 'Produit mis à jour.');
    }

    // Supprimer un produit
    public function destroy(Produit $produit)
    {
        $produit->delete();
        return redirect()->route('produits.index')->with('success', 'Produit supprimé.');
    }
}