<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class LigneVente extends Model
{
    use HasFactory;

    protected $fillable = [
        'vente_id', 'produit_id', 'quantite',
        'prix_unitaire', 'sous_total'
    ];

    public function vente()
    {
        return $this->belongsTo(Vente::class);
    }

    public function produit()
    {
        return $this->belongsTo(Produit::class, );
    }
}