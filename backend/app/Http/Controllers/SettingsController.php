<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class SettingsController extends Controller
{
    public function index()
    {
        // Charger les paramètres depuis la session, ou valeurs par défaut
        $settings = session('settings', [
            'language' => 'fr',
            'theme' => 'light',
        ]);

        return view('settings', compact('settings'));
    }

    public function update(Request $request)
    {
        // Sauvegarder les paramètres en session
        session([
            'settings' => [
                'language' => $request->input('language'),
                'theme' => $request->input('theme'),
            ]
        ]);

        return redirect()->route('settings')->with('success', 'Paramètres mis à jour.');
    }

    public function security(Request $request)
    {
        // Exemple : paramètres de sécurité en session
        session([
            'security' => [
                'two_factor' => $request->input('two_factor', false),
            ]
        ]);

        return redirect()->route('settings')->with('success', 'Paramètres de sécurité mis à jour.');
    }
}