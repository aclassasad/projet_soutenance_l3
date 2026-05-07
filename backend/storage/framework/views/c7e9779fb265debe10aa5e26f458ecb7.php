<!DOCTYPE html>
<html lang="<?php echo e(app()->getLocale()); ?>">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Connexion</title>
    <link rel="stylesheet" href="<?php echo e(asset('css/connexion.css')); ?>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
</head>
<body>
    <div class="logo">
        <a href="<?php echo e(route('dashboard')); ?>"><img src="<?php echo e(asset('images/logo.jpeg')); ?>" alt="Logo" class="desktop"></a>
    </div>

    <div class="gauche">
        
        
            <div class="social-icons">
                <a href="#" class="social-icon"><i class="fab fa-facebook-f"></i></a>
                <a href="#" class="social-icon"><i class="fab fa-youtube"></i></a>
                <a href="#" class="social-icon"><i class="fab fa-instagram"></i></a>
                <a href="#" class="social-icon"><i class="fab fa-twitter"></i></a>
            </div>
        
    </div>

    <div class="droite">
        <a href="<?php echo e(route('dashboard')); ?>"><img src="<?php echo e(asset('images/logo-bp1.png')); ?>" alt="Logo" class="mobilel"></a>
        <div class="wow">
            <h2>CONNEXION</h2>
            <p class="ouais">Veuillez entrer vos identifiants afin accrder à votre dashboard.</p>

            <form method="POST" action="<?php echo e(route('login.post')); ?>">
                <?php echo csrf_field(); ?>
                <label for="email">Email</label>
                <input type="email" id="email" name="email" placeholder="Entrer votre adresse email" required value="<?php echo e(old('email')); ?>">

                <label for="password">Mot de passe</label>
                <input type="password" id="password" name="password" placeholder="Entrer votre mot de passe" required>

                <?php $__errorArgs = ['email'];
$__bag = $errors->getBag($__errorArgs[1] ?? 'default');
if ($__bag->has($__errorArgs[0])) :
if (isset($message)) { $__messageOriginal = $message; }
$message = $__bag->first($__errorArgs[0]); ?>
                    <div class="text-danger small" style="color: red;"><?php echo e($message); ?></div>
                <?php unset($message);
if (isset($__messageOriginal)) { $message = $__messageOriginal; }
endif;
unset($__errorArgs, $__bag); ?>

                <a href="<?php echo e(route('password.request')); ?>" class="forgot-password">Mot de passe oublié ?</a>

                <button type="submit" class="connexion-button">Connexion</button>

            </form>
        </div>
    </div>
</body>
</html><?php /**PATH D:\modif\projet_soutenance_l3\backend\resources\views/auth/login.blade.php ENDPATH**/ ?>