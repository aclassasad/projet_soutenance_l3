<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Password;
use Illuminate\Support\Facades\Hash;


class AuthController extends Controller
{
    public function showLoginForm()
    {
        return view('auth.login');
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

        // Redirection selon rôle
        if ($user->role === 'admin' || $user->role === 'gerant') {
            return redirect()->route('dashboard');
        } elseif ($user->role === 'caissier') {
            return redirect()->route('caissier.dashboard');
        }

        // Rôle inconnu → déconnexion
        Auth::logout();
        return redirect()->route('login')->withErrors([
            'email' => 'Votre rôle n’est pas autorisé.',
        ]);
    }

    return back()->withErrors([
        'email' => 'Identifiants incorrects.',
    ])->onlyInput('email');
}

    public function logout(Request $request)
    {
        Auth::logout();
        $request->session()->invalidate();
        $request->session()->regenerateToken();

        return redirect('/login');
    }



}