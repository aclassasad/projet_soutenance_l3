<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Equipement;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Log;
use App\Models\User;
use App\Mail\IntrusionMail;
use App\Models\Notification;



class EquipementController extends Controller
{
    // 🔹 Mise à jour par le détecteur PIR (ESP32)use Illuminate\Support\Facades\Mail;

public function updateEtatGet($mac)
{
    // Chercher l'équipement par adresse_mac
    $equipement = Equipement::where('adresse_mac', $mac)->first();

    if ($equipement) {
        // Mise à jour si trouvé
        $equipement->etat = 1;
        $equipement->action = 1;
        $equipement->description = "Mouvement détecté";
        $equipement->save();
    } else {
        // Création si non trouvé (⚠️ ici tu dois passer l'ID de l’admin propriétaire)
        $equipement = Equipement::create([
            'adresse_mac' => $mac,
            'etat' => 1,
            'action' => 1,
            'nom' => 'Detecteur PIR',
            'description' => 'Mouvement détecté',
            'user_id' => 1 // 🔹 exemple : ID de l’admin propriétaire
        ]);
    }

    // Vérifier si la détection de mouvement est activée
    $motionDetectionEnabled = cache('motion_detection_enabled', true); 
    $alarme = null;
    $mailSent = false;

    if ($motionDetectionEnabled) {
        $alarme = Equipement::where('nom', 'Alarme')->first();
        if ($alarme) {
            $alarme->etat = 1;
            $alarme->action = 1;
            $alarme->description = "Alarme activée automatiquement (mouvement détecté)";
            $alarme->save();

            // 🔹 Récupérer l’admin lié à l’alarme
            if ($alarme->user) {
                $owner = $alarme->user;
                if ($owner && $owner->email) {

Mail::to($owner->email)->send(new IntrusionMail($owner));

                    $mailSent = true;

                    // ✅ Log interne
                    Log::info("Email envoyé à l’admin ".$owner->email." suite à une détection PIR.");
                }
            }
            Notification::create([
    'title' => '🚨 Intrusion détectée',
    'message' => 'Un mouvement suspect a été détecté par le PIR. L’alarme a été déclenchée.',
    'type' => 'urgent',
    'read' => false,
    'created_at' => now(),
]);
        }
    }

    return response()->json([
        'success' => true,
        'message' => 'Détecteur PIR mis à jour' . ($motionDetectionEnabled ? ' + alarme activée' : ' (alarme ignorée car détecteur désactivé)'),
        'data' => $equipement,
        'alarme' => $alarme,
        'mail_sent' => $mailSent ? "✅ Email envoyé au propriétaire" : "❌ Email non envoyé"
    ]);
}



    // 🔹 Récupérer tous les incidents (pour Flutter)
    public function getIncidents()
    {
        return response()->json(
            Equipement::orderBy('updated_at', 'desc')->get()
        );
    }

    // 🔹 Statistiques globales de sécurité
    public function getSecurityStats()
    {
        $activeIncidents = Equipement::where('action', 1)->count();

        $status = "OK";
        if ($activeIncidents > 0) {
            $status = "Warning";
        }
        if ($activeIncidents > 5) {
            $status = "Critical";
        }

        return response()->json([
            'system_status' => $status,
            'active_incidents' => $activeIncidents
        ]);
    }

    // 🔹 Statistiques par type/sévérité (optionnel)
    public function getIncidentStats()
    {
        $stats = [
            'high' => Equipement::where('etat', 1)->count(),
            'medium' => Equipement::where('etat', 0)->count(),
            'low' => Equipement::count()
        ];

        return response()->json($stats);
    }

    // 🔹 Marquer un incident comme "en investigation"
    public function investigateIncident($id)
    {
        $equipement = Equipement::find($id);
        if (!$equipement) {
            return response()->json(['error' => 'Incident introuvable'], 404);
        }

        $equipement->description .= " (En investigation)";
        $equipement->save();

        return response()->json([
            'success' => true,
            'message' => "Incident $id en investigation",
            'data' => $equipement
        ]);
    }

    // 🔹 Activer/Désactiver la détection de mouvement
   public function toggleMotionDetection(Request $request)
{
    $enabled = $request->input('enabled', false);

    // Stocker l’état global (ici dans le cache, mais tu peux utiliser une table Config)
    cache(['motion_detection_enabled' => $enabled], 3600);

    return response()->json([
        'success' => true,
        'motion_detection' => $enabled
    ]);
}

    // 🔹 Activer/Désactiver l’alarme
   public function toggleAlarm(Request $request)
{
    $active = $request->input('active', false);

    // 🔹 Mise à jour de l’alarme
    $alarme = Equipement::where('nom', 'Alarme')->first();
    if ($alarme) {
        if ($active) {
            $alarme->etat = 1;
            $alarme->action = 1;
            $alarme->description = "Alarme activée manuellement";
        } else {
            $alarme->etat = 0;
            $alarme->action = 0;
            $alarme->description = "Alarme désactivée manuellement";
        }
        $alarme->save();
    }

    // 🔹 Remettre le détecteur PIR à 0 quand on coupe l’alarme
    $pir = Equipement::where('nom', 'Detecteur PIR')->first();
    if ($pir && !$active) {
        $pir->action = 0;
        $pir->etat = 0;
        $pir->description = "Fin de mouvement (alarme désactivée)";
        $pir->save();
    }

    return response()->json([
        'success' => true,
        'alarm' => $active
    ]);
}

}
