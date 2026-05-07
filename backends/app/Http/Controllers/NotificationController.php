<?php

namespace App\Http\Controllers;

use App\Models\Notification;
use Illuminate\Http\Request;
use App\Events\NewNotificationEvent;

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

        broadcast(new NewNotificationEvent($notif))->toOthers();

        return response()->json($notif, 201);
    }

    // 🔹 Effacer toutes les notifications
    public function clear()
    {
        Notification::truncate();
        return response()->json(['message' => 'Toutes les notifications ont été effacées'], 200);
    }

    // 🔹 Marquer une notification comme lue
    public function markAsRead($id)
    {
        $notif = Notification::findOrFail($id);
        $notif->update(['read' => true]);

        return response()->json(['message' => 'Notification marquée comme lue'], 200);
    }

    // 🔹 Supprimer une notification spécifique
    public function destroy($id)
    {
        $notif = Notification::findOrFail($id);
        $notif->delete();

        return response()->json(['message' => 'Notification supprimée'], 200);
    }
}
