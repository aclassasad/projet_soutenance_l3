@extends('layouts.app')

@section('title', 'Fournisseurs')

@section('content')
<div class="container mt-4">
    <h3>Liste des Fournisseurs</h3>

    <!-- Boutons -->
    <a href="{{ route('fournisseurs.create') }}" class="btn btn-success mb-3">+ Nouveau Fournisseur</a>
    <a href="{{ route('inventory') }}" class="btn btn-secondary mb-3">← Retour à l’inventaire</a>

    @if(session('success'))
        <div class="alert alert-success">{{ session('success') }}</div>
    @endif

    <table class="table table-bordered">
        <thead>
            <tr>
                <th>ID</th>
                <th>Nom</th>
                <th>Email</th>
                <th>Téléphone</th>
                <th>Adresse</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            @foreach($fournisseurs as $fournisseur)
            <tr>
                <td>{{ $fournisseur->id }}</td>
                <td>{{ $fournisseur->nom }}</td>
                <td>{{ $fournisseur->email }}</td>
                <td>{{ $fournisseur->telephone }}</td>
                <td>{{ $fournisseur->adresse }}</td>
                <td>
                    <div class="btn-group" role="group">
                        <a href="{{ route('fournisseurs.show', $fournisseur) }}" class="btn btn-sm btn-outline-info" title="Voir">
                            <i class="bi bi-eye"></i>
                        </a>
                        <a href="{{ route('fournisseurs.edit', $fournisseur) }}" class="btn btn-sm btn-outline-primary" title="Modifier">
                            <i class="bi bi-pencil"></i>
                        </a>
                        <form action="{{ route('fournisseurs.destroy', $fournisseur) }}" method="POST" class="d-inline">
                            @csrf
                            @method('DELETE')
                            <button class="btn btn-sm btn-outline-danger" title="Supprimer" onclick="return confirm('Supprimer ce fournisseur ?')">
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