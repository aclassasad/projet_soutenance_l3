<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Mail;
use App\Mail\UserCreatedMail;

class UserController extends Controller
{
    // Afficher la liste des utilisateurs avec stats
    public function index()
    {
        $users = User::all();

        $stats = [
            'total' => $users->count(),
            'admins' => $users->where('role', 'admin')->count(),
            'gerants' => $users->where('role', 'gerant')->count(),
            'caissiers' => $users->where('role', 'caissier')->count(),
        ];

        $roles = $users->groupBy('role')->map(function ($group) {
            return [
                'role' => $group->first()->role,
                'count' => $group->count()
            ];
        });

        return view('users.index', compact('users', 'stats', 'roles'));
    }

    // Formulaire de création
    public function create()
    {
        return view('users.create');
    }

    // Sauvegarder un nouvel utilisateur
 
public function store(Request $request)
{
    $request->validate([
        'name' => 'required',
        'email' => 'required|email|unique:users',
        'password' => [
            'required',
            'string',
            'min:8',
            'regex:/[A-Z]/',
            'regex:/[a-z]/',
            'regex:/[0-9]/',
            'regex:/[@$!%*?&]/'
        ],
        'password_confirmation' => 'required|same:password',
        'role' => 'required|in:admin,caissier,gerant',
        'statut' => 'boolean'
    ], [
        'password.regex' => 'Le mot de passe doit contenir au moins une majuscule, une minuscule, un chiffre et un caractère spécial.',
        'password_confirmation.same' => 'La confirmation du mot de passe ne correspond pas.'
    ]);

    // Création de l'utilisateur
    $user = User::create([
        'name' => $request->name,
        'email' => $request->email,
        'password' => Hash::make($request->password),
        'role' => $request->role,
        'statut' => $request->statut ?? true,
    ]);

    // Envoi du mail avec ses coordonnées
    Mail::to($user->email)->send(new UserCreatedMail($user, $request->password));

    return redirect()->route('users.index')->with('success', 'Employé créé avec succès et email envoyé.');
}
    // Afficher un utilisateur
    public function show(User $user)
    {
        return view('users.show', compact('user'));
    }

    // Formulaire d’édition
    public function edit(User $user)
    {
        return view('users.edit', compact('user'));
    }

    // Mettre à jour un utilisateur
    public function update(Request $request, User $user)
    {
        $request->validate([
            'name' => 'required',
            'email' => 'required|email|unique:users,email,' . $user->id,
            'role' => 'required|in:admin,caissier,gerant',
            'statut' => 'boolean'
        ]);

        $user->update([
            'name' => $request->name,
            'email' => $request->email,
            'role' => $request->role,
            'statut' => $request->statut,
        ]);

        return redirect()->route('users.index')->with('success', 'Employé mis à jour.');
    }

    // Supprimer un utilisateur
    public function destroy(User $user)
    {
        $user->delete();
        return redirect()->route('users.index')->with('success', 'Employé supprimé.');
    }
}