<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

class VenteFactory extends Factory
{
    public function definition(): array
    {
        return [
            'date_vente' => $this->faker->dateTimeBetween('-7 days', 'now'), // sur la dernière semaine
            'total' => $this->faker->randomFloat(2, 1000, 50000),
            'user_id' => 1,
            'created_at' => $this->faker->dateTimeBetween('-7 days', 'now'), // important pour weekly_sales
            'updated_at' => now(),
        ];
    }
}