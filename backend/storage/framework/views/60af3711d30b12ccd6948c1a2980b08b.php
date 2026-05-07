<!DOCTYPE html>
<html lang="<?php echo e(app()->getLocale()); ?>">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1"> <!-- essentiel pour mobile -->
  <title>SecureStore - <?php echo $__env->yieldContent('title'); ?></title>
  
  <!-- Bootstrap -->
  <link rel="stylesheet" href="<?php echo e(asset('bootstrap-5.3.3-dist/css/bootstrap.css')); ?>">
  <!-- Style global -->
  <link rel="stylesheet" href="<?php echo e(asset('css/style.css')); ?>">
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
<?php echo $__env->yieldPushContent('styles'); ?>
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
    <h4 class="mb-4">  <a class="navbar-brand" href="<?php echo e(route('dashboard')); ?>"> SecureStore Pro</a></h4>

    <!-- Navigation principale -->
    <ul class="nav flex-column mb-auto">
      <li class="nav-item mb-3">
        <a class="nav-link text-white <?php echo e(request()->routeIs('dashboard') ? 'active' : ''); ?>" href="<?php echo e(route('dashboard')); ?>">
          <i class="bi bi-speedometer2"></i> Dashboard
        </a>
      </li>
      <li class="nav-item mb-3">
        <a class="nav-link text-white <?php echo e(request()->routeIs('inventory') ? 'active' : ''); ?>" href="<?php echo e(route('inventory')); ?>">
          <i class="bi bi-box-seam"></i> Inventory
        </a>
      </li>
      <li class="nav-item mb-3">
        <a class="nav-link text-white <?php echo e(request()->routeIs('security') ? 'active' : ''); ?>" href="<?php echo e(route('security')); ?>">
          <i class="bi bi-shield-lock"></i> Security
        </a>
      </li>
      <li class="nav-item mb-3">
        <a class="nav-link text-white <?php echo e(request()->routeIs('sales') ? 'active' : ''); ?>" href="<?php echo e(route('sales')); ?>">
          <i class="bi bi-cart"></i> Sales
        </a>
      </li>
      <li class="nav-item mb-3">
        <a class="nav-link text-white <?php echo e(request()->routeIs('employees') ? 'active' : ''); ?>" href="<?php echo e(route('employees')); ?>">
          <i class="bi bi-people"></i> Employees
        </a>
      </li>
    </ul>

    <!-- Bloc en bas -->
    <div class="mt-auto">
      <a href="<?php echo e(route('notifications')); ?>" class="text-white d-block mb-2 text-decoration-none">
        <i class="bi bi-bell"></i> Notifications
        <span class="badge bg-danger">3</span>
      </a>
      <a href="<?php echo e(route('settings')); ?>" class="text-white d-block mb-2 text-decoration-none">
        <i class="bi bi-gear"></i> Settings
      </a>
      <form action="<?php echo e(route('logout')); ?>" method="POST">
        <?php echo csrf_field(); ?>
        <button type="submit" class="btn btn-link text-danger text-decoration-none p-0">
          <i class="bi bi-box-arrow-right"></i> Logout
        </button>
      </form>
    </div>
  </div>

  <!-- Main Content -->
  <div class="content flex-grow-1 p-4 container-fluid" style="margin-left:240px;">
    <?php echo $__env->yieldContent('content'); ?>
  </div>
</div>

<!-- Bootstrap JS -->
<script src="<?php echo e(asset('bootstrap-5.3.3-dist/js/bootstrap.bundle.js')); ?>"></script>

<!-- Toast Js -->
 <script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>

<?php if(Session::has('success')): ?>
<script>
toastr.success("<?php echo e(Session::get('success')); ?>");
</script>
<?php endif; ?>

<?php if(Session::has('error')): ?>
<script>
toastr.error("<?php echo e(Session::get('error')); ?>");
</script>
<?php endif; ?>

<?php if(Session::has('info')): ?>
<script>
toastr.info("<?php echo e(Session::get('info')); ?>");
</script>
<?php endif; ?>

<?php if(Session::has('warning')): ?>
<script>
toastr.warning("<?php echo e(Session::get('warning')); ?>");
</script>
<?php endif; ?>


<!-- Script pour appliquer thème/langue -->
<script>
  document.addEventListener("DOMContentLoaded", function() {
    // Appliquer le thème
    const theme = "<?php echo e(session('settings.theme', 'light')); ?>";
    document.body.className = theme;

    // Appliquer la langue
    const lang = "<?php echo e(session('settings.language', 'fr')); ?>";
    document.documentElement.lang = lang;
  });
</script>



<?php echo $__env->yieldPushContent('scripts'); ?>

</body>
</html><?php /**PATH D:\modif\projet_soutenance_l3\backend\resources\views/layouts/app.blade.php ENDPATH**/ ?>