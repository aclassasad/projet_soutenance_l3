<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;

class DatabaseSeeder extends Seeder
{
    use WithoutModelEvents;

    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        \App\Models\Categorie::factory(5)->create();
        \App\Models\Fournisseur::factory(5)->create();
        \App\Models\Produit::factory(20)->create();
    \App\Models\Vente::factory(50)->create();

    // Générer 150 lignes de ventes liées
    \App\Models\LigneVente::factory(150)->create();
\App\Models\Incident::factory(10)->create();
        \App\Models\Camera::factory(5)->create();
    }
}