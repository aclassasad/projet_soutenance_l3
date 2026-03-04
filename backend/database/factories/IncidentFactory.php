<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

class IncidentFactory extends Factory
{
    public function definition(): array
    {
        return [
            'description' => $this->faker->sentence(),
            'location' => $this->faker->city(),
            'date' => $this->faker->dateTimeThisYear(),
            'type' => $this->faker->randomElement(['Intrusion', 'Fire', 'System Alert']),
            'status' => $this->faker->randomElement(['ACTIVE', 'RESOLVED']),
        ];
    }
}