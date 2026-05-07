<?php $__env->startSection('title', 'Vérification du code'); ?>

<?php $__env->startSection('content'); ?>
<h3>Entrez le code reçu et votre nouveau mot de passe</h3>

<?php if(session('status')): ?>
    <div class="alert alert-success"><?php echo e(session('status')); ?></div>
<?php endif; ?>

<?php if($errors->any()): ?>
    <div class="alert alert-danger">
        <ul class="mb-0">
            <?php $__currentLoopData = $errors->all(); $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $error): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                <li><?php echo e($error); ?></li>
            <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
        </ul>
    </div>
<?php endif; ?>

<form method="POST" action="<?php echo e(route('password.verifyCode')); ?>">
    <?php echo csrf_field(); ?>

    <div class="mb-3">
        <input type="text" name="code"
               class="form-control <?php $__errorArgs = ['code'];
$__bag = $errors->getBag($__errorArgs[1] ?? 'default');
if ($__bag->has($__errorArgs[0])) :
if (isset($message)) { $__messageOriginal = $message; }
$message = $__bag->first($__errorArgs[0]); ?> is-invalid <?php unset($message);
if (isset($__messageOriginal)) { $message = $__messageOriginal; }
endif;
unset($__errorArgs, $__bag); ?>"
               placeholder="Code à 6 chiffres" required>
        <?php $__errorArgs = ['code'];
$__bag = $errors->getBag($__errorArgs[1] ?? 'default');
if ($__bag->has($__errorArgs[0])) :
if (isset($message)) { $__messageOriginal = $message; }
$message = $__bag->first($__errorArgs[0]); ?>
            <div class="invalid-feedback"><?php echo e($message); ?></div>
        <?php unset($message);
if (isset($__messageOriginal)) { $message = $__messageOriginal; }
endif;
unset($__errorArgs, $__bag); ?>
    </div>

    
    <div class="mb-3">
        <input type="password" id="password" name="password"
               class="form-control <?php $__errorArgs = ['password'];
$__bag = $errors->getBag($__errorArgs[1] ?? 'default');
if ($__bag->has($__errorArgs[0])) :
if (isset($message)) { $__messageOriginal = $message; }
$message = $__bag->first($__errorArgs[0]); ?> is-invalid <?php unset($message);
if (isset($__messageOriginal)) { $message = $__messageOriginal; }
endif;
unset($__errorArgs, $__bag); ?>"
               placeholder="Nouveau mot de passe" required>
        <div id="passwordHelp" class="form-text text-muted">
            Le mot de passe doit contenir au moins 8 caractères, une majuscule, un chiffre et un caractère spécial.
        </div>
        <div class="progress mt-2">
            <div id="passwordStrength" class="progress-bar" role="progressbar" style="width: 0%">
                Faible
            </div>
        </div>
        <?php $__errorArgs = ['password'];
$__bag = $errors->getBag($__errorArgs[1] ?? 'default');
if ($__bag->has($__errorArgs[0])) :
if (isset($message)) { $__messageOriginal = $message; }
$message = $__bag->first($__errorArgs[0]); ?>
            <div class="invalid-feedback"><?php echo e($message); ?></div>
        <?php unset($message);
if (isset($__messageOriginal)) { $message = $__messageOriginal; }
endif;
unset($__errorArgs, $__bag); ?>
    </div>

    
    <div class="mb-3">
        <input type="password" id="password_confirmation" name="password_confirmation"
               class="form-control <?php $__errorArgs = ['password_confirmation'];
$__bag = $errors->getBag($__errorArgs[1] ?? 'default');
if ($__bag->has($__errorArgs[0])) :
if (isset($message)) { $__messageOriginal = $message; }
$message = $__bag->first($__errorArgs[0]); ?> is-invalid <?php unset($message);
if (isset($__messageOriginal)) { $message = $__messageOriginal; }
endif;
unset($__errorArgs, $__bag); ?>"
               placeholder="Confirmer le mot de passe" required>
        <div id="confirmFeedback" class="invalid-feedback"></div>
        <?php $__errorArgs = ['password_confirmation'];
$__bag = $errors->getBag($__errorArgs[1] ?? 'default');
if ($__bag->has($__errorArgs[0])) :
if (isset($message)) { $__messageOriginal = $message; }
$message = $__bag->first($__errorArgs[0]); ?>
            <div class="invalid-feedback"><?php echo e($message); ?></div>
        <?php unset($message);
if (isset($__messageOriginal)) { $message = $__messageOriginal; }
endif;
unset($__errorArgs, $__bag); ?>
    </div>

    <button type="submit" class="btn btn-success w-100">Changer le mot de passe</button>
</form>


<script>
document.addEventListener('DOMContentLoaded', function () {
    const password = document.getElementById('password');
    const confirm = document.getElementById('password_confirmation');
    const strengthBar = document.getElementById('passwordStrength');
    const confirmFeedback = document.getElementById('confirmFeedback');

    password.addEventListener('input', function () {
        const value = password.value;
        let strength = 0;

        if (value.length >= 8) strength++;
        if (/[A-Z]/.test(value)) strength++;
        if (/\d/.test(value)) strength++;
        if (/[^A-Za-z\d]/.test(value)) strength++;

        // Mise à jour de la barre
        switch (strength) {
            case 0:
            case 1:
                strengthBar.style.width = "25%";
                strengthBar.className = "progress-bar bg-danger";
                strengthBar.textContent = "Faible";
                break;
            case 2:
                strengthBar.style.width = "50%";
                strengthBar.className = "progress-bar bg-warning";
                strengthBar.textContent = "Moyen";
                break;
            case 3:
                strengthBar.style.width = "75%";
                strengthBar.className = "progress-bar bg-info";
                strengthBar.textContent = "Bon";
                break;
            case 4:
                strengthBar.style.width = "100%";
                strengthBar.className = "progress-bar bg-success";
                strengthBar.textContent = "Fort";
                break;
        }
    });

    confirm.addEventListener('input', function () {
        if (confirm.value !== password.value) {
            confirm.classList.add('is-invalid');
            confirmFeedback.textContent = "Les deux mots de passe ne correspondent pas.";
        } else {
            confirm.classList.remove('is-invalid');
            confirm.classList.add('is-valid');
            confirmFeedback.textContent = "";
        }
    });
});
</script>
<?php $__env->stopSection(); ?>
<?php echo $__env->make('layouts.auth', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH D:\modif\projet_soutenance_l3\backend\resources\views/auth/passwords/code.blade.php ENDPATH**/ ?>