<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Bienvenue</title>
</head>
<body>
    <h2>Bonjour {{ $user->name }},</h2>
    <p>Votre compte a été ajoué dans la  base du SecureStorePro 🎉.</p>
    <p>Voici vos informations de connexion :</p>
    <ul>
        <li><strong>Email :</strong> {{ $user->email }}</li>
        <li><strong>Mot de passe :</strong> {{ $password }}</li>
    </ul>
    <p>Vous pouvez vous connecter dès maintenant à l’application.</p>
    <p>À bientôt,<br>L’équipe Support</p>
</body>
</html>