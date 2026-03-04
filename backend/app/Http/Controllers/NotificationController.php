<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class NotificationController extends Controller
{
    public function index()
    {
        // Charger les notifications depuis la session (ou tableau vide si aucune)
        $notifications = session('notifications', []);

        return view('notifications', compact('notifications'));
    }

    public function clear()
    {
        // Vider les notifications
        session()->forget('notifications');

        return redirect()->route('notifications.index')->with('success', 'Notifications effacées.');
    }
}