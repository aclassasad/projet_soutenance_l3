<?php
namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\User;
use Illuminate\Support\Facades\Hash;

class UserSeeder extends Seeder
{
    public function run(): void
    {
        $users = [
            ['name'=>'Alice','email'=>'alice@example.com','password'=>Hash::make('secret'),'role'=>'admin','statut'=>true],
            ['name'=>'Bob','email'=>'bob@example.com','password'=>Hash::make('secret'),'role'=>'caissier','statut'=>true],
            ['name'=>'Charlie','email'=>'charlie@example.com','password'=>Hash::make('secret'),'role'=>'vendeur','statut'=>true],
            // 👉 ajoute jusqu’à 15 utilisateurs
        ];

        foreach ($users as $user) {
            User::create($user);
        }
    }
}
