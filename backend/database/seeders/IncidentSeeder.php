<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Incident;

class IncidentSeeder extends Seeder
{
    public function run()
    {
        $incidents = [
            ['description' => 'Intrusion détectée', 'location' => 'Entrée principale', 'date' => now(), 'type' => 'Intrusion', 'status' => 'ACTIVE'],
            ['description' => 'Alarme incendie', 'location' => 'Magasin', 'date' => now(), 'type' => 'Fire', 'status' => 'RESOLVED'],
        ];

        foreach ($incidents as $i) {
            Incident::create($i);
        }
    }
}