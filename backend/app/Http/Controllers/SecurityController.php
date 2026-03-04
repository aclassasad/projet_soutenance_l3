<?php

namespace App\Http\Controllers;use App\Models\Incident;
use App\Models\Camera;
use Illuminate\Support\Facades\DB;

class SecurityController extends Controller
{
    public function index()
    {
        $stats = [
            'cameras_online' => Camera::where('status', 'ONLINE')->count(),
            'active_incidents' => Incident::where('status','ACTIVE')->count(),
            'recording' => Camera::where('status', 'RECORDING')->count(),
            'system_status' => 'Secure',
            'system_status_class' => 'text-success',
        ];

        // Incidents récents
        $incidents = Incident::orderBy('created_at','desc')
                             ->take(10)
                             ->get(['description','location','date','type']);

        // Statistiques par type d’incident
        $incidentStats = Incident::select(
                'type',
                DB::raw('COUNT(*) as count')
            )
            ->groupBy('type')
            ->get()
            ->toArray();

        return view('security', compact('stats', 'incidents', 'incidentStats'));
    }
}