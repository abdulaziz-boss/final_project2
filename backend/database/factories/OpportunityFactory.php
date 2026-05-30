<?php

namespace Database\Factories;

use App\Models\Opportunity;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<Opportunity>
 */
class OpportunityFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'organization_id' => 1,
            'user_id' => 1,
            'judul' => fake()->jobTitle(),
            'deskripsi' => fake()->paragraphs(3, true),
            'lokasi' => fake()->city(),
            'maps_url' => 'https://maps.google.com',
            'tipe' => fake()->randomElement(['online', 'offline']),
            'tanggal_mulai' => now()->addDays(fake()->numberBetween(1, 10))->toDateString(),
            'tanggal_selesai' => now()->addDays(fake()->numberBetween(30, 60))->toDateString(),
            'kuota' => fake()->numberBetween(5, 50),
            'status' => fake()->randomElement(['open', 'closed']),
        ];
    }
}
