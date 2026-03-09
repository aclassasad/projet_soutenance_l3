<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Support\Facades\Auth;

class EnsureUserIsAdminOrGerant
{
    public function handle($request, Closure $next)
    {
        if (!Auth::check() || !in_array(Auth::user()->role, ['admin', 'gerant'])) {
            return redirect()->route('login')->withErrors([
                'email' => 'Accès réservé au gérant et à l’administrateur.',
            ]);
        }

        return $next($request);
    }
}