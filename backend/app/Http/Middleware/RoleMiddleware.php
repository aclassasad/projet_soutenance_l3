<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Support\Facades\Auth;

class RoleMiddleware
{
    /**
     * Vérifie si l'utilisateur a un des rôles autorisés.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure  $next
     * @param  mixed ...$roles
     * @return mixed
     */
    public function handle($request, Closure $next, ...$roles)
    {
        if (!Auth::check()) {
            return redirect()->route('login');
        }

        $userRole = strtolower(Auth::user()->role);

        // Vérifie si le rôle de l'utilisateur est dans la liste
        if (!in_array($userRole, array_map('strtolower', $roles))) {
            abort(403, 'Accès interdit');
        }

        return $next($request);
    }
}
