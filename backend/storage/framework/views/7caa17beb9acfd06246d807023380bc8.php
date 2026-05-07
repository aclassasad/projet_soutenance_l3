<?php $__env->startSection('title', 'Créer un fournisseur'); ?>

<?php $__env->startSection('content'); ?>
<div class="container mt-4">
    <h3>Nouveau Fournisseur</h3>

    <form action="<?php echo e(route('fournisseurs.store')); ?>" method="POST">
        <?php echo csrf_field(); ?>
        <div class="mb-3">
            <label for="nom" class="form-label">Nom</label>
            <input type="text" name="nom" id="nom" class="form-control" required>
        </div>

        <div class="mb-3">
            <label for="email" class="form-label">Email</label>
            <input type="email" name="email" id="email" class="form-control">
        </div>

        <div class="mb-3">
            <label for="telephone" class="form-label">Téléphone</label>
            <input type="text" name="telephone" id="telephone" class="form-control">
        </div>

        <div class="mb-3">
            <label for="adresse" class="form-label">Adresse</label>
            <textarea name="adresse" id="adresse" class="form-control"></textarea>
        </div>

        <button type="submit" class="btn btn-success">Enregistrer</button>
        <a href="<?php echo e(route('fournisseurs.index')); ?>" class="btn btn-secondary">Annuler</a>
    </form>
</div>
<?php $__env->stopSection(); ?>
<?php echo $__env->make('layouts.app', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH D:\modif\projet_soutenance_l3\backend\resources\views/fournisseurs/create.blade.php ENDPATH**/ ?>