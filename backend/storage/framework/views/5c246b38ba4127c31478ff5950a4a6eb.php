<?php $__env->startSection('title', 'Catégories'); ?>

<?php $__env->startSection('content'); ?>
<div class="container mt-4">
    <h3>Liste des Catégories</h3>

    <a href="<?php echo e(route('inventory')); ?>" class="btn btn-secondary mb-3">← Back to Inventory</a>
    <a href="<?php echo e(route('categories.create')); ?>" class="btn btn-success mb-3">+ Nouvelle Catégorie</a>

    <?php if(session('success')): ?>
        <div class="alert alert-success"><?php echo e(session('success')); ?></div>
    <?php endif; ?>

    <table class="table table-bordered">
        <thead>
            <tr>
                <th>ID</th>
                <th>Nom</th>
                <th>Description</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <?php $__currentLoopData = $categories; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $cat): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
            <tr>
                <td><?php echo e($cat->id); ?></td>
                <td><?php echo e($cat->nom); ?></td>
                <td><?php echo e($cat->description); ?></td>
                <td>
    <div class="btn-group" role="group">
        <a href="<?php echo e(route('categories.show', $cat)); ?>" class="btn btn-sm btn-outline-info" title="Voir">
            <i class="bi bi-eye"></i>
        </a>
        <a href="<?php echo e(route('categories.edit', $cat)); ?>" class="btn btn-sm btn-outline-primary" title="Modifier">
            <i class="bi bi-pencil"></i>
        </a>
        <form action="<?php echo e(route('categories.destroy', $cat)); ?>" method="POST" class="d-inline">
            <?php echo csrf_field(); ?>
            <?php echo method_field('DELETE'); ?>
            <button class="btn btn-sm btn-outline-danger" title="Supprimer" onclick="return confirm('Supprimer cette catégorie ?')">
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
<?php echo $__env->make('layouts.app', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH D:\modif\projet_soutenance_l3\backend\resources\views/categories/index.blade.php ENDPATH**/ ?>