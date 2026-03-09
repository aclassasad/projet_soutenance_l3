<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\App;

class SettingsController extends Controller
{
    public function index()
    {
        // Charger les paramètres depuis la session
        $settings = session('settings', [
            'language' => 'fr',
            'theme'    => 'light',
        ]);

        // ✅ appliquer la langue immédiatement
        App::setLocale($settings['language']);

        return view('settings', compact('settings'));
    }

public function update(Request $request)
{
    // Sauvegarde du thème pour l'utilisateur (si vous avez une colonne 'theme' dans users)
    if (auth()->check()) {
        $user = auth()->user();
        $user->theme = $request->theme;
        $user->save();
    }

    // Change la langue en session
    if ($request->has('language')) {
        session(['locale' => $request->language]);
    }

    // Optionnel : thème aussi en session si pas de base de données
    session(['theme' => $request->theme]);

    return redirect()->back()->with('success', 'Paramètres mis à jour.');
}
}