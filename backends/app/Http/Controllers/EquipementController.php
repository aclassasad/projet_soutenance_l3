<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Equipement;

class EquipementController extends Controller
{
    // Mise à jour par le détecteur PIR
    public function updateEtat(Request $request)
    {
        // Vérifie si l'équipement existe déjà
        $equipement = Equipement::where('adresse_mac', $request->adresse_mac)->first();

        if ($equipement) {
            // Met à jour les champs
            $equipement->etat = $request->etat;       // 1 = actif
            $equipement->action = $request->action;   // 1 = mouvement détecté
            $equipement->description = $request->description;
            $equipement->save();

            // Retour  pour test
            return response()->json([
                'success' => true,
                'message' => '✅ Mouvement détecté et enregistré dans la base',
                'data' => $equipement
            ]);
        }

        // Si l'équipement n'existe pas encore, on va le créer automatiquement dans notre base de donnée
        $equipement = Equipement::create([
            'adresse_mac' => $request->adresse_mac,
            'etat' => $request->etat,
            'action' => $request->action,
            'nom' => 'Detecteur PIR',
            'description' => $request->description,
        ]);

        return response()->json([
            'success' => true,
            'message' => '✅ Mouvement détecté et nouvel équipement créé',
            'data' => $equipement
        ]);
    }
}
