<?php
namespace App\Http\Controllers\Frontend;

use App\Http\Controllers\Controller;
use App\Models\Incident;

class SecurityPageController extends Controller
{
    public function index()
    {
        $stats = [
            'cameras_online' => 6, // valeur fictive
            'active_incidents' => Incident::where('status','ACTIVE')->count(),
            'recording' => 7, // valeur fictive
            'system_status' => 'Secure',
            'system_status_class' => 'text-success',
        ];

        $incidents = Incident::orderBy('created_at','desc')->take(10)->get();

        return view('security', compact('stats','incidents'));
    }
}