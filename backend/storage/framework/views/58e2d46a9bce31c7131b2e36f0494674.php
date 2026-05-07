<?php $__env->startSection('title', 'Mot de passe oublié'); ?>
<?php $__env->startSection('content'); ?>
<h3>Entrez votre email</h3>
<form method="POST" action="<?php echo e(route('password.sendCode')); ?>">
    <?php echo csrf_field(); ?>
    <input type="email" name="email" class="form-control mb-3" required>
    <button type="submit" class="btn btn-primary w-100">Envoyer le code</button>
</form>
<?php $__env->stopSection(); ?>
<?php echo $__env->make('layouts.auth', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH D:\modif\projet_soutenance_l3\backend\resources\views/auth/passwords/email.blade.php ENDPATH**/ ?>