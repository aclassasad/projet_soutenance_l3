@extends('layouts.auth')
@section('title', 'Réinitialiser le mot de passe')

@section('content')
<h3>Définir un nouveau mot de passe</h3>
<form method="POST" action="{{ route('password.update') }}">
    @csrf
    <input type="hidden" name="token" value="{{ $token }}">
    <input type="email" name="email" class="form-control mb-3" placeholder="Votre email" required>
    <input type="password" name="password" class="form-control mb-3" placeholder="Nouveau mot de passe" required>
    <input type="password" name="password_confirmation" class="form-control mb-3" placeholder="Confirmer le mot de passe" required>
    <button type="submit" class="btn btn-success w-100">Changer le mot de passe</button>
</form>
@endsection