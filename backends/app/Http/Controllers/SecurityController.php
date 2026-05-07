<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class SecurityController extends Controller
{
    // 🔹 Statistiques globales de sécurité
    public function stats()
    {
        return response()->json([
            'active_incidents' => DB::table('incidents')->where('status', 'active')->count(),
            'recording' => true,
            'system_status' => 'OK',
        ], 200);
    }

    // 🔹 Liste des incidents
    public function incidents()
    {
        $incidents = DB::table('incidents')
            ->select('id', 'description', 'location', 'date', 'status')
            ->orderByDesc('date')
            ->take(10)
            ->get();

        return response()->json($incidents, 200);
    }

    // 🔹 Statistiques par type d’incident
    public function incidentStats()
    {
        $stats = DB::table('incidents')
            ->select('type', DB::raw('COUNT(*) as count'))
            ->groupBy('type')
            ->get();

        return response()->json($stats, 200);
    }

    // 🔹 Mettre un incident en investigation
    public function investigate($id)
    {
        DB::table('incidents')->where('id', $id)->update(['status' => 'investigation']);
        return response()->json(['message' => "Incident $id en investigation"], 200);
    }
}