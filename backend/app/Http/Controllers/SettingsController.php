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
        // Sauvegarder les paramètres en session
        session([
            'settings' => [
                'language' => $request->input('language'),
                'theme'    => $request->input('theme'),
            ]
        ]);

        // ✅ appliquer la langue immédiatement
        App::setLocale($request->input('language'));

        return redirect()->route('settings')->with('success', 'Paramètres mis à jour.');
    }
}