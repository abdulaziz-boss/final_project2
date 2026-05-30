<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    use WithoutModelEvents;

    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // Seed Categories
        $categories = [
            ['name' => 'Lingkungan', 'slug' => 'lingkungan', 'icon' => 'eco'],
            ['name' => 'Pendidikan', 'slug' => 'pendidikan', 'icon' => 'school'],
            ['name' => 'Kesehatan', 'slug' => 'kesehatan', 'icon' => 'medical_services'],
            ['name' => 'Sosial', 'slug' => 'sosial', 'icon' => 'people'],
            ['name' => 'Penanggulangan Bencana', 'slug' => 'bencana', 'icon' => 'warning'],
            ['name' => 'Budaya & Pariwisata', 'slug' => 'budaya', 'icon' => 'museum'],
        ];

        foreach ($categories as $category) {
            \App\Models\Category::firstOrCreate(['slug' => $category['slug']], $category);
        }

        // Seed users and opportunities
        $this->call(DataSeeder::class);
    }
}
