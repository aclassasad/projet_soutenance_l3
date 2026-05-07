<?php $__env->startSection('title', 'Modifier un employé'); ?>

<?php $__env->startSection('content'); ?>
<div class="container mt-4">
    <h3>Modifier Employé</h3>

    <form action="<?php echo e(route('users.update', $user)); ?>" method="POST">
        <?php echo csrf_field(); ?>
        <?php echo method_field('PUT'); ?>

        <div class="mb-3">
            <label for="name" class="form-label">Nom</label>
            <input type="text" name="name" id="name" class="form-control" value="<?php echo e($user->name); ?>" required>
        </div>

        <div class="mb-3">
            <label for="email" class="form-label">Email</label>
            <input type="email" name="email" id="email" class="form-control" value="<?php echo e($user->email); ?>" required>
        </div>

        <div class="mb-3">
            <label for="role" class="form-label">Rôle</label>
            <select name="role" id="role" class="form-select" required>
                <option value="admin" <?php echo e($user->role == 'admin' ? 'selected' : ''); ?>>Admin</option>
                <option value="gerant" <?php echo e($user->role == 'gerant' ? 'selected' : ''); ?>>Gérant</option>
                <option value="caissier" <?php echo e($user->role == 'caissier' ? 'selected' : ''); ?>>Caissier</option>
            </select>
        </div>

        <div class="mb-3">
            <label for="statut" class="form-label">Statut</label>
            <select name="statut" id="statut" class="form-select">
                <option value="1" <?php echo e($user->statut ? 'selected' : ''); ?>>Actif</option>
                <option value="0" <?php echo e(!$user->statut ? 'selected' : ''); ?>>En congé</option>
            </select>
        </div>

        <button type="submit" class="btn btn-primary">Mettre à jour</button>
        <a href="<?php echo e(route('users.index')); ?>" class="btn btn-secondary">Annuler</a>
    </form>
</div>
<?php $__env->stopSection(); ?>
<?php echo $__env->make('layouts.app', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH D:\modif\projet_soutenance_l3\backend\resources\views/users/edit.blade.php ENDPATH**/ ?>