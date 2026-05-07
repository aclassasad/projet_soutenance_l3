<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Bienvenue</title>
</head>
<body>
    <h2>Bonjour <?php echo e($user->name); ?>,</h2>
    <p>Votre compte a été ajoué dans la  base du SecureStorePro 🎉.</p>
    <p>Voici vos informations de connexion :</p>
    <ul>
        <li><strong>Email :</strong> <?php echo e($user->email); ?></li>
        <li><strong>Mot de passe :</strong> <?php echo e($password); ?></li>
    </ul>
    <p>Vous pouvez vous connecter dès maintenant à l’application.</p>
    <p>À bientôt,<br>L’équipe Support</p>
</body>
</html><?php /**PATH D:\modif\projet_soutenance_l3\backend\resources\views/emails/user_created.blade.php ENDPATH**/ ?>