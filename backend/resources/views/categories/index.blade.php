@extends('layouts.app')

@section('title', 'Catégories')

@section('content')
<div class="container mt-4">
    <h3>Liste des Catégories</h3>

    <a href="{{ route('inventory') }}" class="btn btn-secondary mb-3">← Back to Inventory</a>
    <a href="{{ route('categories.create') }}" class="btn btn-success mb-3">+ Nouvelle Catégorie</a>

    @if(session('success'))
        <div class="alert alert-success">{{ session('success') }}</div>
    @endif

    <table class="table table-bordered">
        <thead>
            <tr>
                <th>ID</th>
                <th>Nom</th>
                <th>Description</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            @foreach($categories as $cat)
            <tr>
                <td>{{ $cat->id }}</td>
                <td>{{ $cat->nom }}</td>
                <td>{{ $cat->description }}</td>
                <td>
    <div class="btn-group" role="group">
        <a href="{{ route('categories.show', $cat) }}" class="btn btn-sm btn-outline-info" title="Voir">
            <i class="bi bi-eye"></i>
        </a>
        <a href="{{ route('categories.edit', $cat) }}" class="btn btn-sm btn-outline-primary" title="Modifier">
            <i class="bi bi-pencil"></i>
        </a>
        <form action="{{ route('categories.destroy', $cat) }}" method="POST" class="d-inline">
            @csrf
            @method('DELETE')
            <button class="btn btn-sm btn-outline-danger" title="Supprimer" onclick="return confirm('Supprimer cette catégorie ?')">
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