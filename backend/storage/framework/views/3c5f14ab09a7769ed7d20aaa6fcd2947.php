<?php $__env->startSection('title', 'Ajouter un employé'); ?>

<?php $__env->startSection('content'); ?>
<div class="container mt-4">
    <h3>Ajouter un employé</h3>

    <form action="<?php echo e(route('users.store')); ?>" method="POST">
        <?php echo csrf_field(); ?>

        <div class="mb-3">
            <label for="name" class="form-label">Nom</label>
            <input type="text" name="name" id="name" class="form-control" required>
        </div>

        <div class="mb-3">
            <label for="email" class="form-label">Email</label>
            <input type="email" name="email" id="email" class="form-control" required>
        </div>

        <div class="mb-3">
            <label for="password" class="form-label">Mot de passe</label>
            <input type="password" name="password" id="password" class="form-control" required>
        </div>

        <div class="mb-3">
            <label for="role" class="form-label">Rôle</label>
            <select name="role" id="role" class="form-select" required>
                <option value="admin">Admin</option>
                <option value="gerant">Gérant</option>
                <option value="caissier">Caissier</option>
            </select>
        </div>

        <div class="mb-3">
            <label for="statut" class="form-label">Statut</label>
            <select name="statut" id="statut" class="form-select">
                <option value="1">Actif</option>
                <option value="0">En congé</option>
            </select>
        </div>

        <button type="submit" class="btn btn-success">Créer</button>
        <a href="<?php echo e(route('users.index')); ?>" class="btn btn-secondary">Annuler</a>
    </form>
</div>
<?php $__env->stopSection(); ?>
<?php echo $__env->make('layouts.app', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH D:\modif\projet_soutenance_l3\backend\resources\views/users/create.blade.php ENDPATH**/ ?>