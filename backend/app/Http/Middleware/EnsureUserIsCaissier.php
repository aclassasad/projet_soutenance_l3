<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Support\Facades\Auth;

class EnsureUserIsCaissier
{
    public function handle($request, Closure $next)
    {
        if (!Auth::check() || Auth::user()->role !== 'caissier') {
            return redirect()->route('login')->withErrors([
                'email' => 'Accès réservé au caissier.',
            ]);
        }

        return $next($request);
    }
}