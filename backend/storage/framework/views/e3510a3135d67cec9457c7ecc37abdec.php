<?php $__env->startSection('title', 'Settings'); ?>

<?php $__env->startSection('content'); ?>
<div class="container-fluid px-4">
    <h2 class="fw-bold mb-4"><?php echo e(__('settings.title')); ?></h2>

    <?php if(session('success')): ?>
    <div class="alert alert-success alert-dismissible fade show mb-4" role="alert">
        <?php echo e(session('success')); ?>

        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <?php endif; ?>

    <div class="row">
        <div class="col-md-6">
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-transparent border-0 pt-4">
                    <h5 class="fw-semibold mb-0"><?php echo e(__('settings.preferences')); ?></h5>
                </div>
                <div class="card-body">
                    <form method="POST" action="<?php echo e(route('settings.update')); ?>" id="settingsForm">
                        <?php echo csrf_field(); ?>
                        
                        <!-- Langue -->
                        <div class="mb-4">
                            <label class="form-label fw-semibold"><?php echo e(__('settings.language')); ?></label>
                            <div class="d-flex gap-4">
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="language" id="langEn" value="en" <?php echo e($settings['language'] === 'en' ? 'checked' : ''); ?>>
                                    <label class="form-check-label" for="langEn">
                                        <i class="fa-solid fa-language me-1"></i> English
                                    </label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="language" id="langFr" value="fr" <?php echo e($settings['language'] === 'fr' ? 'checked' : ''); ?>>
                                    <label class="form-check-label" for="langFr">
                                        <i class="fa-solid fa-language me-1"></i> Français
                                    </label>
                                </div>
                            </div>
                        </div>

                        <!-- Thème -->
                        <div class="mb-4">
                            <label class="form-label fw-semibold"><?php echo e(__('settings.theme')); ?></label>
                            <div class="d-flex gap-4">
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="theme" id="themeLight" value="light" <?php echo e($settings['theme'] === 'light' ? 'checked' : ''); ?>>
                                    <label class="form-check-label" for="themeLight">
                                        <i class="fa-regular fa-sun me-1"></i> <?php echo e(__('settings.light')); ?>

                                    </label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="theme" id="themeDark" value="dark" <?php echo e($settings['theme'] === 'dark' ? 'checked' : ''); ?>>
                                    <label class="form-check-label" for="themeDark">
                                        <i class="fa-regular fa-moon me-1"></i> <?php echo e(__('settings.dark')); ?>

                                    </label>
                                </div>
                            </div>
                        </div>

                        <!-- Notifications -->
                        <div class="mb-4">
                            <label class="form-label fw-semibold"><?php echo e(__('settings.notifications')); ?></label>
                            <div class="form-check form-switch mb-2">
                                <input class="form-check-input" type="checkbox" name="email_notifications" id="emailNotifications" <?php echo e($settings['email_notifications'] ?? true ? 'checked' : ''); ?>>
                                <label class="form-check-label" for="emailNotifications"><?php echo e(__('settings.email_notifications')); ?></label>
                            </div>
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" name="push_notifications" id="pushNotifications" <?php echo e($settings['push_notifications'] ?? true ? 'checked' : ''); ?>>
                                <label class="form-check-label" for="pushNotifications"><?php echo e(__('settings.push_notifications')); ?></label>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-primary">
                            <i class="fa-solid fa-save me-2"></i><?php echo e(__('settings.save')); ?>

                        </button>
                    </form>
                </div>
            </div>
        </div>

        <div class="col-md-6">
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-transparent border-0 pt-4">
                    <h5 class="fw-semibold mb-0"><?php echo e(__('settings.information')); ?></h5>
                </div>
                <div class="card-body">
                    <p><i class="fa-regular fa-circle-check text-success me-2"></i> <?php echo e(__('settings.auto_save')); ?></p>
                    <p><i class="fa-regular fa-clock me-2"></i> <?php echo e(__('settings.last_update')); ?>: <?php echo e(now()->format('d/m/Y H:i')); ?></p>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    // ===== GESTION DU THEME =====
    const themeRadios = document.querySelectorAll('input[name="theme"]');
    const htmlElement = document.documentElement;
    const bodyElement = document.body;
    
    // Appliquer le thème sauvegardé au chargement
    const savedTheme = localStorage.getItem('theme') || '<?php echo e($settings["theme"]); ?>';
    applyTheme(savedTheme);
    
    // Mettre à jour les radios si nécessaire
    if (savedTheme) {
        document.querySelector(`input[name="theme"][value="${savedTheme}"]`).checked = true;
    }
    
    // Changer le thème quand on clique sur les radios
    themeRadios.forEach(radio => {
        radio.addEventListener('change', function() {
            if (this.checked) {
                applyTheme(this.value);
                // Sauvegarder dans localStorage
                localStorage.setItem('theme', this.value);
            }
        });
    });
    
    function applyTheme(theme) {
        if (theme === 'dark') {
            bodyElement.classList.add('dark-mode');
            htmlElement.setAttribute('data-bs-theme', 'dark');
            // Sauvegarder la préférence pour l'utiliser dans toutes les pages
            localStorage.setItem('theme', 'dark');
        } else {
            bodyElement.classList.remove('dark-mode');
            htmlElement.setAttribute('data-bs-theme', 'light');
            localStorage.setItem('theme', 'light');
        }
    }
    
    // ===== GESTION DE LA LANGUE =====
    const langRadios = document.querySelectorAll('input[name="language"]');
    
    // Appliquer la langue sauvegardée
    const savedLang = localStorage.getItem('language') || '<?php echo e($settings["language"]); ?>';
    applyLanguage(savedLang);
    
    // Mettre à jour les radios
    document.querySelector(`input[name="language"][value="${savedLang}"]`).checked = true;
    
    langRadios.forEach(radio => {
        radio.addEventListener('change', function() {
            if (this.checked) {
                applyLanguage(this.value);
                localStorage.setItem('language', this.value);
                
                // Recharger la page pour appliquer les traductions du backend
                window.location.reload();
            }
        });
    });
    
    function applyLanguage(lang) {
        // Mettre à jour l'attribut lang de la balise html
        htmlElement.setAttribute('lang', lang);
        
        // Changer la direction du texte si nécessaire
        if (lang === 'ar') {
            htmlElement.setAttribute('dir', 'rtl');
        } else {
            htmlElement.setAttribute('dir', 'ltr');
        }
    }
    
    // ===== GESTION DU FORMULAIRE =====
    const form = document.getElementById('settingsForm');
    
    form.addEventListener('submit', function(e) {
        // Sauvegarder dans localStorage avant l'envoi
        const formData = new FormData(form);
        localStorage.setItem('theme', formData.get('theme'));
        localStorage.setItem('language', formData.get('language'));
        
        // Le formulaire continue son envoi normal
    });
    
    // ===== MISE À JOUR IMMÉDIATE DES NOTIFICATIONS =====
    const notificationSwitches = document.querySelectorAll('.form-check-input[type="checkbox"]');
    notificationSwitches.forEach(switch_ => {
        switch_.addEventListener('change', function() {
            console.log('Notification mise à jour:', this.id, this.checked);
        });
    });
});
</script>

<style>
/* Styles pour le dark mode - appliqués à tout le site via le body.dark-mode */
body.dark-mode {
    background-color: #1a1a1a !important;
    color: #ffffff !important;
}

body.dark-mode .navbar,
body.dark-mode .sidebar,
body.dark-mode .card,
body.dark-mode .modal-content,
body.dark-mode .dropdown-menu {
    background-color: #2d2d2d !important;
    border-color: #404040 !important;
}

body.dark-mode .card-header,
body.dark-mode .modal-header,
body.dark-mode .modal-footer {
    background-color: #2d2d2d !important;
    border-bottom-color: #404040 !important;
    border-top-color: #404040 !important;
}

body.dark-mode .table {
    color: #e0e0e0 !important;
}

body.dark-mode .table-light,
body.dark-mode .table thead th {
    background-color: #3d3d3d !important;
    color: #ffffff !important;
}

body.dark-mode .table-hover tbody tr:hover {
    background-color: #3a3a3a !important;
    color: #ffffff !important;
}

body.dark-mode .form-control,
body.dark-mode .form-select,
body.dark-mode .input-group-text {
    background-color: #3d3d3d !important;
    border-color: #555 !important;
    color: #ffffff !important;
}

body.dark-mode .form-check-label {
    color: #e0e0e0 !important;
}

body.dark-mode .form-check-input {
    background-color: #404040 !important;
    border-color: #555 !important;
}

body.dark-mode .btn-primary {
    background-color: #0d6efd !important;
    border-color: #0d6efd !important;
}

body.dark-mode .btn-primary:hover {
    background-color: #0b5ed7 !important;
    border-color: #0a58ca !important;
}

body.dark-mode .btn-outline-secondary {
    color: #e0e0e0 !important;
    border-color: #555 !important;
}

body.dark-mode .btn-outline-secondary:hover {
    background-color: #404040 !important;
    color: #ffffff !important;
}

body.dark-mode .text-muted {
    color: #a0a0a0 !important;
}

body.dark-mode .bg-light {
    background-color: #3d3d3d !important;
}

body.dark-mode .border {
    border-color: #404040 !important;
}

/* Animation pour les changements */
body, 
.navbar, 
.sidebar, 
.card, 
.table, 
.form-control, 
.btn {
    transition: all 0.3s ease;
}
</style>
<?php $__env->stopSection(); ?>
<?php echo $__env->make('layouts.app', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH D:\modif\projet_soutenance_l3\backend\resources\views/settings.blade.php ENDPATH**/ ?>