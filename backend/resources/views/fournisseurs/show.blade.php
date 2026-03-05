@extends('layouts.app')

@section('title', 'Détails Fournisseur')

@section('content')
<div class="container mt-4">
    <h3>Détails du Fournisseur</h3>

    <div class="card">
        <div class="card-body">
            <h5 class="card-title">{{ $fournisseur->nom }}</h5>
            <p>Email : {{ $fournisseur->email }}</p>
            <p>Téléphone : {{ $fournisseur->telephone }}</p>
            <p>Adresse : {{ $fournisseur->adresse }}</p>
        </div>
    </div>

    <a href="{{ route('fournisseurs.index') }}" class="btn btn-outline-secondary mt-3">
        <i class="bi bi-arrow-left"></i> Retour
    </a>

    <a href="{{ route('fournisseurs.edit', $fournisseur) }}" class="btn btn-outline-primary mt-3">
        <i class="bi bi-pencil"></i> Modifier
    </a>
</div>
@endsection