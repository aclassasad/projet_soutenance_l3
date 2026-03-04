<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;

class NotificationSeeder extends Seeder
{
    public function run()
    {
        session()->put('notifications', [
            ['title' => 'Nouvelle vente', 'message' => 'Une vente a été enregistrée.', 'type' => 'info'],
            ['title' => 'Stock critique', 'message' => 'Un produit est en dessous du seuil.', 'type' => 'warning'],
            ['title' => 'Employé absent', 'message' => 'Un employé est en congé.', 'type' => 'urgent'],
        ]);
    }
}