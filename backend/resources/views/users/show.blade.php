@extends('layouts.app')

@section('title', 'Détails Employé')

@section('content')
<div class="container mt-4">
    <h3>Détails de l’employé</h3>

    <div class="card">
        <div class="card-body">
            <h5 class="card-title">{{ $user->name }}</h5>
            <p>Email : {{ $user->email }}</p>
            <p>Rôle : {{ ucfirst($user->role) }}</p>
            <p>Statut : {{ $user->statut ? 'Actif' : 'En congé' }}</p>
        </div>
    </div>

    <a href="{{ route('users.index') }}" class="btn btn-outline-secondary mt-3">
        <i class="bi bi-arrow-left"></i> Retour
    </a>

    <a href="{{ route('users.edit', $user) }}" class="btn btn-outline-primary mt-3">
        <i class="bi bi-pencil"></i> Modifier
    </a>
</div>
@endsection