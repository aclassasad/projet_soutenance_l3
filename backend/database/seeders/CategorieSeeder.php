<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Categorie;

class CategorieSeeder extends Seeder
{
    public function run()
    {
        $categories = [
            ['nom' => 'Électronique', 'description' => 'Appareils et gadgets'],
            ['nom' => 'Vêtements', 'description' => 'Mode et habillement'],
            ['nom' => 'Alimentation', 'description' => 'Produits alimentaires'],
            ['nom' => 'Accessoires', 'description' => 'Divers accessoires'],
            ['nom' => 'Maison', 'description' => 'Articles pour la maison'],
        ];

        foreach ($categories as $cat) {
            Categorie::create($cat);
        }
    }
}