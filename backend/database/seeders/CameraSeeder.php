<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Camera;

class CameraSeeder extends Seeder
{
    public function run()
    {
        $cameras = [
            ['name' => 'Caméra Entrée', 'status' => 'ONLINE'],
            ['name' => 'Caméra Magasin', 'status' => 'OFFLINE'],
        ];

        foreach ($cameras as $c) {
            Camera::create($c);
        }
    }
}