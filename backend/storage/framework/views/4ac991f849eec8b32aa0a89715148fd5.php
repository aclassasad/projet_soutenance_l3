<?php $__env->startSection('title', 'Produits'); ?>

<?php $__env->startSection('content'); ?>
<div class="container mt-4">
    <h3>Liste des Produits</h3>

    <!-- ✅ Bouton retour vers Inventory -->
    <a href="<?php echo e(route('inventory')); ?>" class="btn btn-secondary mb-3">← Back to Inventory</a>
    <a href="<?php echo e(route('produits.create')); ?>" class="btn btn-success mb-3">+ Nouveau Produit</a>

    <?php if(session('success')): ?>
        <div class="alert alert-success"><?php echo e(session('success')); ?></div>
    <?php endif; ?>

    <table class="table table-striped">
        <thead>
            <tr>
                <th>ID</th>
                <th>Nom</th>
                <th>Description</th>
                <th>Prix Achat</th>
                <th>Prix Vente</th>
                <th>Stock</th>
                <th>Catégorie</th>
                <th>Fournisseur</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <?php $__currentLoopData = $produits; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $p): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
            <tr>
                <td><?php echo e($p->id); ?></td>
                <td><?php echo e($p->nom); ?></td>
                <td><?php echo e($p->description); ?></td>
                <td><?php echo e($p->prix_achat); ?></td>
                <td><?php echo e($p->prix_vente); ?></td>
                <td><?php echo e($p->stock); ?></td>
                <td><?php echo e($p->categorie->nom ?? 'N/A'); ?></td>
                <td><?php echo e($p->fournisseur->nom ?? 'N/A'); ?></td>
               <td>
    <div class="btn-group" role="group">
        <a href="<?php echo e(route('produits.show', $p->id)); ?>" class="btn btn-sm btn-outline-info" title="Voir">
            <i class="bi bi-eye"></i>
        </a>
        <a href="<?php echo e(route('produits.edit', $p->id)); ?>" class="btn btn-sm btn-outline-primary" title="Modifier">
            <i class="bi bi-pencil"></i>
        </a>
        <form action="<?php echo e(route('produits.destroy', $p->id)); ?>" method="POST" class="d-inline">
            <?php echo csrf_field(); ?>
            <?php echo method_field('DELETE'); ?>
            <button class="btn btn-sm btn-outline-danger" title="Supprimer" onclick="return confirm('Supprimer ce produit ?')">
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
<?php echo $__env->make('layouts.app', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH D:\modif\projet_soutenance_l3\backend\resources\views/produits/index.blade.php ENDPATH**/ ?>