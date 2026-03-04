<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Fournisseur;

class FournisseurSeeder extends Seeder
{
    public function run()
    {
        $fournisseurs = [
            ['nom' => 'TechWorld', 'telephone' => '90000001', 'email' => 'contact@techworld.com', 'adresse' => 'Cotonou'],
            ['nom' => 'FashionLine', 'telephone' => '90000002', 'email' => 'info@fashionline.com', 'adresse' => 'Abomey'],
            ['nom' => 'FoodMarket', 'telephone' => '90000003', 'email' => 'sales@foodmarket.com', 'adresse' => 'Porto-Novo'],
        ];

        foreach ($fournisseurs as $f) {
            Fournisseur::create($f);
        }
    }
}