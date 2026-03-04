<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

class CameraFactory extends Factory
{
    public function definition(): array
    {
        return [
            'name' => 'Caméra ' . $this->faker->word(),
            'status' => $this->faker->randomElement(['ONLINE', 'OFFLINE']),
        ];
    }
}