<?php $__env->startSection('content'); ?>
<div class="container mt-4">
    <h3>Produits en alerte stock</h3>
    <table class="table table-bordered">
        <thead>
            <tr>
                <th>Nom</th>
                <th>Stock</th>
                <th>Seuil alerte</th>
            </tr>
        </thead>
        <tbody>
            <?php $__currentLoopData = $produits; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $p): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
            <tr>
                <td><?php echo e($p->nom); ?></td>
                <td><?php echo e($p->stock); ?></td>
                <td><?php echo e($p->seuil_alerte); ?></td>
            </tr>
            <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
        </tbody>
    </table>
</div>
<?php $__env->stopSection(); ?>
<?php echo $__env->make('layouts.cashier', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH D:\modif\projet_soutenance_l3\backend\resources\views/caissier/stock.blade.php ENDPATH**/ ?>