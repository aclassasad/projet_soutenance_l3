<?php $__env->startSection('title', 'Modifier un produit'); ?>

<?php $__env->startSection('content'); ?>
<div class="container mt-4">
    <h3>Modifier Produit</h3>

    <form action="<?php echo e(route('produits.update', $produit->id)); ?>" method="POST">
        <?php echo csrf_field(); ?>
        <?php echo method_field('PUT'); ?>

        <div class="mb-3">
            <label for="nom" class="form-label">Nom du produit</label>
            <input type="text" name="nom" id="nom" class="form-control" value="<?php echo e($produit->nom); ?>" required>
        </div>

        <div class="mb-3">
            <label for="description" class="form-label">Description</label>
            <textarea name="description" id="description" class="form-control"><?php echo e($produit->description); ?></textarea>
        </div>

        <div class="mb-3">
            <label for="prix_achat" class="form-label">Prix d'achat</label>
            <input type="number" step="0.01" name="prix_achat" id="prix_achat" class="form-control" value="<?php echo e($produit->prix_achat); ?>" required>
        </div>

        <div class="mb-3">
            <label for="prix_vente" class="form-label">Prix de vente</label>
            <input type="number" step="0.01" name="prix_vente" id="prix_vente" class="form-control" value="<?php echo e($produit->prix_vente); ?>" required>
        </div>

        <div class="mb-3">
            <label for="stock" class="form-label">Stock</label>
            <input type="number" name="stock" id="stock" class="form-control" value="<?php echo e($produit->stock); ?>" required>
        </div>

        <div class="mb-3">
            <label for="seuil_alerte" class="form-label">Seuil d'alerte</label>
            <input type="number" name="seuil_alerte" id="seuil_alerte" class="form-control" value="<?php echo e($produit->seuil_alerte); ?>" required>
        </div>

        <div class="mb-3">
            <label for="categorie_id" class="form-label">Catégorie</label>
            <select name="categorie_id" id="categorie_id" class="form-select" required>
                <?php $__currentLoopData = $categories; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $cat): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                    <option value="<?php echo e($cat->id); ?>" <?php if($produit->categorie_id == $cat->id): ?> selected <?php endif; ?>><?php echo e($cat->nom); ?></option>
                <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
            </select>
        </div>

        <div class="mb-3">
            <label for="fournisseur_id" class="form-label">Fournisseur</label>
            <select name="fournisseur_id" id="fournisseur_id" class="form-select" required>
                <?php $__currentLoopData = $fournisseurs; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $f): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                    <option value="<?php echo e($f->id); ?>" <?php if($produit->fournisseur_id == $f->id): ?> selected <?php endif; ?>><?php echo e($f->nom); ?></option>
                <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
            </select>
        </div>

        <button type="submit" class="btn btn-primary">Mettre à jour</button>
        <a href="<?php echo e(route('produits.index')); ?>" class="btn btn-secondary">Annuler</a>
    </form>
</div>
<?php $__env->stopSection(); ?>
<?php echo $__env->make('layouts.app', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH D:\modif\projet_soutenance_l3\backend\resources\views/produits/edit.blade.php ENDPATH**/ ?>