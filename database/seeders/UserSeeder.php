<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

class UserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $userDataRandom = [
            'root' => 'root@gmail.com',
            'admin' => 'admin@gmail.com',
            'suporte' => 'suporte@gmail.com',
        ];

        foreach ($userDataRandom as $userName => $userEmail) {
            User::create([
                'name' => $userName,
                'email' => $userEmail,
                'email_verified_at' => now(),
                'password' => Hash::make(env('USER_PASSWORD', '123Mudar!')),
                'remember_token' => Str::random(10)
            ]);
        }
    }
}
