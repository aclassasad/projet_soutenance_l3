<?php

namespace App\Http\Controllers;

use App\Models\User;

class EmployesController extends Controller
{
    public function stats()
    {
        return response()->json([
            'total_employes' => User::count(),
            'actifs' => User::where('statut', true)->count(),
            'inactifs' => User::where('statut', false)->count(),
        ]);
    }

    public function list()
    {
        return response()->json(
            User::select('id','name','email','role','statut')
                ->get()
        );
    }
}