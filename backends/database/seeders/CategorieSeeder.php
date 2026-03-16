<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Categorie;

class CategorieSeeder extends Seeder
{
    public function run(): void
    {
        $categories = [
            ['nom'=>'Informatique','description'=>'Ordinateurs et accessoires'],
            ['nom'=>'Téléphones','description'=>'Smartphones et accessoires'],
            ['nom'=>'Électroménager','description'=>'Appareils pour la maison'],
            // 👉 ajoute jusqu’à 10 catégories
        ];

        foreach ($categories as $cat) {
            Categorie::create($cat);
        }
    }
}