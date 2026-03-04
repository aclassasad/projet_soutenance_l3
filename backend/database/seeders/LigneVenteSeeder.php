<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\LigneVente;

class LigneVenteSeeder extends Seeder
{
    public function run(): void
    {
        for ($i=1; $i<=20; $i++) {
            LigneVente::create([
                'vente_id' => rand(1,10),
                'produit_id' => rand(1,15),
                'quantite' => rand(1,5),
                'prix_unitaire' => rand(50,900),
                'sous_total' => rand(50,900) * rand(1,5),
            ]);
        }
    }
}