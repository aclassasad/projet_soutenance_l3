<?php $__env->startSection('title', 'Fournisseurs'); ?>

<?php $__env->startSection('content'); ?>
<div class="container mt-4">
    <h3>Liste des Fournisseurs</h3>

    <!-- Boutons -->
    <a href="<?php echo e(route('fournisseurs.create')); ?>" class="btn btn-success mb-3">+ Nouveau Fournisseur</a>
    <a href="<?php echo e(route('inventory')); ?>" class="btn btn-secondary mb-3">← Retour à l’inventaire</a>

    <?php if(session('success')): ?>
        <div class="alert alert-success"><?php echo e(session('success')); ?></div>
    <?php endif; ?>

    <table class="table table-bordered">
        <thead>
            <tr>
                <th>ID</th>
                <th>Nom</th>
                <th>Email</th>
                <th>Téléphone</th>
                <th>Adresse</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <?php $__currentLoopData = $fournisseurs; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $fournisseur): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
            <tr>
                <td><?php echo e($fournisseur->id); ?></td>
                <td><?php echo e($fournisseur->nom); ?></td>
                <td><?php echo e($fournisseur->email); ?></td>
                <td><?php echo e($fournisseur->telephone); ?></td>
                <td><?php echo e($fournisseur->adresse); ?></td>
                <td>
                    <div class="btn-group" role="group">
                        <a href="<?php echo e(route('fournisseurs.show', $fournisseur)); ?>" class="btn btn-sm btn-outline-info" title="Voir">
                            <i class="bi bi-eye"></i>
                        </a>
                        <a href="<?php echo e(route('fournisseurs.edit', $fournisseur)); ?>" class="btn btn-sm btn-outline-primary" title="Modifier">
                            <i class="bi bi-pencil"></i>
                        </a>
                        <form action="<?php echo e(route('fournisseurs.destroy', $fournisseur)); ?>" method="POST" class="d-inline">
                            <?php echo csrf_field(); ?>
                            <?php echo method_field('DELETE'); ?>
                            <button class="btn btn-sm btn-outline-danger" title="Supprimer" onclick="return confirm('Supprimer ce fournisseur ?')">
                                <i class="bi bi-trash"></i>
                            </button>
                        </form>
                    </div>
                </td>
            </tr>
            <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
        </tbody>
    </table>
</div>
<?php $__env->stopSection(); ?>
<?php echo $__env->make('layouts.app', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH D:\modif\projet_soutenance_l3\backend\resources\views/fournisseurs/index.blade.php ENDPATH**/ ?>