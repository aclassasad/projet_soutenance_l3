<?php $__env->startSection('content'); ?>
<div class="container mt-4">
    <h3>Statistiques du jour</h3>
    <p>Nombre de ventes : <?php echo e($ventesJour); ?></p>
    <p>Total encaissé : <?php echo e($totalJour); ?> FCFA</p>

    <h4>Top 5 produits vendus</h4>
    <ul>
        <?php $__currentLoopData = $produitsTop; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $p): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
            <li><?php echo e($p->produit->nom); ?> (<?php echo e($p->total); ?> vendus)</li>
        <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
    </ul>
</div>
<?php $__env->stopSection(); ?>
<?php echo $__env->make('layouts.cashier', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH D:\modif\projet_soutenance_l3\backend\resources\views/caissier/stats.blade.php ENDPATH**/ ?>