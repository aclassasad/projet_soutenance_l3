<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

class ProduitFactory extends Factory
{
    public function definition(): array
    {
        return [
            'nom' => $this->faker->word(),
            'description' => $this->faker->sentence(),
            'prix_achat' => $this->faker->randomFloat(2, 100, 10000),
            'prix_vente' => $this->faker->randomFloat(2, 200, 20000),
            'stock' => $this->faker->numberBetween(0, 200),
            'seuil_alerte' => $this->faker->numberBetween(5, 20),
            'categorie_id' => \App\Models\Categorie::factory(),
            'fournisseur_id' => \App\Models\Fournisseur::factory(),
        ];
    }
}