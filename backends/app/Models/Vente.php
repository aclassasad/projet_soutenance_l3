<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use App\Models\LigneVente;

class Vente extends Model
{
    use HasFactory;

    protected $table = 'ventes'; // ✅ assure-toi que c’est bien le nom de ta table
    protected $fillable = ['date_vente', 'total', 'user_id'];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function lignes()
    {
        return $this->hasMany(LigneVente::class, 'vente_id'); // ✅ clé étrangère explicite
    }
}