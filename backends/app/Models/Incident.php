<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Incident extends Model
{
    protected $table = 'incidents';

    protected $fillable = [
        'description',
        'location',
        'date',
        'type',   // intrusion, fire, etc.
        'status', // active, investigation, resolved
    ];
}