@extends('layouts.auth')
@section('title', 'Vérification du code')

@section('content')
<h3>Entrez le code reçu et votre nouveau mot de passe</h3>

@if(session('status'))
    <div class="alert alert-success">{{ session('status') }}</div>
@endif

@if($errors->any())
    <div class="alert alert-danger">
        <ul class="mb-0">
            @foreach($errors->all() as $error)
                <li>{{ $error }}</li>
            @endforeach
        </ul>
    </div>
@endif

<form method="POST" action="{{ route('password.verifyCode') }}">
    @csrf

    <div class="mb-3">
        <input type="text" name="code"
               class="form-control @error('code') is-invalid @enderror"
               placeholder="Code à 6 chiffres" required>
        @error('code')
            <div class="invalid-feedback">{{ $message }}</div>
        @enderror
    </div>

    {{-- Champ mot de passe avec barre de progression --}}
    <div class="mb-3">
        <input type="password" id="password" name="password"
               class="form-control @error('password') is-invalid @enderror"
               placeholder="Nouveau mot de passe" required>
        <div id="passwordHelp" class="form-text text-muted">
            Le mot de passe doit contenir au moins 8 caractères, une majuscule, un chiffre et un caractère spécial.
        </div>
        <div class="progress mt-2">
            <div id="passwordStrength" class="progress-bar" role="progressbar" style="width: 0%">
                Faible
            </div>
        </div>
        @error('password')
            <div class="invalid-feedback">{{ $message }}</div>
        @enderror
    </div>

    {{-- Confirmation --}}
    <div class="mb-3">
        <input type="password" id="password_confirmation" name="password_confirmation"
               class="form-control @error('password_confirmation') is-invalid @enderror"
               placeholder="Confirmer le mot de passe" required>
        <div id="confirmFeedback" class="invalid-feedback"></div>
        @error('password_confirmation')
            <div class="invalid-feedback">{{ $message }}</div>
        @enderror
    </div>

    <button type="submit" class="btn btn-success w-100">Changer le mot de passe</button>
</form>

{{-- Script JS pour la vérification en temps réel --}}
<script>
document.addEventListener('DOMContentLoaded', function () {
    const password = document.getElementById('password');
    const confirm = document.getElementById('password_confirmation');
    const strengthBar = document.getElementById('passwordStrength');
    const confirmFeedback = document.getElementById('confirmFeedback');

    password.addEventListener('input', function () {
        const value = password.value;
        let strength = 0;

        if (value.length >= 8) strength++;
        if (/[A-Z]/.test(value)) strength++;
        if (/\d/.test(value)) strength++;
        if (/[^A-Za-z\d]/.test(value)) strength++;

        // Mise à jour de la barre
        switch (strength) {
            case 0:
            case 1:
                strengthBar.style.width = "25%";
                strengthBar.className = "progress-bar bg-danger";
                strengthBar.textContent = "Faible";
                break;
            case 2:
                strengthBar.style.width = "50%";
                strengthBar.className = "progress-bar bg-warning";
                strengthBar.textContent = "Moyen";
                break;
            case 3:
                strengthBar.style.width = "75%";
                strengthBar.className = "progress-bar bg-info";
                strengthBar.textContent = "Bon";
                break;
            case 4:
                strengthBar.style.width = "100%";
                strengthBar.className = "progress-bar bg-success";
                strengthBar.textContent = "Fort";
                break;
        }
    });

    confirm.addEventListener('input', function () {
        if (confirm.value !== password.value) {
            confirm.classList.add('is-invalid');
            confirmFeedback.textContent = "Les deux mots de passe ne correspondent pas.";
        } else {
            confirm.classList.remove('is-invalid');
            confirm.classList.add('is-valid');
            confirmFeedback.textContent = "";
        }
    });
});
</script>
@endsection