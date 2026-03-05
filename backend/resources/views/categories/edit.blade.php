@extends('layouts.app')

@section('title', 'Modifier une catégorie')

@section('content')
<div class="container mt-4">
    <h3>Modifier Catégorie</h3>

    <form action="{{ route('categories.update', $categorie) }}" method="POST">
    @csrf
    @method('PUT')

    <div class="mb-3">
        <label for="nom" class="form-label">Nom de la catégorie</label>
        <input type="text" name="nom" id="nom" class="form-control" value="{{ $categorie->nom }}" required>
    </div>

    <div class="mb-3">
        <label for="description" class="form-label">Description</label>
        <textarea name="description" id="description" class="form-control">{{ $categorie->description }}</textarea>
    </div>

    <button type="submit" class="btn btn-primary">Mettre à jour</button>
    <a href="{{ route('categories.index') }}" class="btn btn-secondary">Annuler</a>
</form>
</div>
@endsection