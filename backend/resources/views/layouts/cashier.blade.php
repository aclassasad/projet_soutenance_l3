<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>@yield('title', 'Caissier - SecureStore')</title>
    <link href="{{ asset('bootstrap-5.3.3-dist/css/bootstrap.min.css') }}" rel="stylesheet">
    <style>
        body {
    padding-top: 70px; /* ajuste selon la hauteur de ta navbar */
}
    </style>
</head>
<body>

    <!-- Barre de navigation pour le caissier -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
        <div class="container-fluid">
            <a class="navbar-brand" href="{{ route('caissier.dashboard') }}">SecureStorePro - Caissier</a>
            <div class="collapse navbar-collapse">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="{{ route('caissier.dashboard') }}">Point de Vente</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="{{ route('caissier.historique') }}">Historique</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="{{ route('caissier.stock') }}">Stock</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="{{ route('caissier.stats') }}">Statistiques</a>
                    </li>
                    <li class="nav-item">
                        <form method="POST" action="{{ route('logout') }}">
                            @csrf
                            <button class="btn btn-sm btn-outline-light">Déconnexion</button>
                        </form>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Contenu principal -->
    <div class="container">
        @yield('content')
    </div>

    <!-- Scripts -->
    <script src="{{ asset('bootstrap-5.3.3-dist/js/bootstrap.bundle.min.js') }}"></script>
    @yield('scripts')
</body>
</html>