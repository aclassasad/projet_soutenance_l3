<?php $__env->startSection('content'); ?>
<div class="container mt-4">
    <h3>Historique des ventes</h3>
    <table class="table table-striped">
        <thead>
            <tr>
                <th>ID Vente</th>
                <th>Date</th>
                <th>Total</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
            <?php $__currentLoopData = $ventes; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $vente): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
            <tr>
                <td><?php echo e($vente->id); ?></td>
                <td><?php echo e($vente->date_vente); ?></td>
                <td><?php echo e($vente->total); ?> FCFA</td>
                <td>
                    <a href="<?php echo e(route('caissier.pdf', $vente->id)); ?>" target="_blank" class="btn btn-sm btn-primary">
                        Télécharger PDF
                    </a>
                </td>
            </tr>
            <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
        </tbody>
    </table>
</div>
<?php $__env->stopSection(); ?>
<?php echo $__env->make('layouts.cashier', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH D:\modif\projet_soutenance_l3\backend\resources\views/caissier/historique.blade.php ENDPATH**/ ?>