<?php

namespace App\Http\Controllers;

use App\Models\Notification;
use Illuminate\Http\Request;

class NotificationController extends Controller
{
    // 🔹 Liste des notifications
    public function index()
    {
        return response()->json(Notification::latest()->get(), 200);
    }

    // 🔹 Créer une notification
    public function store(Request $request)
    {
        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'message' => 'required|string',
            'type' => 'required|string|in:info,warning,urgent',
        ]);

        $notif = Notification::create($validated);
        return response()->json($notif, 201);
    }

    // 🔹 Effacer toutes les notifications
    public function clear()
    {
        Notification::truncate();
        return response()->json(['message' => 'Toutes les notifications ont été effacées'], 200);
    }
}