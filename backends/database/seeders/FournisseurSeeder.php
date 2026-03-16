<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Fournisseur;

class FournisseurSeeder extends Seeder
{
    public function run(): void
    {
        $fournisseurs = [
            ['nom'=>'Tech Supplier','telephone'=>'22990000001','email'=>'tech@example.com','adresse'=>'Cotonou'],
            ['nom'=>'Phone World','telephone'=>'22990000002','email'=>'phone@example.com','adresse'=>'Abomey'],
            // 👉 ajoute jusqu’à 10 fournisseurs
        ];

        foreach ($fournisseurs as $f) {
            Fournisseur::create($f);
        }
    }
}