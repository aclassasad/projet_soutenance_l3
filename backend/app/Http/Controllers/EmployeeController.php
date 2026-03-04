<?php

namespace App\Http\Controllers;   // ✅ namespace obligatoire
use App\Models\User;
use Illuminate\Support\Facades\DB;

class EmployeeController extends Controller
{
    public function index()
    {
        $stats = [
            'total'  => User::count(),
            'actifs' => User::where('statut', 1)->count(),
            'conges' => User::where('statut', 0)->count(),
            // ❌ supprime la ligne shifts si tu n’as pas de table shifts
        ];

        $employees = User::select('id','name','email','role','statut')->get();

        // ✅ Ajout pour le graphique des rôles
        $roles = User::select('role', DB::raw('COUNT(*) as count'))
                     ->groupBy('role')
                     ->get();

        return view('employees', compact('stats', 'employees', 'roles'));
    }
}