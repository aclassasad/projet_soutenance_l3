<!DOCTYPE html>
<html lang="{{ app()->getLocale() }}">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1"> <!-- essentiel pour mobile -->
  <title>SecureStore - @yield('title')</title>
  
  <!-- Bootstrap -->
  <link rel="stylesheet" href="{{ asset('bootstrap-5.3.3-dist/css/bootstrap.css') }}">
  <!-- Style global -->
  <link rel="stylesheet" href="{{ asset('css/style.css') }}">
  <!-- Chart.js -->
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
  <!-- Bootstrap Icons -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
  <!-- toastr pour les Notifications-->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css">
  <!--<script>
    (function() {
        // Appliquer le thème immédiatement pour éviter le flash
        const theme = localStorage.getItem('theme') || 'light';
        if (theme === 'dark') {
            document.documentElement.setAttribute('data-bs-theme', 'dark');
            document.body.classList.add('dark-mode');
        }
    })();
</script>-->
@stack('styles')
<!-- Styles pour le dark mode -->
<style>
    body.dark-mode {
        background-color: #1a1a1a !important;
        color: #ffffff !important;
    }
    body.dark-mode .card,
    body.dark-mode .navbar,
    body.dark-mode .sidebar,
    body.dark-mode .modal-content,
    body.dark-mode .dropdown-menu {
        background-color: #2d2d2d !important;
        border-color: #404040 !important;
    }
    body.dark-mode .table {
        color: #e0e0e0 !important;
    }
    body.dark-mode .text-muted {
        color: #a0a0a0 !important;
    }
    .nav-item:hover {
            background: rgba(255,255,255,0.1);
            color: #fff;
        }
    /* Ajoutez d'autres sélecteurs selon les besoins */
</style>

<!-- Script pour appliquer le thème avant affichage -->
<script>
    (function() {
        const theme = localStorage.getItem('theme') || 'light';
        if (theme === 'dark') {
            document.documentElement.setAttribute('data-bs-theme', 'dark');
            document.body.classList.add('dark-mode');
        }
    })();
</script>
</head>

<body>
<div >
<!--Font Awesome pour les icônes-->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<div class="d-flex">
  <!-- Sidebar -->
  <div id="sidebarMenu" class="sidebar bg-dark text-white p-3 d-flex flex-column vh-100 position-fixed" style="width:240px;">
    <h4 class="mb-4">  <a class="navbar-brand" href="{{ route('dashboard') }}"> SecureStore Pro</a></h4>

    <!-- Navigation principale -->
    <ul class="nav flex-column mb-auto">
      <li class="nav-item mb-3">
        <a class="nav-link text-white {{ request()->routeIs('dashboard') ? 'active' : '' }}" href="{{ route('dashboard') }}">
          <i class="bi bi-speedometer2"></i> Dashboard
        </a>
      </li>
      <li class="nav-item mb-3">
        <a class="nav-link text-white {{ request()->routeIs('inventory') ? 'active' : '' }}" href="{{ route('inventory') }}">
          <i class="bi bi-box-seam"></i> Inventaire
        </a>
      </li>
      <li class="nav-item mb-3">
        <a class="nav-link text-white {{ request()->routeIs('security') ? 'active' : '' }}" href="{{ route('security') }}">
          <i class="bi bi-shield-lock"></i> Sécurité
        </a>
      </li>
      <li class="nav-item mb-3">
        <a class="nav-link text-white {{ request()->routeIs('sales') ? 'active' : '' }}" href="{{ route('sales') }}">
          <i class="bi bi-cart"></i> Ventes
        </a>
      </li>
      <li class="nav-item mb-3">
        <a class="nav-link text-white {{ request()->routeIs('employees') ? 'active' : '' }}" href="{{ route('employees') }}">
          <i class="bi bi-people"></i> Employes
        </a>
      </li>
    </ul>

    <!-- Bloc en bas -->
    <div class="mt-auto">
      <a href="{{ route('notifications') }}" class="text-white d-block mb-2 text-decoration-none">
        <i class="bi bi-bell"></i> Notifications
        <span class="badge bg-danger">3</span>
      </a>
      <a href="{{ route('settings') }}" class="text-white d-block mb-2 text-decoration-none">
        <i class="bi bi-gear"></i> Paramètres
      </a>
      <form action="{{ route('logout') }}" method="POST">
        @csrf
        <button type="submit" class="btn btn-link text-danger text-decoration-none p-0">
          <i class="bi bi-box-arrow-right"></i> Déconnexion
        </button>
      </form>
    </div>
  </div>

  <!-- Main Content -->
  <div class="content flex-grow-1 p-4 container-fluid" style="margin-left:240px;">
    @yield('content')
  </div>
</div>

<!-- Bootstrap JS -->
<script src="{{ asset('bootstrap-5.3.3-dist/js/bootstrap.bundle.js') }}"></script>

<!-- Toast Js -->
 <script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>

@if(Session::has('success'))
<script>
toastr.success("{{ Session::get('success') }}");
</script>
@endif

@if(Session::has('error'))
<script>
toastr.error("{{ Session::get('error') }}");
</script>
@endif

@if(Session::has('info'))
<script>
toastr.info("{{ Session::get('info') }}");
</script>
@endif

@if(Session::has('warning'))
<script>
toastr.warning("{{ Session::get('warning') }}");
</script>
@endif


<!-- Script pour appliquer thème/langue -->
<script>
  document.addEventListener("DOMContentLoaded", function() {
    // Appliquer le thème
    const theme = "{{ session('settings.theme', 'light') }}";
    document.body.className = theme;

    // Appliquer la langue
    const lang = "{{ session('settings.language', 'fr') }}";
    document.documentElement.lang = lang;
  });
</script>



@stack('scripts')

</body>
</html>