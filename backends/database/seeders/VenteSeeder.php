<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Vente;

class VenteSeeder extends Seeder
{
    public function run(): void
    {
        for ($i=1; $i<=10; $i++) {
            Vente::create([
                'user_id' => rand(1,5),
                'total' => rand(100,2000),
            ]);
        }
    }
}