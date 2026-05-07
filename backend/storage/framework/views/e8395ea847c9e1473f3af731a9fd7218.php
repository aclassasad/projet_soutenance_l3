<?php $__empty_1 = true; $__currentLoopData = $produits; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $p): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); $__empty_1 = false; ?>
<tr>
    <td class="px-4 py-3 fw-semibold">SKU-<?php echo e(str_pad($p->id, 5, '0', STR_PAD_LEFT)); ?></td>
    <td class="px-4 py-3"><?php echo e($p->nom); ?></td>
    <td class="px-4 py-3"><?php echo e($p->categorie->nom ?? 'N/A'); ?></td>
    <td class="px-4 py-3"><?php echo e($p->stock); ?> units</td>
    <td class="px-4 py-3"><?php echo e(number_format($p->prix_vente, 2)); ?> FCFA</td>
    <td class="px-4 py-3"><?php echo e($p->emplacement ?? 'A-' . str_pad($p->id, 2, '0', STR_PAD_LEFT)); ?></td>
    <td class="px-4 py-3">
        <?php if($p->stock == 0): ?>
            <span class="badge bg-danger bg-opacity-10 text-danger px-3 py-2 rounded-pill fw-semibold">OUT OF STOCK</span>
        <?php elseif($p->stock <= $p->seuil_alerte): ?>
            <span class="badge bg-warning bg-opacity-10 text-warning px-3 py-2 rounded-pill fw-semibold">LOW STOCK</span>
        <?php else: ?>
            <span class="badge bg-success bg-opacity-10 text-success px-3 py-2 rounded-pill fw-semibold">IN STOCK</span>
        <?php endif; ?>
    </td>
    <td class="px-4 py-3">
        <div class="d-flex gap-2">
            <a href="<?php echo e(route('produits.edit', $p->id)); ?>" class="btn btn-sm btn-link p-0 text-secondary">
                <i class="fa-regular fa-pen-to-square"></i>
            </a>
            <button class="btn btn-sm btn-link p-0 text-secondary" onclick="deleteProduct(<?php echo e($p->id); ?>)">
                <i class="fa-regular fa-trash-can"></i>
            </button>
        </div>
    </td>
</tr>
<?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); if ($__empty_1): ?>
<tr>
    <td colspan="8" class="text-center py-5 text-muted">
        <i class="fa-solid fa-box-open fs-1 d-block mb-3"></i>
        No products found
    </td>
</tr>
<?php endif; ?><?php /**PATH D:\modif\projet_soutenance_l3\backend\resources\views/partials/inventory_table.blade.php ENDPATH**/ ?>