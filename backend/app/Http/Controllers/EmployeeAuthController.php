<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class EmployeeAuthController extends Controller
{
    public function showLoginForm()
    {
        return view('auth.employee-login');
    }

    public function login(Request $request)
    {
        $credentials = $request->validate([
            'email'    => ['required', 'email'],
            'password' => ['required'],
        ]);

        if (Auth::attempt($credentials)) {
            $request->session()->regenerate();

            $user = Auth::user();

            // Redirection selon le rôle
            if ($user->role === 'caissier') {
                return redirect()->route('caissier.dashboard');
            } elseif ($user->role === 'gerant') {
                return redirect()->route('dashboard'); // dashboard général
            } else {
                Auth::logout();
                return back()->withErrors([
                    'email' => 'Accès non autorisé pour ce rôle.',
                ]);
            }
        }

        return back()->withErrors([
            'email' => 'Identifiants incorrects.',
        ])->onlyInput('email');
    }
}