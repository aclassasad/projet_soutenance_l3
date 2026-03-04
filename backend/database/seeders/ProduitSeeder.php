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
['nom' => 'Téléphone', 'description' => 'Smartphone Android', 'prix_achat' => 100000, 'prix_vente' => 150000, 'stock' => 20, 'seuil_alerte' => 5, 'categorie_id' => 1, 'fournisseur_id' => 1],
            ['nom' => 'T-shirt', 'description' => 'Coton 100%', 'prix_achat' => 2000, 'prix_vente' => 5000, 'stock' => 50, 'seuil_alerte' => 10, 'categorie_id' => 2, 'fournisseur_id' => 2],
            ['nom' => 'Pain', 'description' => 'Baguette fraîche', 'prix_achat' => 200, 'prix_vente' => 300, 'stock' => 100, 'seuil_alerte' => 20, 'categorie_id' => 3, 'fournisseur_id' => 3],
                ];

        foreach ($produits as $p) {
            Produit::create($p);
        }
    }
}