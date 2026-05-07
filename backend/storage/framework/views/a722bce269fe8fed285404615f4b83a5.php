<?php $__env->startSection('title', 'Dashboard'); ?>

<?php $__env->startSection('content'); ?>
<div class="container-fluid px-3 px-md-4 px-lg-5">
    <!-- Header -->
    <div class="d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center mb-4">
        <div>
            <h2 class="fw-bold mb-1">Dashboard</h2>
            <h6 class="text-muted">Welcome back! Here's what's happening today.</h6>
        </div>
    </div>

    <!-- Metrics Cards - Complètement responsives -->
    <div class="row g-3 g-md-4 mb-4">
        <!-- Total Revenue Card -->
        <div class="col-12 col-sm-6 col-md-3">
            <a href="<?php echo e(route('sales')); ?>" style="text-decoration: none">
                <div class="card border-0 shadow-sm h-100 hover-card">
                    <div class="card-body d-flex flex-row flex-md-column flex-lg-row justify-content-between align-items-center p-3 p-md-4">
                        <div class="w-75 w-md-100 w-lg-75">
                            <h6 class="text-muted small mb-1 mb-md-2">Total Revenue</h6>
                            <h4 class="fw-bold mb-1 fs-5 fs-md-4"><?php echo e(number_format($stats['total_revenu'] ?? 45231, 0, ',', ' ')); ?> <small class="fs-6">FCFA</small></h4>
                            <small class="text-success">
                                <i class="fa-solid fa-arrow-up me-1"></i>+12.5%
                            </small>
                        </div> <!--
                        <div class="bg-success bg-opacity-10 p-2 p-md-3 rounded-circle ms-2 ms-md-0 ms-lg-2">
                            <i class="fa-solid fa-dollar-sign text-success fs-5 fs-md-4"></i>
                        </div> -->
                        <div class="bg-success bg-opacity-10 p-2 p-md-3 rounded-circle ms-2 ms-md-0 ms-lg-2">
                        <i class="fa-solid fa-wallet text-success fs-5 fs-md-4"></i>
                        </div>
                    </div>
                </div>
            </a>
        </div>

        <!-- Categories Card -->
        <div class="col-12 col-sm-6 col-md-3">
            <a href="<?php echo e(route('categories.index')); ?>" style="text-decoration: none">
                <div class="card border-0 shadow-sm h-100 hover-card">
                    <div class="card-body d-flex flex-row flex-md-column flex-lg-row justify-content-between align-items-center p-3 p-md-4">
                        <div class="w-75 w-md-100 w-lg-75">
                            <h6 class="text-muted small mb-1 mb-md-2">Categories</h6>
                            <h4 class="fw-bold mb-1 fs-5 fs-md-4"><?php echo e($stats['nombre_categories'] ?? 5); ?></h4>
                            <small class="text-warning fw-bold">
                                <i class="fa-solid fa-triangle-exclamation me-1"></i>Low stock
                            </small>
                        </div>
                        <div class="bg-warning bg-opacity-10 p-2 p-md-3 rounded-circle ms-2 ms-md-0 ms-lg-2">
                            <i class="fa-solid fa-shield-halved text-warning fs-5 fs-md-4"></i>
                        </div>
                    </div>
                </div>
            </a>
        </div>

        <!-- Products Card -->
        <div class="col-12 col-sm-6 col-md-3">
            <a href="<?php echo e(route('produits.index')); ?>" style="text-decoration: none">
                <div class="card border-0 shadow-sm h-100 hover-card">
                    <div class="card-body d-flex flex-row flex-md-column flex-lg-row justify-content-between align-items-center p-3 p-md-4">
                        <div class="w-75 w-md-100 w-lg-75">
                            <h6 class="text-muted small mb-1 mb-md-2">Products in Stock</h6>
                            <h4 class="fw-bold mb-1 fs-5 fs-md-4"><?php echo e(number_format($stats['total_produits_stock'] ?? 2847)); ?></h4>
                            <small class="text-danger">
                                <i class="fa-solid fa-arrow-down me-1"></i>-3.2%
                            </small>
                        </div>
                        <div class="bg-primary bg-opacity-10 p-2 p-md-3 rounded-circle ms-2 ms-md-0 ms-lg-2">
                            <i class="fa-solid fa-box text-primary fs-5 fs-md-4"></i>
                        </div>
                    </div>
                </div>
            </a>
        </div>

        <!-- Employees Card -->
        <div class="col-12 col-sm-6 col-md-3">
            <a href="<?php echo e(route('employees')); ?>" style="text-decoration: none">
                <div class="card border-0 shadow-sm h-100 hover-card">
                    <div class="card-body d-flex flex-row flex-md-column flex-lg-row justify-content-between align-items-center p-3 p-md-4">
                        <div class="w-75 w-md-100 w-lg-75">
                            <h6 class="text-muted small mb-1 mb-md-2">Active Employees</h6>
                            <h4 class="fw-bold mb-1 fs-5 fs-md-4"><?php echo e($stats['employes_actifs'] ?? 24); ?></h4>
                            <small class="text-success">
                                <i class="fa-solid fa-arrow-up me-1"></i>+2
                            </small>
                        </div>
                        <div class="bg-info bg-opacity-10 p-2 p-md-3 rounded-circle ms-2 ms-md-0 ms-lg-2">
                            <i class="fa-solid fa-users text-info fs-5 fs-md-4"></i>
                        </div>
                    </div>
                </div>
            </a>
        </div>
    </div>

    <!-- Graphs - Responsive -->
    <div class="row g-3 g-md-4 mb-4">
        <div class="col-12 col-lg-6">
            <div class="card">
                <div class="card-body">
                    <h6 class="fw-semibold mb-3">Weekly Sales</h6>
                    <div class="chart-container" style="position: relative; height: 250px; height-md: 300px; width: 100%;">
                        <canvas id="weeklySales"></canvas>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-12 col-lg-6">
            <div class="card">
                <div class="card-body">
                    <h6 class="fw-semibold mb-3">Store Traffic Today</h6>
                    <div class="chart-container" style="position: relative; height: 250px; height-md: 300px; width: 100%;">
                        <canvas id="storeTraffic"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Recent Alerts & Activity - Responsive -->
    <div class="row g-3 g-md-4">
        <div class="col-12 col-md-6">
            <div class="card h-100">
                <div class="card-header bg-transparent border-0">
                    <h6 class="fw-semibold mb-0">Recent Alerts</h6>
                </div>
                <div class="card-body">
                    <ul class="list-group list-group-flush">
                        <li class="list-group-item d-flex align-items-start gap-2 gap-md-3 px-0">
                            <i class="fa-solid fa-circle-exclamation text-danger mt-1"></i>
                            <div>
                                <p class="mb-0 small">Unauthorized access attempt at rear entrance</p>
                                <small class="text-muted">5 min ago</small>
                            </div>
                        </li>
                        <li class="list-group-item d-flex align-items-start gap-2 gap-md-3 px-0">
                            <i class="fa-solid fa-circle-exclamation text-warning mt-1"></i>
                            <div>
                                <p class="mb-0 small">Low stock alert: Product SKU-12847</p>
                                <small class="text-muted">12 min ago</small>
                            </div>
                        </li>
                        <li class="list-group-item d-flex align-items-start gap-2 gap-md-3 px-0">
                            <i class="fa-solid fa-circle-exclamation text-danger mt-1"></i>
                            <div>
                                <p class="mb-0 small">Camera 4 offline - Aisle 7</p>
                                <small class="text-muted">25 min ago</small>
                            </div>
                        </li>
                        <li class="list-group-item d-flex align-items-start gap-2 gap-md-3 px-0">
                            <i class="fa-solid fa-circle-check text-success mt-1"></i>
                            <div>
                                <p class="mb-0 small">Daily backup completed successfully</p>
                                <small class="text-muted">1 hour ago</small>
                            </div>
                        </li>
                    </ul>
                </div>
            </div>
        </div>

        <div class="col-12 col-md-6">
            <div class="card h-100">
                <div class="card-header bg-transparent border-0">
                    <h6 class="fw-semibold mb-0">Recent Activity</h6>
                </div>
                <div class="card-body">
                    <ul class="list-group list-group-flush">
                        <?php $__currentLoopData = $stats['transactions_recentes'] ?? []; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $t): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                        <li class="list-group-item d-flex align-items-start gap-2 gap-md-3 px-0">
                            <i class="fa-solid fa-circle text-primary mt-2" style="font-size: 8px;"></i>
                            <div class="flex-grow-1">
                                <div class="d-flex flex-column flex-sm-row justify-content-between align-items-start align-items-sm-center">
                                    <p class="mb-0 small">
                                        <span class="fw-semibold">Sale Transaction</span> • <?php echo e($t->user->name); ?>

                                    </p>
                                    <small class="text-muted"><?php echo e($t->created_at->format('d/m/Y H:i')); ?></small>
                                </div>
                                <div class="d-flex justify-content-between align-items-center mt-1">
                                    <small class="text-muted"><?php echo e(number_format($t->total, 2)); ?> FCFA</small>
                                    <button class="btn btn-sm btn-outline-primary py-0 px-2" data-bs-toggle="modal" data-bs-target="#venteModal<?php echo e($t->id); ?>">
                                        <i class="fa-solid fa-eye"></i> Détails
                                    </button>
                                </div>
                            </div>
                        </li>
                        <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                    </ul>

                    <!-- Modals des ventes -->
                    <?php $__currentLoopData = $stats['transactions_recentes'] ?? []; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $t): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                    <div class="modal fade" id="venteModal<?php echo e($t->id); ?>" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered modal-lg">
                            <div class="modal-content">
                                <div class="modal-header bg-primary text-white">
                                    <h5 class="modal-title">Détails de la vente #<?php echo e($t->id); ?></h5>
                                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                                </div>
                                <div class="modal-body">
                                    <div class="row g-3">
                                        <div class="col-6">
                                            <p class="mb-1"><strong>Caissier</strong></p>
                                            <p><?php echo e($t->user->name); ?></p>
                                        </div>
                                        <div class="col-6">
                                            <p class="mb-1"><strong>Date</strong></p>
                                            <p><?php echo e($t->created_at->format('d/m/Y H:i')); ?></p>
                                        </div>
                                        <div class="col-12">
                                            <p class="mb-1"><strong>Total</strong></p>
                                            <h4 class="text-success"><?php echo e(number_format($t->total, 2)); ?> FCFA</h4>
                                        </div>
                                        <div class="col-12">
                                            <h6 class="fw-semibold">Produits vendus :</h6>
                                            <div class="table-responsive">
                                                <table class="table table-sm table-hover">
                                                    <thead class="table-light">
                                                        <tr>
                                                            <th>Produit</th>
                                                            <th>Qté</th>
                                                            <th>Prix unitaire</th>
                                                            <th>Sous-total</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <?php $__currentLoopData = $t->lignes; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $ligne): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                                                        <tr>
                                                            <td><?php echo e($ligne->produit?->nom ?? 'Produit inconnu'); ?></td>
                                                            <td><?php echo e($ligne->quantite); ?></td>
                                                            <td><?php echo e(number_format($ligne->prix_unitaire, 2)); ?> FCFA</td>
                                                            <td><?php echo e(number_format($ligne->sous_total, 2)); ?> FCFA</td>
                                                        </tr>
                                                        <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <a href="<?php echo e(route('ventes.download', $t->id)); ?>" class="btn btn-success">
                                        <i class="fa-solid fa-download me-2"></i>Télécharger PDF
                                    </a>
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Fermer</button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function() {
    // Données de secours avec la syntaxe PHP correcte
    const weeklyLabels = <?php echo json_encode($stats['weekly_sales_labels'] ?? ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']); ?>;
    const weeklyData = <?php echo json_encode($stats['weekly_sales_data'] ?? [8000, 6000, 4000, 2000, 8500, 9500, 7000]); ?>;
    
    // Pour store traffic, on vérifie si les données existent
    let trafficLabels = [];
    let trafficData = [];
    
    <?php if(isset($stats['store_traffic']) && count($stats['store_traffic']) > 0): ?>
        trafficLabels = <?php echo json_encode(array_column($stats['store_traffic'], 'hour')); ?>;
        trafficData = <?php echo json_encode(array_column($stats['store_traffic'], 'value')); ?>;
    <?php else: ?>
        trafficLabels = ['9AM', '11AM', '1PM', '3PM', '5PM', '7PM'];
        trafficData = [160, 120, 80, 40, 140, 90];
    <?php endif; ?>

    // Weekly Sales Chart
    new Chart(document.getElementById('weeklySales'), {
        type: 'line',
        data: {
            labels: weeklyLabels,
            datasets: [{
                label: 'Weekly Sales',
                data: weeklyData,
                borderColor: '#4361EE',
                backgroundColor: 'rgba(67, 97, 238, 0.1)',
                borderWidth: 2,
                fill: true,
                tension: 0.4,
                pointBackgroundColor: '#4361EE',
                pointBorderColor: '#fff',
                pointBorderWidth: 2,
                pointRadius: 4
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: true,
            aspectRatio: window.innerWidth < 768 ? 1.5 : 2,
            plugins: {
                legend: {
                    display: false
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    grid: {
                        color: 'rgba(0, 0, 0, 0.05)'
                    }
                },
                x: {
                    grid: {
                        display: false
                    }
                }
            }
        }
    });

    // Store Traffic Chart
    new Chart(document.getElementById('storeTraffic'), {
        type: 'bar',
        data: {
            labels: trafficLabels,
            datasets: [{
                label: 'Store Traffic',
                data: trafficData,
                backgroundColor: '#4CC9F0',
                borderRadius: 6,
                barPercentage: window.innerWidth < 768 ? 0.6 : 0.4,
                categoryPercentage: window.innerWidth < 768 ? 0.8 : 0.6
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: true,
            aspectRatio: window.innerWidth < 768 ? 1.5 : 2,
            plugins: {
                legend: {
                    display: false
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    grid: {
                        color: 'rgba(0, 0, 0, 0.05)'
                    }
                },
                x: {
                    grid: {
                        display: false
                    }
                }
            }
        }
    });
});

// Ajuster les graphiques lors du redimensionnement
window.addEventListener('resize', function() {
    location.reload(); // Recharger les graphiques avec les nouvelles dimensions
});
</script>

<style>
.chart-container {
    position: relative;
    height: 250px;
    width: 100%;
    margin: 0 auto;
}

@media (min-width: 768px) {
    .chart-container {
        height: 300px;
    }
}

/* Effet de survol pour les cartes */
.hover-card {
    transition: transform 0.2s, box-shadow 0.2s;
}

.hover-card:hover {
    transform: translateY(-4px);
    box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1) !important;
}

/* Ajustements responsifs */
@media (max-width: 576px) {
    .card-body {
        padding: 1rem !important;
    }
    
    h4 {
        font-size: 1.1rem !important;
    }
    
    .fs-5 {
        font-size: 1rem !important;
    }
}

/* Styles pour les icônes */
.rounded-circle {
    transition: transform 0.2s;
}

.hover-card:hover .rounded-circle {
    transform: scale(1.1);
}
</style>
<?php $__env->stopSection(); ?>
<?php echo $__env->make('layouts.app', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH D:\modif\projet_soutenance_l3\backend\resources\views/dashboard.blade.php ENDPATH**/ ?>