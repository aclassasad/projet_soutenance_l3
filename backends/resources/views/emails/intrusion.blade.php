<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Alerte Sécurité</title>
</head>
<body style="font-family: Arial, sans-serif; background-color:#f4f6f9; margin:0; padding:0;">
    <div style="max-width:600px; margin:auto; background:#ffffff; border-radius:10px; overflow:hidden; box-shadow:0 4px 12px rgba(0,0,0,0.1);">
        
        <!-- Logo de ton appli -->
        <div style="text-align:center; padding:20px; background:#343a40;">
            <img src="{{ $message->embed(public_path('images/icon.jpeg')) }}" alt="Logo ProSecure" style="height:70px;">
        </div>

        <!-- Contenu principal -->
        <div style="padding:30px;">
            <h2 style="color:#dc3545; text-align:center; margin-bottom:20px;">🚨 Intrusion détectée !</h2>
            
            <p style="font-size:16px; color:#333; line-height:1.6;">
                Cher <strong>{{ $owner->name }}</strong>,
            </p>
            <p style="font-size:16px; color:#333; line-height:1.6;">
                Un mouvement suspect a été détecté par le <strong>Détecteur PIR</strong>. 
                L’alarme a été déclenchée automatiquement.
            </p>

            <!-- Bloc de gravité -->
            <div style="background:#dc3545; color:#fff; padding:15px; border-radius:6px; text-align:center; font-weight:bold; font-size:18px; margin:20px 0;">
                ⚠️ Niveau de gravité : CRITIQUE
            </div>

            <p style="font-size:14px; color:#555; line-height:1.6;">
                Merci de vérifier immédiatement la situation.<br>
                — L’équipe <strong>SecureStorePro</strong>
            </p>
        </div>

        <!-- Footer -->
        <div style="background:#f1f3f5; padding:15px; text-align:center; font-size:12px; color:#666;">
            © 2026 SecureStorePro — Système d’alerte intelligent<br>
            <span style="color:#dc3545;">Ne pas répondre à ce mail automatique</span>
        </div>
    </div>
</body>
</html>
