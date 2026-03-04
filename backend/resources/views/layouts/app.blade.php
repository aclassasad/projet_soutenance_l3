<!DOCTYPE html>
<html lang="fr">
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
</head>
<body>
<div class="d-flex">

  <!-- Sidebar -->
  <div id="sidebarMenu" class="sidebar bg-dark text-white p-3 d-flex flex-column vh-100 position-fixed" style="width:240px;">
    <h4 class="mb-4">SecureStore Pro</h4>

    <!-- Navigation principale -->
    <ul class="nav flex-column mb-auto">
      <li class="nav-item mb-3">
        <a class="nav-link text-white {{ request()->routeIs('dashboard') ? 'active' : '' }}" href="{{ route('dashboard') }}">
          <i class="bi bi-speedometer2"></i> Dashboard
        </a>
      </li>
      <li class="nav-item mb-3">
        <a class="nav-link text-white {{ request()->routeIs('inventory') ? 'active' : '' }}" href="{{ route('inventory') }}">
          <i class="bi bi-box-seam"></i> Inventory
        </a>
      </li>
      <li class="nav-item mb-3">
        <a class="nav-link text-white {{ request()->routeIs('security') ? 'active' : '' }}" href="{{ route('security') }}">
          <i class="bi bi-shield-lock"></i> Security
        </a>
      </li>
      <li class="nav-item mb-3">
        <a class="nav-link text-white {{ request()->routeIs('sales') ? 'active' : '' }}" href="{{ route('sales') }}">
          <i class="bi bi-cart"></i> Sales
        </a>
      </li>
      <li class="nav-item mb-3">
        <a class="nav-link text-white {{ request()->routeIs('employees') ? 'active' : '' }}" href="{{ route('employees') }}">
          <i class="bi bi-people"></i> Employees
        </a>
      </li>
    </ul>

    <!-- Bloc en bas (notifications, paramètres, déconnexion) -->
    <div class="mt-auto">
      <a href="{{ route('notifications') }}" class="text-white d-block mb-2 text-decoration-none">
        <i class="bi bi-bell"></i> Notifications
        <span class="badge bg-danger">3</span>
      </a>
      <a href="{{ route('settings') }}" class="text-white d-block mb-2 text-decoration-none">
        <i class="bi bi-gear"></i> Settings
      </a>
      <form action="{{ route('logout') }}" method="POST">
        @csrf
        <button type="submit" class="btn btn-link text-danger text-decoration-none p-0">
          <i class="bi bi-box-arrow-right"></i> Logout
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

<!-- Scripts poussés depuis les vues -->
@stack('scripts')
</body>
</html>