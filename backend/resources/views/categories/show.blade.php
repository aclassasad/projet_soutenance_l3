@extends('layouts.app')

@section('title', 'Détails Catégorie')

@section('content')
<div class="container mt-4">
    <h3>Détails de la Catégorie</h3>

    <div class="card">
        <div class="card-body">
            <h5 class="card-title">{{ $categorie->nom }}</h5>
            <p class="card-text">{{ $categorie->description }}</p>
        </div>
    </div>

    <h4 class="mt-4">Produits associés</h4>
    @if($categorie->produits->count() > 0)
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>Nom</th>
                    <th>Prix Vente</th>
                    <th>Stock</th>
                </tr>
            </thead>
            <tbody>
                @foreach($categorie->produits as $produit)
                <tr>
                    <td>{{ $produit->nom }}</td>
                    <td>{{ $produit->prix_vente }}</td>
                    <td>{{ $produit->stock }}</td>
                </tr>
                @endforeach
            </tbody>
        </table>
    @else
        <p>Aucun produit dans cette catégorie.</p>
    @endif

    <a href="{{ route('categories.index') }}" class="btn btn-outline-secondary mt-3">
    <i class="bi bi-arrow-left"></i> Retour
</a>

<a href="{{ route('categories.edit', $categorie) }}" class="btn btn-outline-primary mt-3">
    <i class="bi bi-pencil"></i> Modifier
</a>
</div>
@endsection