@extends('layouts.app')

@section('title', 'Modifier un employé')

@section('content')
<div class="container mt-4">
    <h3>Modifier Employé</h3>

    <form action="{{ route('users.update', $user) }}" method="POST">
        @csrf
        @method('PUT')

        <div class="mb-3">
            <label for="name" class="form-label">Nom</label>
            <input type="text" name="name" id="name" class="form-control" value="{{ $user->name }}" required>
        </div>

        <div class="mb-3">
            <label for="email" class="form-label">Email</label>
            <input type="email" name="email" id="email" class="form-control" value="{{ $user->email }}" required>
        </div>

        <div class="mb-3">
            <label for="role" class="form-label">Rôle</label>
            <select name="role" id="role" class="form-select" required>
                <option value="admin" {{ $user->role == 'admin' ? 'selected' : '' }}>Admin</option>
                <option value="gerant" {{ $user->role == 'gerant' ? 'selected' : '' }}>Gérant</option>
                <option value="caissier" {{ $user->role == 'caissier' ? 'selected' : '' }}>Caissier</option>
            </select>
        </div>

        <div class="mb-3">
            <label for="statut" class="form-label">Statut</label>
            <select name="statut" id="statut" class="form-select">
                <option value="1" {{ $user->statut ? 'selected' : '' }}>Actif</option>
                <option value="0" {{ !$user->statut ? 'selected' : '' }}>En congé</option>
            </select>
        </div>

        <button type="submit" class="btn btn-primary">Mettre à jour</button>
        <a href="{{ route('users.index') }}" class="btn btn-secondary">Annuler</a>
    </form>
</div>
@endsection