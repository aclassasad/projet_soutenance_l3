<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Support\Facades\DB;

class EmployeeController extends Controller
{
    public function index()
    {
        // On récupère tous les utilisateurs
        $employees = User::select('id','name','email','role','statut')->get();

        $stats = [
            // ✅ total employés (hors admin)
            'total'     => $employees->whereIn('role', ['gerant','caissier'])->count(),
            'actifs' => $employees->where('statut', 1)
                      ->whereIn('role', ['gerant','caissier'])
                      ->count(),            'conges'    => $employees->where('statut', 0)->count(),
            'admins'    => $employees->where('role', 'admin')->count(),
            'gerants'   => $employees->where('role', 'gerant')->count(),
            'caissiers' => $employees->where('role', 'caissier')->count(),
        ];

        $roles = User::select('role', DB::raw('COUNT(*) as count'))
                     ->groupBy('role')
                     ->get();

        // ✅ on passe bien $employees à la vue
        return view('employees', compact('stats', 'employees', 'roles'));
    }
}