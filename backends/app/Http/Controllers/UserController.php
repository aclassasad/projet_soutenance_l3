<?php

namespace App\Models;

use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, Notifiable;

    protected $table = 'users';

    protected $fillable = [
        'name',
        'email',
        'password',
        'role',   // admin, caissier, etc.
        'statut', // actif/inactif
    ];

    protected $hidden = [
        'password',
        'remember_token',
    ];

    // 🔹 Relation : un utilisateur peut avoir plusieurs ventes
    public function ventes()
    {
        return $this->hasMany(Vente::class);
    }
}