@extends('layouts.app')

@section('title', 'Produits')

@section('content')
<div class="container mt-4">
    <h3>Liste des Produits</h3>

    <!-- ✅ Bouton retour vers Inventory -->
    <a href="{{ route('inventory') }}" class="btn btn-secondary mb-3">← Back to Inventory</a>
    <a href="{{ route('produits.create') }}" class="btn btn-success mb-3">+ Nouveau Produit</a>

    @if(session('success'))
        <div class="alert alert-success">{{ session('success') }}</div>
    @endif

    <table class="table table-striped">
        <thead>
            <tr>
                <th>ID</th>
                <th>Nom</th>
                <th>Description</th>
                <th>Prix Achat</th>
                <th>Prix Vente</th>
                <th>Stock</th>
                <th>Catégorie</th>
                <th>Fournisseur</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            @foreach($produits as $p)
            <tr>
                <td>{{ $p->id }}</td>
                <td>{{ $p->nom }}</td>
                <td>{{ $p->description }}</td>
                <td>{{ $p->prix_achat }}</td>
                <td>{{ $p->prix_vente }}</td>
                <td>{{ $p->stock }}</td>
                <td>{{ $p->categorie->nom ?? 'N/A' }}</td>
                <td>{{ $p->fournisseur->nom ?? 'N/A' }}</td>
               <td>
    <div class="btn-group" role="group">
        <a href="{{ route('produits.show', $p->id) }}" class="btn btn-sm btn-outline-info" title="Voir">
            <i class="bi bi-eye"></i>
        </a>
        <a href="{{ route('produits.edit', $p->id) }}" class="btn btn-sm btn-outline-primary" title="Modifier">
            <i class="bi bi-pencil"></i>
        </a>
        <form action="{{ route('produits.destroy', $p->id) }}" method="POST" class="d-inline">
            @csrf
            @method('DELETE')
            <button class="btn btn-sm btn-outline-danger" title="Supprimer" onclick="return confirm('Supprimer ce produit ?')">
                <i class="bi bi-trash"></i>
            </button>
        </form>
    </div>
</td>
            </tr>
            @endforeach
        </tbody>
    </table>
</div>
@endsection