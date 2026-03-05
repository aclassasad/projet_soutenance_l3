@extends('layouts.app')

@section('title', 'Détails Produit')

@section('content')
<div class="container mt-4">
    <h3>Détails du Produit</h3>

    <div class="card">
        <div class="card-body">
            <h5 class="card-title">{{ $produit->nom }}</h5>
            <p class="card-text">{{ $produit->description }}</p>
            <ul class="list-group list-group-flush">
                <li class="list-group-item"><strong>Prix d'achat :</strong> {{ $produit->prix_achat }} FCFA</li>
                <li class="list-group-item"><strong>Prix de vente :</strong> {{ $produit->prix_vente }} FCFA</li>
                <li class="list-group-item"><strong>Stock :</strong> {{ $produit->stock }}</li>
                <li class="list-group-item"><strong>Seuil alerte :</strong> {{ $produit->seuil_alerte }}</li>
                <li class="list-group-item"><strong>Catégorie :</strong> {{ $produit->categorie->nom ?? 'N/A' }}</li>
                <li class="list-group-item"><strong>Fournisseur :</strong> {{ $produit->fournisseur->nom ?? 'N/A' }}</li>
            </ul>
        </div>
    </div>

    <a href="{{ route('produits.index') }}" class="btn btn-secondary mt-3">Retour</a>
    <a href="{{ route('produits.edit', $produit->id) }}" class="btn btn-primary mt-3">Modifier</a>
</div>
@endsection