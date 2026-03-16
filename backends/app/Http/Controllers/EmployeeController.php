<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use App\Models\Vente;


class EmployeeController extends Controller
{
    // 🔹 Statistiques sur les employés
    public function stats()
{
    try {
        $employees = User::select('id','name','email','role','statut')->get();

        $stats = [
            // ✅ total employés (hors admin)
            'total'     => $employees->whereIn('role', ['gerant','caissier'])->count(),

            // ✅ actifs aujourd'hui (statut = 1, hors admin)
            'actifs'    => $employees->where('statut', 1)
                                     ->whereIn('role', ['gerant','caissier'])
                                     ->count(),

            // ✅ en congé (statut = 0, hors admin)
            'conges'    => $employees->where('statut', 0)
                                     ->whereIn('role', ['gerant','caissier'])
                                     ->count(),

            // ✅ pour info : admins, gerants, caissiers
            'admins'    => $employees->where('role', 'admin')->count(),
            'gerants'   => $employees->where('role', 'gerant')->count(),
            'caissiers' => $employees->where('role', 'caissier')->count(),
        ];

        return response()->json($stats, 200);
    } catch (\Exception $e) {
        return response()->json([
            'error' => 'Erreur lors du calcul des statistiques',
            'details' => $e->getMessage(),
        ], 500);
    }
}

    // 🔹 Liste des employés
    public function index()
    {
        try {
            $employes = User::select('id', 'name', 'email', 'role', 'statut')->get();
            return response()->json($employes, 200);
        } catch (\Exception $e) {
            return response()->json([
                'error' => 'Erreur lors du chargement des employés',
                'details' => $e->getMessage(),
            ], 500);
        }
    }

    // 🔹 Créer un employé
    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|email|unique:users,email',
            'password' => 'required|string|min:6',
            'role' => 'required|string|in:gerant,caissier,admin',
            'statut' => 'required|boolean',
        ]);

        $validated['password'] = bcrypt($validated['password']);

        $employe = User::create($validated);
        return response()->json($employe, 201);
    }

    // 🔹 Détail d’un employé
    public function show($id)
    {
        $employe = User::select('id', 'name', 'email', 'role', 'statut')->findOrFail($id);
        return response()->json($employe, 200);
    }

    // 🔹 Mettre à jour un employé
    public function update(Request $request, $id)
    {
        $employe = User::findOrFail($id);

        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|email|unique:users,email,' . $employe->id,
            'role' => 'required|string|in:gerant,caissier,admin',
            'statut' => 'required|boolean',
            'password' => 'nullable|string|min:6',
        ]);

        if (!empty($validated['password'])) {
            $validated['password'] = bcrypt($validated['password']);
        } else {
            unset($validated['password']);
        }

        $employe->update($validated);
        return response()->json($employe, 200);
    }

    // 🔹 Supprimer un employé
    public function destroy($id)
    {
        $employe = User::findOrFail($id);
        $employe->delete();
        return response()->json(null, 204);
    }

public function ventes($id)
{
    try {
        $ventes = Vente::with(['lignes.produit'])
            ->where('user_id', $id)
            ->get();

        return response()->json($ventes, 200);
    } catch (\Exception $e) {
        return response()->json([
            'error' => 'Erreur lors du chargement des ventes',
            'details' => $e->getMessage(),
        ], 500);
    }
}

}