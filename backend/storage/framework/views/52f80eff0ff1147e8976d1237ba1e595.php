<?php $__env->startSection('title', 'Détails Employé'); ?>

<?php $__env->startSection('content'); ?>
<div class="container-fluid px-3 px-md-4">
    <!-- Header avec navigation -->
    <div class="d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center mb-4">
        <div>
            <h2 class="fw-bold mb-1">Détails de l'employé</h2>
            <p class="text-muted mb-0">Informations et historique des ventes</p>
        </div>
        <div class="mt-2 mt-md-0">
            <a href="<?php echo e(route('users.index')); ?>" class="btn btn-outline-secondary me-2">
                <i class="fa-solid fa-arrow-left me-2"></i>Retour
            </a>
            <a href="<?php echo e(route('users.edit', $user)); ?>" class="btn btn-primary">
                <i class="fa-solid fa-pen-to-square me-2"></i>Modifier
            </a>
        </div>
    </div>

    <!-- Informations de l'employé -->
    <div class="row g-4 mb-4">
        <div class="col-12 col-md-4">
            <div class="card border-0 shadow-sm h-100">
                <div class="card-body">
                    <div class="d-flex align-items-center mb-3">
                        <div class="rounded-circle bg-primary bg-opacity-10 d-flex align-items-center justify-content-center me-3" style="width: 60px; height: 60px;">
                            <i class="fa-solid fa-user text-primary fs-2"></i>
                        </div>
                        <div>
                            <h4 class="fw-bold mb-1"><?php echo e($user->name); ?></h4>
                            <span class="badge bg-<?php echo e($user->role === 'admin' ? 'danger' : ($user->role === 'gerant' ? 'warning' : 'info')); ?> bg-opacity-10 text-<?php echo e($user->role === 'admin' ? 'danger' : ($user->role === 'gerant' ? 'warning' : 'info')); ?> px-3 py-2 rounded-pill">
                                <?php echo e(strtoupper($user->role)); ?>

                            </span>
                        </div>
                    </div>
                    
                    <hr>
                    
                    <div class="mb-3">
                        <div class="d-flex align-items-center mb-2">
                            <i class="fa-regular fa-envelope text-muted me-2" style="width: 20px;"></i>
                            <span><?php echo e($user->email); ?></span>
                        </div>
                        <div class="d-flex align-items-center mb-2">
                            <i class="fa-regular fa-calendar text-muted me-2" style="width: 20px;"></i>
                            <span>Inscrit le <?php echo e($user->created_at->format('d/m/Y')); ?></span>
                        </div>
                        <div class="d-flex align-items-center">
                            <i class="fa-regular fa-clock text-muted me-2" style="width: 20px;"></i>
                            <?php if($user->statut): ?>
                                <span class="text-success">
                                    <i class="fa-solid fa-circle me-1" style="font-size: 8px;"></i> Actif
                                </span>
                            <?php else: ?>
                                <span class="text-secondary">
                                    <i class="fa-solid fa-circle me-1" style="font-size: 8px;"></i> En congé
                                </span>
                            <?php endif; ?>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Statistiques des ventes -->
        <div class="col-12 col-md-8">
            <div class="row g-4">
                <div class="col-12 col-sm-4">
                    <div class="card border-0 shadow-sm h-100">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <h6 class="text-muted mb-2">Total des ventes</h6>
                                    <h3 class="fw-bold mb-0"><?php echo e($ventes->count()); ?></h3>
                                </div>
                                <div class="bg-primary bg-opacity-10 rounded-3 p-3">
                                    <i class="fa-solid fa-cart-shopping text-primary fs-3"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-12 col-sm-4">
                    <div class="card border-0 shadow-sm h-100">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <h6 class="text-muted mb-2">Chiffre d'affaires</h6>
                                    <h3 class="fw-bold mb-0"><?php echo e(number_format($totalVentes, 0, ',', ' ')); ?> FCFA</h3>
                                </div>
                                <div class="bg-success bg-opacity-10 rounded-3 p-3">
                                    <i class="fa-solid fa-money-bill text-success fs-3"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-12 col-sm-4">
                    <div class="card border-0 shadow-sm h-100">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <h6 class="text-muted mb-2">Panier moyen</h6>
                                    <h3 class="fw-bold mb-0"><?php echo e($ventes->count() > 0 ? number_format($totalVentes / $ventes->count(), 0, ',', ' ') : 0); ?> FCFA</h3>
                                </div>
                                <div class="bg-info bg-opacity-10 rounded-3 p-3">
                                    <i class="fa-solid fa-calculator text-info fs-3"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Historique des ventes -->
    <div class="card border-0 shadow-sm">
        <div class="card-header bg-transparent border-0 pt-4 px-4">
            <h5 class="fw-semibold mb-0">Historique des ventes</h5>
        </div>
        <div class="card-body p-0">
            <?php if($ventes->count() > 0): ?>
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th class="px-4 py-3 text-muted fw-semibold">N° Vente</th>
                                <th class="px-4 py-3 text-muted fw-semibold">Date</th>
                                <th class="px-4 py-3 text-muted fw-semibold text-end">Total</th>
                                <th class="px-4 py-3 text-muted fw-semibold text-center">Articles</th>
                                <th class="px-4 py-3 text-muted fw-semibold text-center">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php $__currentLoopData = $ventes; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $vente): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                            <tr>
                                <td class="px-4 py-3 fw-semibold">#<?php echo e($vente->id); ?></td>
                                <td class="px-4 py-3"><?php echo e($vente->created_at->format('d/m/Y H:i')); ?></td>
                                <td class="px-4 py-3 text-end fw-bold text-success"><?php echo e(number_format($vente->total, 0, ',', ' ')); ?> FCFA</td>
                                <td class="px-4 py-3 text-center"><?php echo e($vente->lignes_count ?? $vente->lignes->count()); ?> article(s)</td>
                                <td class="px-4 py-3 text-center">
                                    <button class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#venteModal<?php echo e($vente->id); ?>">
                                        <i class="fa-regular fa-eye"></i>
                                        <span class="d-none d-md-inline ms-1">Détails</span>
                                    </button>
                                </td>
                            </tr>
                            <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                        </tbody>
                    </table>
                </div>
            <?php else: ?>
                <div class="text-center py-5">
                    <i class="fa-solid fa-receipt fs-1 text-muted mb-3 opacity-25"></i>
                    <p class="text-muted">Aucune vente enregistrée pour cet employé</p>
                </div>
            <?php endif; ?>
        </div>
    </div>

    <!-- Modals des ventes -->
    <?php $__currentLoopData = $ventes; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $vente): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
    <div class="modal fade" id="venteModal<?php echo e($vente->id); ?>" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title">
                        <i class="fa-solid fa-receipt me-2"></i>Détails de la vente #<?php echo e($vente->id); ?>

                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="row g-3 mb-3">
                        <div class="col-6">
                            <p class="mb-1 text-muted small">Date</p>
                            <p class="fw-semibold"><?php echo e($vente->created_at->format('d/m/Y H:i')); ?></p>
                        </div>
                        <div class="col-6">
                            <p class="mb-1 text-muted small">Caissier</p>
                            <p class="fw-semibold"><?php echo e($vente->user->name); ?></p>
                        </div>
                    </div>

                    <h6 class="fw-semibold mb-3">Articles vendus</h6>
                    <div class="table-responsive">
                        <table class="table table-sm">
                            <thead class="table-light">
                                <tr>
                                    <th>Produit</th>
                                    <th class="text-center">Quantité</th>
                                    <th class="text-end">Prix unitaire</th>
                                    <th class="text-end">Sous-total</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php $__currentLoopData = $vente->lignes; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $ligne): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                                <tr>
                                    <td><?php echo e($ligne->produit?->nom ?? 'Produit inconnu'); ?></td>
                                    <td class="text-center"><?php echo e($ligne->quantite); ?></td>
                                    <td class="text-end"><?php echo e(number_format($ligne->prix_unitaire, 0, ',', ' ')); ?> FCFA</td>
                                    <td class="text-end fw-semibold"><?php echo e(number_format($ligne->sous_total, 0, ',', ' ')); ?> FCFA</td>
                                </tr>
                                <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                            </tbody>
                            <tfoot class="table-light">
                                <tr>
                                    <td colspan="3" class="text-end fw-bold">Total</td>
                                    <td class="text-end fw-bold text-success"><?php echo e(number_format($vente->total, 0, ',', ' ')); ?> FCFA</td>
                                </tr>
                            </tfoot>
                        </table>
                    </div>
                </div>
                <div class="modal-footer">
                    <a href="<?php echo e(route('ventes.download', $vente->id)); ?>" class="btn btn-success">
                        <i class="fa-solid fa-download me-2"></i>Télécharger PDF
                    </a>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Fermer</button>
                </div>
            </div>
        </div>
    </div>
    <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
</div>

<style>
.hover-card {
    transition: transform 0.2s, box-shadow 0.2s;
}

.hover-card:hover {
    transform: translateY(-4px);
    box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1) !important;
}

@media (max-width: 768px) {
    .table td, .table th {
        padding: 0.75rem !important;
        font-size: 0.9rem;
    }
}
</style>
<?php $__env->stopSection(); ?>
<?php echo $__env->make('layouts.app', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH D:\modif\projet_soutenance_l3\backend\resources\views/users/show.blade.php ENDPATH**/ ?>