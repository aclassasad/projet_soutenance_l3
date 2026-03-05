<!DOCTYPE html>
<html lang="{{ app()->getLocale() }}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Connexion Employé</title>
    <link rel="stylesheet" href="{{ asset('css/connexion.css') }}">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
</head>
<body>
    <div class="droite">
        <div class="wow">
            <h2>Connexion Employé</h2>
            <form method="POST" action="{{ route('employee.login.post') }}">
                @csrf
                <label for="email">Email</label>
                <input type="email" id="email" name="email" placeholder="Entrer votre adresse email" required>

                <label for="password">Mot de passe</label>
                <input type="password" id="password" name="password" placeholder="Entrer votre mot de passe" required>

                <button type="submit" class="connexion-button">Connexion</button>
            </form>
        </div>
    </div>
</body>
</html>