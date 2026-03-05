@extends('layouts.app')

@section('title', 'Modifier un produit')

@section('content')
<div class="container mt-4">
    <h3>Modifier Produit</h3>

    <form action="{{ route('produits.update', $produit->id) }}" method="POST">
        @csrf
        @method('PUT')

        <div class="mb-3">
            <label for="nom" class="form-label">Nom du produit</label>
            <input type="text" name="nom" id="nom" class="form-control" value="{{ $produit->nom }}" required>
        </div>

        <div class="mb-3">
            <label for="description" class="form-label">Description</label>
            <textarea name="description" id="description" class="form-control">{{ $produit->description }}</textarea>
        </div>

        <div class="mb-3">
            <label for="prix_achat" class="form-label">Prix d'achat</label>
            <input type="number" step="0.01" name="prix_achat" id="prix_achat" class="form-control" value="{{ $produit->prix_achat }}" required>
        </div>

        <div class="mb-3">
            <label for="prix_vente" class="form-label">Prix de vente</label>
            <input type="number" step="0.01" name="prix_vente" id="prix_vente" class="form-control" value="{{ $produit->prix_vente }}" required>
        </div>

        <div class="mb-3">
            <label for="stock" class="form-label">Stock</label>
            <input type="number" name="stock" id="stock" class="form-control" value="{{ $produit->stock }}" required>
        </div>

        <div class="mb-3">
            <label for="seuil_alerte" class="form-label">Seuil d'alerte</label>
            <input type="number" name="seuil_alerte" id="seuil_alerte" class="form-control" value="{{ $produit->seuil_alerte }}" required>
        </div>

        <div class="mb-3">
            <label for="categorie_id" class="form-label">Catégorie</label>
            <select name="categorie_id" id="categorie_id" class="form-select" required>
                @foreach($categories as $cat)
                    <option value="{{ $cat->id }}" @if($produit->categorie_id == $cat->id) selected @endif>{{ $cat->nom }}</option>
                @endforeach
            </select>
        </div>

        <div class="mb-3">
            <label for="fournisseur_id" class="form-label">Fournisseur</label>
            <select name="fournisseur_id" id="fournisseur_id" class="form-select" required>
                @foreach($fournisseurs as $f)
                    <option value="{{ $f->id }}" @if($produit->fournisseur_id == $f->id) selected @endif>{{ $f->nom }}</option>
                @endforeach
            </select>
        </div>

        <button type="submit" class="btn btn-primary">Mettre à jour</button>
        <a href="{{ route('produits.index') }}" class="btn btn-secondary">Annuler</a>
    </form>
</div>
@endsection