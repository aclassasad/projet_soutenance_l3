<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

class LigneVenteFactory extends Factory
{
    public function definition(): array
    {
        $quantite = $this->faker->numberBetween(1, 10);
        $prix = $this->faker->randomFloat(2, 500, 5000);

        return [
            'vente_id' => \App\Models\Vente::factory(),
            'produit_id' => \App\Models\Produit::factory(),
            'quantite' => $quantite,
            'prix_unitaire' => $prix,
            'sous_total' => $quantite * $prix,
        ];
    }
}