<?php $__env->startSection('title', 'Employés'); ?>

<?php $__env->startSection('content'); ?>
<div class="container-fluid px-4">
    <!-- Header avec navigation -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="fw-bold mb-1">Gestion des Employés</h2>
            <p class="text-muted mb-0">Gérez votre équipe et leurs horaires</p>
        </div>
        <div>
            <a href="<?php echo e(route('employees')); ?>" class="btn btn-outline-secondary me-2">
                <i class="fa-solid fa-arrow-left"></i> Retour
            </a>
            <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addEmployeeModal">
                <i class="fa-solid fa-plus"></i> Ajouter un employé
            </button>
        </div>
    </div>

    <!-- Dashboard Statistiques -->
    <div class="row g-4 mb-4">
        <div class="col-md-4">
            <div class="card border-0 shadow-sm h-100">
                <div class="card-body d-flex justify-content-between align-items-center">
                    <div>
                        <h6 class="text-muted mb-2">Administrateurs</h6>
                        <h3 class="fw-bold mb-0"><?php echo e($stats['admins'] ?? 0); ?></h3>
                    </div>
                    <div class="bg-danger bg-opacity-10 rounded-3 p-3">
                        <i class="fa-solid fa-crown text-danger fs-3"></i>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card border-0 shadow-sm h-100">
                <div class="card-body d-flex justify-content-between align-items-center">
                    <div>
                        <h6 class="text-muted mb-2">Gérants</h6>
                        <h3 class="fw-bold mb-0"><?php echo e($stats['gerants'] ?? 0); ?></h3>
                    </div>
                    <div class="bg-warning bg-opacity-10 rounded-3 p-3">
                        <i class="fa-solid fa-chart-line text-warning fs-3"></i>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card border-0 shadow-sm h-100">
                <div class="card-body d-flex justify-content-between align-items-center">
                    <div>
                        <h6 class="text-muted mb-2">Caissiers</h6>
                        <h3 class="fw-bold mb-0"><?php echo e($stats['caissiers'] ?? 0); ?></h3>
                    </div>
                    <div class="bg-info bg-opacity-10 rounded-3 p-3">
                        <i class="fa-solid fa-cash-register text-info fs-3"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Tableau des employés -->
    <div class="card border-0 shadow-sm">
        <div class="card-header bg-transparent border-0 pt-4 px-4">
            <h5 class="fw-semibold mb-0">Liste des employés</h5>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th class="px-4 py-3 text-muted fw-semibold">ID</th>
                            <th class="px-4 py-3 text-muted fw-semibold">NOM</th>
                            <th class="px-4 py-3 text-muted fw-semibold">EMAIL</th>
                            <th class="px-4 py-3 text-muted fw-semibold">RÔLE</th>
                            <th class="px-4 py-3 text-muted fw-semibold">STATUT</th>
                            <th class="px-4 py-3 text-muted fw-semibold">ACTIONS</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php $__empty_1 = true; $__currentLoopData = $users; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $user): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); $__empty_1 = false; ?>
                        <tr>
                            <td class="px-4 py-3 fw-semibold"><?php echo e($user->id); ?></td>
                            <td class="px-4 py-3">
                                <div class="d-flex align-items-center">
                                    <div class="rounded-circle bg-light d-flex align-items-center justify-content-center me-3" style="width: 40px; height: 40px;">
                                        <i class="fa-solid fa-user text-secondary"></i>
                                    </div>
                                    <span class="fw-medium"><?php echo e($user->name); ?></span>
                                </div>
                            </td>
                            <td class="px-4 py-3"><?php echo e($user->email); ?></td>
                            <td class="px-4 py-3">
                                <?php
                                    $roleColors = [
                                        'admin' => 'danger',
                                        'gerant' => 'warning',
                                        'caissier' => 'info'
                                    ];
                                    $roleLabels = [
                                        'admin' => 'ADMIN',
                                        'gerant' => 'GÉRANT',
                                        'caissier' => 'CAISSIER'
                                    ];
                                    $color = $roleColors[$user->role] ?? 'secondary';
                                ?>
                                <span class="badge bg-<?php echo e($color); ?> bg-opacity-10 text-<?php echo e($color); ?> px-3 py-2 rounded-pill fw-semibold">
                                    <?php echo e($roleLabels[$user->role] ?? strtoupper($user->role)); ?>

                                </span>
                            </td>
                            <td class="px-4 py-3">
                                <?php if($user->statut): ?>
                                    <span class="badge bg-success bg-opacity-10 text-success px-3 py-2 rounded-pill fw-semibold">
                                        <i class="fa-solid fa-circle me-1" style="font-size: 8px;"></i> Actif
                                    </span>
                                <?php else: ?>
                                    <span class="badge bg-secondary bg-opacity-10 text-secondary px-3 py-2 rounded-pill fw-semibold">
                                        <i class="fa-solid fa-circle me-1" style="font-size: 8px;"></i> En congé
                                    </span>
                                <?php endif; ?>
                            </td>
                            <td class="px-4 py-3">
                                <div class="d-flex gap-2">
                                    <a href="<?php echo e(route('users.show', $user)); ?>" class="btn btn-sm btn-outline-info border-0" title="Voir">
                                        <i class="fa-regular fa-eye"></i>
                                    </a>
                                    <a href="<?php echo e(route('users.edit', $user)); ?>" class="btn btn-sm btn-outline-primary border-0" title="Modifier">
                                        <i class="fa-regular fa-pen-to-square"></i>
                                    </a>
                                    <button type="button" class="btn btn-sm btn-outline-danger border-0" title="Supprimer" onclick="openDeleteModal(<?php echo e($user->id); ?>, '<?php echo e($user->name); ?>')">
                                        <i class="fa-regular fa-trash-can"></i>
                                    </button>
                                </div>
                            </td>
                        </tr>
                        <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); if ($__empty_1): ?>
                        <tr>
                            <td colspan="6" class="text-center py-5 text-muted">
                                <i class="fa-solid fa-users-slash fs-1 d-block mb-3"></i>
                                Aucun employé trouvé
                            </td>
                        </tr>
                        <?php endif; ?>
                    </tbody>
                </table>
            </div>
        </div>
        <?php if(method_exists($users, 'links')): ?>
        <div class="card-footer bg-transparent border-0 pt-3 pb-4 px-4">
            <?php echo e($users->links()); ?>

        </div>
        <?php endif; ?>
    </div>
</div>

<!-- Modal Ajouter -->
<div class="modal fade" id="addEmployeeModal" tabindex="-1" aria-labelledby="addEmployeeModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title" id="addEmployeeModalLabel">
                    <i class="fa-solid fa-user-plus me-2"></i>Ajouter un employé
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="<?php echo e(route('users.store')); ?>" method="POST" id="addEmployeeForm">
                <?php echo csrf_field(); ?>
                <div class="modal-body" style="max-height: 70vh; overflow-y: auto;">
                    <!-- Nom -->
                    <div class="mb-3">
                        <label for="modal_name" class="form-label fw-semibold">Nom</label>
                        <input type="text" name="name" id="modal_name" class="form-control" required>
                    </div>

                    <!-- Email avec validation -->
                    <div class="mb-3">
                        <label for="modal_email" class="form-label fw-semibold">Email</label>
                        <input type="email" name="email" id="modal_email" class="form-control" required>
                        <div id="modalEmailFeedback" class="text-danger mt-1 small"></div>
                    </div>

                    <!-- Mot de passe avec conditions -->
                    <div class="mb-3">
                        <label for="modal_password" class="form-label fw-semibold">Mot de passe</label>
                        <div class="input-group">
                            <input type="password" name="password" id="modal_password" class="form-control" required>
                            <button type="button" class="btn btn-outline-secondary" id="modalTogglePassword">
                                <i class="bi bi-eye"></i>
                            </button>
                        </div>

                        <!-- Barre de progression -->
                        <div class="progress mt-2" style="height: 20px;">
                            <div id="modalPasswordStrength" class="progress-bar" role="progressbar" style="width: 0%">
                                Faible
                            </div>
                        </div>

                        <!-- Conditions -->
                        <ul class="mt-2 small">
                            <li id="modalLength" class="text-danger">❌ Au moins 8 caractères</li>
                            <li id="modalUppercase" class="text-danger">❌ Au moins une majuscule</li>
                            <li id="modalLowercase" class="text-danger">❌ Au moins une minuscule</li>
                            <li id="modalNumber" class="text-danger">❌ Au moins un chiffre</li>
                            <li id="modalSpecial" class="text-danger">❌ Au moins un caractère spécial (@$!%*?&)</li>
                        </ul>
                    </div>

                    <!-- Confirmation mot de passe -->
                    <div class="mb-3">
                        <label for="modal_password_confirmation" class="form-label fw-semibold">Confirmer le mot de passe</label>
                        <div class="input-group">
                            <input type="password" name="password_confirmation" id="modal_password_confirmation" class="form-control" required>
                            <button type="button" class="btn btn-outline-secondary" id="modalToggleConfirm">
                                <i class="bi bi-eye"></i>
                            </button>
                        </div>
                        <div id="modalConfirmFeedback" class="text-danger mt-1 small"></div>
                    </div>

                    <!-- Rôle -->
                    <div class="mb-3">
                        <label for="modal_role" class="form-label fw-semibold">Rôle</label>
                        <select name="role" id="modal_role" class="form-select" required>
                            <option value="admin">Admin</option>
                            <option value="gerant">Gérant</option>
                            <option value="caissier">Caissier</option>
                        </select>
                    </div>

                    <!-- Statut -->
                    <div class="mb-3">
                        <label for="modal_statut" class="form-label fw-semibold">Statut</label>
                        <select name="statut" id="modal_statut" class="form-select">
                            <option value="1">Actif</option>
                            <option value="0">En congé</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                    <button type="submit" class="btn btn-primary" id="modalSubmitBtn">
                        <i class="fa-solid fa-save me-2"></i>Créer
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal Confirmation Succès Ajout -->
<div class="modal fade" id="successModal" tabindex="-1" data-bs-backdrop="static" data-bs-keyboard="false">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-success text-white">
                <h5 class="modal-title">
                    <i class="fa-solid fa-circle-check me-2"></i>Succès
                </h5>
            </div>
            <div class="modal-body text-center py-4">
                <i class="fa-solid fa-check-circle text-success fs-1 mb-3"></i>
                <h4 id="successMessage" class="mb-0">Employé ajouté avec succès !</h4>
            </div>
            <div class="modal-footer justify-content-center border-0 pt-0 pb-4">
                <button type="button" class="btn btn-success px-5" id="successModalOk" data-bs-dismiss="modal">OK</button>
            </div>
        </div>
    </div>
</div>

<!-- Modal Confirmation Suppression -->
<div class="modal fade" id="deleteModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title">Confirmer la suppression</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p>Êtes-vous sûr de vouloir supprimer l'employé <strong id="deleteEmployeeName"></strong> ?</p>
                <p class="text-danger">Cette action est irréversible.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                <form action="" method="POST" id="deleteForm">
                    <?php echo csrf_field(); ?>
                    <?php echo method_field('DELETE'); ?>
                    <button type="submit" class="btn btn-danger">Supprimer</button>
                </form>
            </div>
        </div>
    </div>
</div>
<?php $__env->stopSection(); ?>

<?php $__env->startPush('styles'); ?>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<style>
    .modal-body {
        max-height: 70vh;
        overflow-y: auto;
        padding-right: 15px;
    }
    
    /* Style pour la barre de progression */
    .progress {
        border-radius: 10px;
        overflow: hidden;
    }
    
    .progress-bar {
        transition: width 0.3s ease;
        font-weight: 500;
        font-size: 12px;
    }
    
    /* Style pour les messages de validation */
    .text-success {
        color: #198754 !important;
    }
    
    .text-danger {
        color: #dc3545 !important;
    }
    
    /* Style pour la modal */
    .modal-content {
        border: none;
        border-radius: 16px;
    }
    
    .modal-header {
        border-top-left-radius: 16px;
        border-top-right-radius: 16px;
    }
    
    /* Animation pour le modal de succès */
    .modal.fade .modal-dialog {
        transition: transform 0.3s ease-out;
        transform: scale(0.9);
    }
    
    .modal.show .modal-dialog {
        transform: scale(1);
    }
    
    .bg-success .btn-close {
        filter: brightness(0) invert(1);
    }
</style>
<?php $__env->stopPush(); ?>

<?php $__env->startPush('scripts'); ?>
<script>
// Fonction pour ouvrir le modal de suppression
function openDeleteModal(userId, userName) {
    document.getElementById('deleteEmployeeName').textContent = userName;
    document.getElementById('deleteForm').action = '/users/' + userId;
    new bootstrap.Modal(document.getElementById('deleteModal')).show();
}

// Script pour le formulaire d'ajout dans le modal
document.addEventListener('DOMContentLoaded', function() {
    const modalForm = document.getElementById('addEmployeeForm');
    if (!modalForm) return;

    // Éléments du formulaire modal
    const modalEmail = document.getElementById('modal_email');
    const modalEmailFeedback = document.getElementById('modalEmailFeedback');
    const modalPassword = document.getElementById('modal_password');
    const modalConfirm = document.getElementById('modal_password_confirmation');
    const modalStrengthBar = document.getElementById('modalPasswordStrength');
    const modalConfirmFeedback = document.getElementById('modalConfirmFeedback');
    const modalTogglePassword = document.getElementById('modalTogglePassword');
    const modalToggleConfirm = document.getElementById('modalToggleConfirm');
    const modalSubmitBtn = document.getElementById('modalSubmitBtn');

    // Références aux éléments de conditions
    const modalLength = document.getElementById('modalLength');
    const modalUppercase = document.getElementById('modalUppercase');
    const modalLowercase = document.getElementById('modalLowercase');
    const modalNumber = document.getElementById('modalNumber');
    const modalSpecial = document.getElementById('modalSpecial');

    // Vérification email en temps réel
    modalEmail.addEventListener('input', function() {
        const value = modalEmail.value;
        const regex = /^[^@\s]+@[^@\s]+\.[^@\s]+$/;
        if (regex.test(value)) {
            modalEmail.classList.remove('is-invalid');
            modalEmail.classList.add('is-valid');
            modalEmailFeedback.classList.remove('text-danger');
            modalEmailFeedback.classList.add('text-success');
            modalEmailFeedback.textContent = "✅ Format email valide";
        } else {
            modalEmail.classList.remove('is-valid');
            modalEmail.classList.add('is-invalid');
            modalEmailFeedback.classList.remove('text-success');
            modalEmailFeedback.classList.add('text-danger');
            modalEmailFeedback.textContent = "❌ Format email invalide";
        }
    });

    // Afficher/masquer mot de passe
    if (modalTogglePassword) {
        modalTogglePassword.addEventListener('click', function() {
            const type = modalPassword.getAttribute('type') === 'password' ? 'text' : 'password';
            modalPassword.setAttribute('type', type);
            this.innerHTML = type === 'password' ? '<i class="bi bi-eye"></i>' : '<i class="bi bi-eye-slash"></i>';
        });
    }

    // Afficher/masquer confirmation
    if (modalToggleConfirm) {
        modalToggleConfirm.addEventListener('click', function() {
            const type = modalConfirm.getAttribute('type') === 'password' ? 'text' : 'password';
            modalConfirm.setAttribute('type', type);
            this.innerHTML = type === 'password' ? '<i class="bi bi-eye"></i>' : '<i class="bi bi-eye-slash"></i>';
        });
    }

    // Vérification force du mot de passe
    modalPassword.addEventListener('input', function() {
        const value = modalPassword.value;
        let strength = 0;

        // Longueur
        if (value.length >= 8) {
            modalLength.classList.remove('text-danger');
            modalLength.classList.add('text-success');
            modalLength.innerHTML = "✅ Au moins 8 caractères";
            strength++;
        } else {
            modalLength.classList.remove('text-success');
            modalLength.classList.add('text-danger');
            modalLength.innerHTML = "❌ Au moins 8 caractères";
        }

        // Majuscule
        if (/[A-Z]/.test(value)) {
            modalUppercase.classList.remove('text-danger');
            modalUppercase.classList.add('text-success');
            modalUppercase.innerHTML = "✅ Au moins une majuscule";
            strength++;
        } else {
            modalUppercase.classList.remove('text-success');
            modalUppercase.classList.add('text-danger');
            modalUppercase.innerHTML = "❌ Au moins une majuscule";
        }

        // Minuscule
        if (/[a-z]/.test(value)) {
            modalLowercase.classList.remove('text-danger');
            modalLowercase.classList.add('text-success');
            modalLowercase.innerHTML = "✅ Au moins une minuscule";
            strength++;
        } else {
            modalLowercase.classList.remove('text-success');
            modalLowercase.classList.add('text-danger');
            modalLowercase.innerHTML = "❌ Au moins une minuscule";
        }

        // Chiffre
        if (/\d/.test(value)) {
            modalNumber.classList.remove('text-danger');
            modalNumber.classList.add('text-success');
            modalNumber.innerHTML = "✅ Au moins un chiffre";
            strength++;
        } else {
            modalNumber.classList.remove('text-success');
            modalNumber.classList.add('text-danger');
            modalNumber.innerHTML = "❌ Au moins un chiffre";
        }

        // Caractère spécial
        if (/[@$!%*?&]/.test(value)) {
            modalSpecial.classList.remove('text-danger');
            modalSpecial.classList.add('text-success');
            modalSpecial.innerHTML = "✅ Au moins un caractère spécial (@$!%*?&)";
            strength++;
        } else {
            modalSpecial.classList.remove('text-success');
            modalSpecial.classList.add('text-danger');
            modalSpecial.innerHTML = "❌ Au moins un caractère spécial (@$!%*?&)";
        }

        // Mise à jour de la barre
        switch (strength) {
            case 0:
            case 1:
                modalStrengthBar.style.width = "25%";
                modalStrengthBar.className = "progress-bar bg-danger";
                modalStrengthBar.textContent = "Faible";
                break;
            case 2:
                modalStrengthBar.style.width = "50%";
                modalStrengthBar.className = "progress-bar bg-warning";
                modalStrengthBar.textContent = "Moyen";
                break;
            case 3:
                modalStrengthBar.style.width = "75%";
                modalStrengthBar.className = "progress-bar bg-info";
                modalStrengthBar.textContent = "Bon";
                break;
            case 4:
            case 5:
                modalStrengthBar.style.width = "100%";
                modalStrengthBar.className = "progress-bar bg-success";
                modalStrengthBar.textContent = "Fort";
                break;
        }
    });

    // Vérification confirmation mot de passe
    modalConfirm.addEventListener('input', function() {
        if (modalConfirm.value !== modalPassword.value) {
            modalConfirm.classList.add('is-invalid');
            modalConfirmFeedback.textContent = "❌ Les mots de passe ne correspondent pas";
            modalConfirmFeedback.classList.remove('text-success');
            modalConfirmFeedback.classList.add('text-danger');
        } else {
            modalConfirm.classList.remove('is-invalid');
            modalConfirm.classList.add('is-valid');
            modalConfirmFeedback.textContent = "✅ Les mots de passe correspondent";
            modalConfirmFeedback.classList.remove('text-danger');
            modalConfirmFeedback.classList.add('text-success');
        }
    });

    // Soumission du formulaire en AJAX
    modalForm.addEventListener('submit', function(e) {
        e.preventDefault();

        // Désactiver le bouton
        modalSubmitBtn.disabled = true;
        modalSubmitBtn.innerHTML = '<i class="fa-solid fa-spinner fa-spin me-2"></i>Traitement...';

        const formData = new FormData(modalForm);

        fetch(modalForm.action, {
            method: 'POST',
            body: formData,
            headers: {
                'X-Requested-With': 'XMLHttpRequest',
                'Accept': 'application/json'
            }
        })
        .then(response => {
            if (!response.ok) {
                throw new Error('Erreur réseau');
            }
            return response.json();
        })
        .then(data => {
            if (data.success) {
                // Fermer le modal d'ajout
                const addModal = bootstrap.Modal.getInstance(document.getElementById('addEmployeeModal'));
                if (addModal) {
                    addModal.hide();
                }

                // Afficher le message de succès
                document.getElementById('successMessage').textContent = data.message || 'Employé ajouté avec succès !';
                const successModal = new bootstrap.Modal(document.getElementById('successModal'));
                successModal.show();

                // Quand on clique sur OK, recharger la page
                document.getElementById('successModalOk').addEventListener('click', function() {
                    window.location.reload();
                });
                
            } else {
                alert('Erreur: ' + (data.message || 'Erreur lors de l\'ajout'));
                modalSubmitBtn.disabled = false;
                modalSubmitBtn.innerHTML = '<i class="fa-solid fa-save me-2"></i>Créer';
            }
        })
        .catch(error => {
            console.error('Erreur:', error);
            alert('Une erreur est survenue');
            modalSubmitBtn.disabled = false;
            modalSubmitBtn.innerHTML = '<i class="fa-solid fa-save me-2"></i>Créer';
        });
    });

    // Réinitialiser le formulaire à la fermeture du modal
    const modal = document.getElementById('addEmployeeModal');
    if (modal) {
        modal.addEventListener('hidden.bs.modal', function() {
            modalForm.reset();
            
            // Réinitialiser les classes de validation
            [modalEmail, modalPassword, modalConfirm].forEach(input => {
                input.classList.remove('is-valid', 'is-invalid');
            });
            
            // Réinitialiser la barre de force
            modalStrengthBar.style.width = "0%";
            modalStrengthBar.className = "progress-bar";
            modalStrengthBar.textContent = "Faible";
            
            // Réinitialiser les conditions
            const conditions = [modalLength, modalUppercase, modalLowercase, modalNumber, modalSpecial];
            conditions.forEach(cond => {
                cond.classList.remove('text-success');
                cond.classList.add('text-danger');
            });
            modalLength.innerHTML = "❌ Au moins 8 caractères";
            modalUppercase.innerHTML = "❌ Au moins une majuscule";
            modalLowercase.innerHTML = "❌ Au moins une minuscule";
            modalNumber.innerHTML = "❌ Au moins un chiffre";
            modalSpecial.innerHTML = "❌ Au moins un caractère spécial (@$!%*?&)";
            
            // Réinitialiser les feedbacks
            modalEmailFeedback.textContent = "";
            modalConfirmFeedback.textContent = "";
            
            // Réactiver le bouton
            modalSubmitBtn.disabled = false;
            modalSubmitBtn.innerHTML = '<i class="fa-solid fa-save me-2"></i>Créer';
        });
    }
});
</script>
<?php $__env->stopPush(); ?>
<?php echo $__env->make('layouts.app', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH D:\modif\projet_soutenance_l3\backend\resources\views/users/index.blade.php ENDPATH**/ ?>