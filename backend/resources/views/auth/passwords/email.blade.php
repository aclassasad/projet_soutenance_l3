@extends('layouts.auth')
@section('title', 'Mot de passe oublié')
@section('content')
<h3>Entrez votre email</h3>
<form method="POST" action="{{ route('password.sendCode') }}">
    @csrf
    <input type="email" name="email" class="form-control mb-3" required>
    <button type="submit" class="btn btn-primary w-100">Envoyer le code</button>
</form>
@endsection