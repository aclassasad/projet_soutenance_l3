<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?php echo $__env->yieldContent('title', 'SecureStore - Caissier'); ?></title>
    <link href="<?php echo e(asset('bootstrap-5.3.3-dist/css/bootstrap.min.css')); ?>" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background-color: #f8fafc;
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
        }
        
        /* Sidebar style - comme dans la maquette */
        .sidebar-caissier {
            position: fixed;
            top: 0;
            left: 0;
            height: 100vh;
            width: 260px;
            background: linear-gradient(180deg, #1e293b 0%, #0f172a 100%);
            color: #fff;
            box-shadow: 4px 0 20px rgba(0,0,0,0.1);
            z-index: 1000;
            overflow-y: auto;
        }

        .sidebar-header {
            padding: 24px 20px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
            margin-bottom: 20px;
        }

        .sidebar-header h3 {
            font-size: 1.25rem;
            font-weight: 600;
            margin: 0;
            color: #fff;
        }

        .sidebar-header p {
            font-size: 0.85rem;
            color: #94a3b8;
            margin: 5px 0 0 0;
        }

        .nav-caissier {
            display: flex;
            flex-direction: column;
            padding: 0 12px;
        }

        .nav-item-caissier {
            display: flex;
            align-items: center;
            padding: 12px 16px;
            margin: 4px 0;
            border-radius: 12px;
            color: #cbd5e1;
            text-decoration: none;
            transition: all 0.2s;
        }

        .nav-item-caissier:hover {
            background: rgba(255,255,255,0.1);
            color: #fff;
        }

        .nav-item-caissier.active {
            background: rgba(67, 97, 238, 0.2);
            color: #fff;
            border-left: 3px solid #4361EE;
        }

        .nav-item-caissier i {
            width: 24px;
            font-size: 1.1rem;
            margin-right: 12px;
        }

        .nav-item-caissier span {
            font-size: 0.95rem;
            font-weight: 500;
        }

        .nav-item-caissier .badge {
            margin-left: auto;
            background: #ef4444;
            color: white;
            font-size: 0.7rem;
            padding: 3px 8px;
            border-radius: 20px;
        }

        .user-info {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            padding: 20px;
            border-top: 1px solid rgba(255,255,255,0.1);
            background: rgba(0,0,0,0.2);
        }

        .user-info .d-flex {
            display: flex;
            align-items: center;
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            background: #4361EE;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 12px;
        }

        .user-avatar i {
            font-size: 1.2rem;
            color: white;
        }

        .user-details {
            flex: 1;
        }

        .user-details .name {
            font-weight: 600;
            font-size: 0.95rem;
            color: #fff;
            margin-bottom: 2px;
        }

        .user-details .role {
            font-size: 0.8rem;
            color: #94a3b8;
        }

        .logout-btn {
            background: none;
            border: 1px solid rgba(255,255,255,0.2);
            color: #cbd5e1;
            padding: 6px 12px;
            border-radius: 8px;
            font-size: 0.85rem;
            transition: all 0.2s;
            cursor: pointer;
        }

        .logout-btn:hover {
            background: rgba(255,255,255,0.1);
            color: #fff;
            border-color: rgba(255,255,255,0.3);
        }

        /* Main content area */
        .main-content-caissier {
            margin-left: 260px;
            padding: 24px;
            min-height: 100vh;
            background-color: #f8fafc;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .sidebar-caissier {
                transform: translateX(-100%);
                transition: transform 0.3s ease;
            }
            
            .sidebar-caissier.show {
                transform: translateX(0);
            }
            
            .main-content-caissier {
                margin-left: 0;
            }
            
            .menu-toggle {
                display: block;
                position: fixed;
                top: 20px;
                left: 20px;
                z-index: 1001;
                background: #4361EE;
                color: white;
                border: none;
                border-radius: 8px;
                padding: 10px 15px;
                cursor: pointer;
            }
        }

        .menu-toggle {
            display: none;
        }
    </style>
</head>
<body>
    <!-- Bouton menu mobile -->
    <button class="menu-toggle" onclick="toggleSidebar()">
        <i class="fa-solid fa-bars"></i>
    </button>

    <!-- Sidebar caissier (comme dans la maquette) -->
    <div class="sidebar-caissier" id="sidebarCaissier">
        <div class="sidebar-header">
            <h3>SecureStore</h3>
            <p>Management Pro - Caissier</p>
        </div>

        <div class="nav-caissier">
            <a href="<?php echo e(route('caissier.dashboard')); ?>" class="nav-item-caissier <?php echo e(request()->routeIs('caissier.dashboard') ? 'active' : ''); ?>">
                <i class="fa-solid fa-cash-register"></i>
                <span>Point de Vente</span>
            </a>
            
            <a href="<?php echo e(route('caissier.historique')); ?>" class="nav-item-caissier <?php echo e(request()->routeIs('caissier.historique') ? 'active' : ''); ?>">
                <i class="fa-solid fa-clock-rotate-left"></i>
                <span>Historique</span>
            </a>
            
            <a href="<?php echo e(route('caissier.stock')); ?>" class="nav-item-caissier <?php echo e(request()->routeIs('caissier.stock') ? 'active' : ''); ?>">
                <i class="fa-solid fa-boxes"></i>
                <span>Stock</span>
                <?php
                    $stockAlert = \App\Models\Produit::where('stock', '<', 10)->count();
                ?>
                <?php if($stockAlert > 0): ?>
                    <span class="badge"><?php echo e($stockAlert); ?></span>
                <?php endif; ?>
            </a>
            
            <!--<a href="<?php echo e(route('caissier.stats')); ?>" class="nav-item-caissier <?php echo e(request()->routeIs('caissier.stats') ? 'active' : ''); ?>">
                <i class="fa-solid fa-chart-line"></i>
                <span>Statistiques</span>
            </a>-->
        </div>

        <!-- Informations utilisateur en bas -->
        <div class="user-info">
            <div class="d-flex align-items-center mb-3">
                <div class="user-avatar">
                    <i class="fa-regular fa-user"></i>
                </div>
                <div class="user-details">
                    <div class="name"><?php echo e($user->name ?? 'Caissier'); ?></div>
                    <div class="role"><?php echo e($user->role ?? 'Caissier'); ?></div>
                </div>
            </div>
            <form method="POST" action="<?php echo e(route('logout')); ?>">
                <?php echo csrf_field(); ?>
                <button type="submit" class="logout-btn w-100">
                    <i class="fa-solid fa-sign-out-alt me-2"></i>
                    Déconnexion
                </button>
            </form>
        </div>
    </div>

    <!-- Contenu principal -->
    <div class="main-content-caissier">
        <?php echo $__env->yieldContent('content'); ?>
    </div>

    <!-- Scripts -->
    <script src="<?php echo e(asset('bootstrap-5.3.3-dist/js/bootstrap.bundle.min.js')); ?>"></script>
    <script>
        function toggleSidebar() {
            document.getElementById('sidebarCaissier').classList.toggle('show');
        }
        
        // Fermer la sidebar en cliquant à l'extérieur (mobile)
        document.addEventListener('click', function(event) {
            const sidebar = document.getElementById('sidebarCaissier');
            const toggleBtn = document.querySelector('.menu-toggle');
            
            if (window.innerWidth <= 768) {
                if (!sidebar.contains(event.target) && !toggleBtn.contains(event.target)) {
                    sidebar.classList.remove('show');
                }
            }
        });
    </script>
    <?php echo $__env->yieldContent('scripts'); ?>
</body>
</html><?php /**PATH D:\modif\projet_soutenance_l3\backend\resources\views/layouts/cashier.blade.php ENDPATH**/ ?>