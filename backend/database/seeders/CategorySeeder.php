<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Category;
use Illuminate\Support\Str;

class CategorySeeder extends Seeder
{
    public function run(): void
    {
        $categoryNames = [
            'Lingkungan',
            'Pendidikan',
            'Kesehatan',
            'Sosial',
            'Teknologi',
        ];

        foreach ($categoryNames as $name) {

            Category::updateOrCreate(
                ['slug' => Str::slug($name)],
                [
                    'name' => $name,
                ]
            );
        }
    }
}
