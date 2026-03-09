@extends('layouts.app')

@section('title', 'Ajouter un employé')

@section('content')
<div class="container mt-4">
    <h3>Ajouter un employé</h3>

    <form action="{{ route('users.store') }}" method="POST">
        @csrf

        <div class="mb-3">
            <label for="name" class="form-label">Nom</label>
            <input type="text" name="name" id="name" class="form-control" required>
        </div>

        {{-- Champ email avec validation --}}
        <div class="mb-3">
            <label for="email" class="form-label">Email</label>
            <input type="email" name="email" id="email" class="form-control" required>
            <div id="emailFeedback" class="text-danger mt-1"></div>
        </div>

        {{-- Champ mot de passe avec conditions et barre --}}
        <div class="mb-3">
            <label for="password" class="form-label">Mot de passe</label>
            <div class="input-group">
                <input type="password" name="password" id="password" class="form-control" required>
                <button type="button" class="btn btn-outline-secondary" id="togglePassword">
                    <i class="bi bi-eye"></i>
                </button>
            </div>

            <!-- Barre de progression -->
            <div class="progress mt-2">
                <div id="passwordStrength" class="progress-bar" role="progressbar" style="width: 0%">
                    Faible
                </div>
            </div>

            <!-- Conditions -->
            <ul class="mt-2 small">
                <li id="length" class="text-danger">❌ Au moins 8 caractères</li>
                <li id="uppercase" class="text-danger">❌ Au moins une majuscule</li>
                <li id="lowercase" class="text-danger">❌ Au moins une minuscule</li>
                <li id="number" class="text-danger">❌ Au moins un chiffre</li>
                <li id="special" class="text-danger">❌ Au moins un caractère spécial (@$!%*?&)</li>
            </ul>
        </div>

        {{-- Confirmation mot de passe --}}
        <div class="mb-3">
            <label for="password_confirmation" class="form-label">Confirmer le mot de passe</label>
            <div class="input-group">
                <input type="password" name="password_confirmation" id="password_confirmation" class="form-control" required>
                <button type="button" class="btn btn-outline-secondary" id="toggleConfirm">
                    <i class="bi bi-eye"></i>
                </button>
            </div>
            <div id="confirmFeedback" class="text-danger mt-1"></div>
        </div>

        <div class="mb-3">
            <label for="role" class="form-label">Rôle</label>
            <select name="role" id="role" class="form-select" required>
                <option value="admin">Admin</option>
                <option value="gerant">Gérant</option>
                <option value="caissier">Caissier</option>
            </select>
        </div>

        <div class="mb-3">
            <label for="statut" class="form-label">Statut</label>
            <select name="statut" id="statut" class="form-select">
                <option value="1">Actif</option>
                <option value="0">En congé</option>
            </select>
        </div>

        <button type="submit" class="btn btn-success">Créer</button>
        <a href="{{ route('users.index') }}" class="btn btn-secondary">Annuler</a>
    </form>
</div>
@endsection

@push('scripts')
<script>
document.addEventListener('DOMContentLoaded', function () {
    const email = document.getElementById('email');
    const emailFeedback = document.getElementById('emailFeedback');
    const password = document.getElementById('password');
    const confirm = document.getElementById('password_confirmation');
    const strengthBar = document.getElementById('passwordStrength');
    const confirmFeedback = document.getElementById('confirmFeedback');
    const togglePassword = document.getElementById('togglePassword');
    const toggleConfirm = document.getElementById('toggleConfirm');

    // Vérification email en temps réel
    email.addEventListener('input', function () {
        const value = email.value;
        const regex = /^[^@\s]+@[^@\s]+\.[^@\s]+$/;
        if (regex.test(value)) {
            email.classList.remove('is-invalid');
            email.classList.add('is-valid');
            emailFeedback.classList.replace('text-danger','text-success');
        } else {
            email.classList.remove('is-valid');
            email.classList.add('is-invalid');
            emailFeedback.classList.replace('text-success','text-danger');
        }
    });

    // Afficher/masquer mot de passe
    togglePassword.addEventListener('click', function () {
        const type = password.getAttribute('type') === 'password' ? 'text' : 'password';
        password.setAttribute('type', type);
        this.innerHTML = type === 'password' ? '<i class="bi bi-eye"></i>' : '<i class="bi bi-eye-slash"></i>';
    });

    // Afficher/masquer confirmation
    toggleConfirm.addEventListener('click', function () {
        const type = confirm.getAttribute('type') === 'password' ? 'text' : 'password';
        confirm.setAttribute('type', type);
        this.innerHTML = type === 'password' ? '<i class="bi bi-eye"></i>' : '<i class="bi bi-eye-slash"></i>';
    });

    // Vérification force du mot de passe
    password.addEventListener('input', function () {
        const value = password.value;
        let strength = 0;

        if (value.length >= 8) { 
            document.getElementById('length').classList.replace('text-danger','text-success');
            document.getElementById('length').innerHTML = "✅ Au moins 8 caractères";
            strength++;
        } else {
            document.getElementById('length').classList.replace('text-success','text-danger');
            document.getElementById('length').innerHTML = "❌ Au moins 8 caractères";
        }

        if (/[A-Z]/.test(value)) {
            document.getElementById('uppercase').classList.replace('text-danger','text-success');
            document.getElementById('uppercase').innerHTML = "✅ Au moins une majuscule";
            strength++;
        } else {
            document.getElementById('uppercase').classList.replace('text-success','text-danger');
            document.getElementById('uppercase').innerHTML = "❌ Au moins une majuscule";
        }

        if (/[a-z]/.test(value)) {
            document.getElementById('lowercase').classList.replace('text-danger','text-success');
            document.getElementById('lowercase').innerHTML = "✅ Au moins une minuscule";
            strength++;
        } else {
            document.getElementById('lowercase').classList.replace('text-success','text-danger');
            document.getElementById('lowercase').innerHTML = "❌ Au moins une minuscule";
        }

        if (/\d/.test(value)) {
            document.getElementById('number').classList.replace('text-danger','text-success');
            document.getElementById('number').innerHTML = "✅ Au moins un chiffre";
            strength++;
        } else {
            document.getElementById('number').classList.replace('text-success','text-danger');
            document.getElementById('number').innerHTML = "❌ Au moins un chiffre";
        }

        if (/[@$!%*?&]/.test(value)) {
            document.getElementById('special').classList.replace('text-danger','text-success');
            document.getElementById('special').innerHTML = "✅ Au moins un caractère spécial (@$!%*?&)";
            strength++;
        } else {
            document.getElementById('special').classList.replace('text-success','text-danger');
            document.getElementById('special').innerHTML = "❌ Au moins un caractère spécial (@$!%*?&)";
        }

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
                break;            case 3:
                strengthBar.style.width = "75%";
                strengthBar.className = "progress-bar bg-info";
                strengthBar.textContent = "Bon";
                break;
            case 4:
            case 5:
                strengthBar.style.width = "100%";
                strengthBar.className = "progress-bar bg-success";
                strengthBar.textContent = "Fort";
                break;
        }
    });

    // Vérification confirmation mot de passe
    confirm.addEventListener('input', function () {
        if (confirm.value !== password.value) {
            confirm.classList.add('is-invalid');
            confirmFeedback.textContent = "❌ Les deux mots de passe ne correspondent pas.";
            confirmFeedback.classList.replace('text-success','text-danger');
        } else {
            confirm.classList.remove('is-invalid');
            confirm.classList.add('is-valid');
            confirmFeedback.textContent = "✅ Les deux mots de passe correspondent.";
            confirmFeedback.classList.replace('text-danger','text-success');
        }
    });
});
</script>
@endpush