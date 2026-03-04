<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

class FournisseurFactory extends Factory
{
    public function definition(): array
    {
        return [
            'nom' => $this->faker->company(),
            'telephone' => $this->faker->phoneNumber(),
            'email' => $this->faker->unique()->safeEmail(),
            'adresse' => $this->faker->address(),
        ];
    }
}