<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Produit;

class ProduitSeeder extends Seeder
{
    public function run(): void
    {
        $produits = [
            ['nom'=>'Laptop Dell','description'=>'Core i5, 8GB RAM','prix_achat'=>400,'prix_vente'=>550,'stock'=>20,'seuil_alerte'=>5,'categorie_id'=>1,'fournisseur_id'=>1],
            ['nom'=>'iPhone 13','description'=>'128GB','prix_achat'=>700,'prix_vente'=>900,'stock'=>15,'seuil_alerte'=>3,'categorie_id'=>2,'fournisseur_id'=>2],
            // 👉 ajoute jusqu’à 15 produits
        ];

        foreach ($produits as $p) {
            Produit::create($p);
        }
    }
}