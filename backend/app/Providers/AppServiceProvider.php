<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use Illuminate\Support\Facades\Schema;
use Illuminate\Pagination\Paginator; 
use Illuminate\Support\Facades\App;
use Illuminate\Support\Facades\Session;
use Illuminate\Support\Facades\Gate;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        //
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        // ✅ Paramètres généraux
        Schema::defaultStringLength(191);
        Paginator::useBootstrapFive();

        // ✅ Langue par défaut
        $locale = Session::get('settings.language', config('app.locale'));
        App::setLocale($locale);

        // ✅ Gates pour les rôles
        Gate::define('access-dashboard', function ($user) {
            return in_array($user->role, ['admin', 'gerant']);
        });

        Gate::define('access-caissier', function ($user) {
            return $user->role === 'caissier';
        });
    }
}
