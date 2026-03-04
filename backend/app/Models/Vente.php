<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Vente extends Model
{
    use HasFactory;

    protected $fillable = ['date_vente', 'total', 'user_id'];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function lignesVente()
    {
        return $this->hasMany(LigneVente::class);
    }
}