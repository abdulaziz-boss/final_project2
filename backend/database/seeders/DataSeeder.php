<?php

namespace Database\Seeders;

use App\Models\User;
use App\Models\Category;
use App\Models\Message;
use App\Models\Opportunity;
use App\Models\Organization;
use App\Models\Conversation;
use App\Models\Comment;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

class DataSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        DB::statement('SET FOREIGN_KEY_CHECKS=0;');

        DB::table('messages')->delete();
        DB::table('conversations')->delete();
        DB::table('category_opportunity')->delete();
        DB::table('applications')->delete();
        DB::table('comments')->delete();
        DB::table('opportunities')->delete();
        DB::table('categories')->delete();
        DB::table('organizations')->delete();
        DB::table('users')->delete();

        DB::statement('SET FOREIGN_KEY_CHECKS=1;');

        // =========================
        // USER BIASA 10
        // =========================
        for ($i = 1; $i <= 10; $i++) {

            User::create([
                'name' => "User $i",
                'username' => "user_$i",
                'email' => "user$i@example.com",
                'password' => Hash::make('password123'),

                'role' => 'user',
                'is_verified' => true,

                // FOTO PROFIL
                'foto_profil' =>
                    'https://i.pravatar.cc/300?img=' . rand(1, 70),

                'bio' => "Bio user $i",

                'lokasi' => fake()->city(),

                'last_seen' => now(),
            ]);
        }

        // =========================
        // ADMIN 3
        // =========================
        for ($i = 1; $i <= 3; $i++) {

            User::create([
                'name' => "Admin $i",
                'username' => "admin_$i",
                'email' => "admin$i@example.com",
                'password' => Hash::make('password123'),

                'role' => 'admin',
                'is_verified' => true,

                // FOTO PROFIL
                'foto_profil' =>
                    'https://i.pravatar.cc/300?img=' . rand(1, 70),

                'bio' => "Bio admin $i",

                'lokasi' => fake()->city(),

                'last_seen' => now(),
            ]);
        }

        // =========================
        // ORGANIZATION 3
        // =========================
        $admins = User::where('role', 'admin')->get();

        for ($i = 1; $i <= 3; $i++) {

            $organization = Organization::create([

                'user_id' => $admins[$i - 1]->id,

                'nama_organisasi' => "Organization $i",

                'deskripsi' => fake()->paragraph(),

                'alamat' => fake()->address(),

                'website' => fake()->url(),

                'logo' =>
                    'https://picsum.photos/300/300?random=org' . $i,

                'is_verified' => true,
            ]);

            // connect admin -> organization
            $admins[$i - 1]->update([
                'organization_id' => $organization->id,
            ]);
        }

        // =========================
        // CATEGORY
        // =========================
        $categoryNames = [
            'Lingkungan',
            'Pendidikan',
            'Kesehatan',
            'Sosial',
            'Teknologi',
        ];

        foreach ($categoryNames as $name) {

            Category::create([
                'name' => $name,
                'slug' => Str::slug($name),

            ]);
        }

        $categories = Category::all();

        // =========================
        // OPPORTUNITY 10
        // =========================
        $users = User::where('role', 'user')->get();

        $organizations = Organization::all();

        for ($i = 1; $i <= 10; $i++) {

            $opportunity = Opportunity::create([

                'organization_id' =>
                    $organizations->random()->id,

                'created_by' =>
                    $admins->random()->id,

                'user_id' =>
                    $users->random()->id,

                'judul' =>
                    "Opportunity $i - " . fake()->jobTitle(),

                'deskripsi' =>
                    fake()->paragraphs(3, true),

                'lokasi' =>
                    fake()->city(),

                'maps_url' =>
                    'https://maps.google.com',

                // FOTO OPPORTUNITY
                'foto' =>
                    'https://picsum.photos/800/600?random=' . $i,

                'tipe' => fake()->randomElement([
                    'online',
                    'offline'
                ]),

                'tanggal_mulai' => now()
                    ->addDays(fake()->numberBetween(1, 10))
                    ->toDateString(),

                'tanggal_selesai' => now()
                    ->addDays(fake()->numberBetween(20, 60))
                    ->toDateString(),

                'kuota' =>
                    fake()->numberBetween(5, 50),

                'status' => fake()->randomElement([
                    'open',
                    'closed'
                ]),
            ]);

            // attach random categories
            $opportunity->categories()->attach(

                $categories
                    ->random(rand(1, 3))
                    ->pluck('id')
                    ->toArray()
            );
        }

        // =========================
        // COMMENT
        // =========================
        $opportunities = Opportunity::all();

        foreach ($opportunities as $opportunity) {

            // random jumlah comment
            $totalComments = rand(2, 6);

            for ($i = 1; $i <= $totalComments; $i++) {

                $user = $users->random();

                Comment::create([

                    'user_id' => $user->id,

                    'opportunity_id' => $opportunity->id,

                    'comment' => fake()->sentence(),

                ]);
            }
        }

        // =========================
        // CONVERSATION & MESSAGE
        // =========================
        foreach ($users as $user) {

            $admin = $admins->random();

            // conversation
            $conversation = Conversation::create([
                'user1_id' => $user->id,
                'user2_id' => $admin->id,
            ]);

            // user message
            Message::create([
                'conversation_id' => $conversation->id,

                'sender_id' => $user->id,

                'message' => fake()->sentence(),

                'is_read' => true,
            ]);

            // admin reply
            Message::create([
                'conversation_id' => $conversation->id,

                'sender_id' => $admin->id,

                'message' => fake()->sentence(),

                'is_read' => fake()->boolean(),
            ]);
        }
    }
}
