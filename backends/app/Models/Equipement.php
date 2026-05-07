<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Equipement extends Model
{
    use HasFactory;

    protected $table = 'equipements';

    protected $fillable = [
        'adresse_mac',
        'etat',        // 1 = actif, 0 = inactif
        'action',      // 1 = action en cours, 0 = aucune
        'nom',
        'description',
        'user_id',
    ];

    protected $casts = [
        'etat' => 'boolean',
        'action' => 'boolean',
    ];
     public function user()
    {
        return $this->belongsTo(User::class);
    }
}
