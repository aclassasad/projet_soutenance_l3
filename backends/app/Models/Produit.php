<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Produit extends Model
{
    use HasFactory;

    protected $fillable = [
        'nom', 'description', 'prix_achat', 'prix_vente',
        'stock', 'seuil_alerte', 'categorie_id', 'fournisseur_id'
    ];

    public function categorie()
    {
        return $this->belongsTo(Categorie::class);
    }

    public function fournisseur()
    {
        return $this->belongsTo(Fournisseur::class);
    }

    public function lignesVente()
    {
        return $this->hasMany(LigneVente::class);
    }
}