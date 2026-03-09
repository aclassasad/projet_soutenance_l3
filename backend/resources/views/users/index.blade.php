@extends('layouts.app')

@section('title', 'Employés')

@section('content')
<div class="container-fluid px-4">
    <!-- Header avec navigation -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="fw-bold mb-1">Gestion des Employés</h2>
            <p class="text-muted mb-0">Gérez votre équipe et leurs horaires</p>
        </div>
        <div>
            <a href="{{ route('employees') }}" class="btn btn-outline-secondary me-2">
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
                        <h3 class="fw-bold mb-0">{{ $stats['admins'] ?? 0 }}</h3>
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
                        <h3 class="fw-bold mb-0">{{ $stats['gerants'] ?? 0 }}</h3>
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
                        <h3 class="fw-bold mb-0">{{ $stats['caissiers'] ?? 0 }}</h3>
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
                        @forelse($users as $user)
                        <tr>
                            <td class="px-4 py-3 fw-semibold">{{ $user->id }}</td>
                            <td class="px-4 py-3">
                                <div class="d-flex align-items-center">
                                    <div class="rounded-circle bg-light d-flex align-items-center justify-content-center me-3" style="width: 40px; height: 40px;">
                                        <i class="fa-solid fa-user text-secondary"></i>
                                    </div>
                                    <span class="fw-medium">{{ $user->name }}</span>
                                </div>
                            </td>
                            <td class="px-4 py-3">{{ $user->email }}</td>
                            <td class="px-4 py-3">
                                @php
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
                                @endphp
                                <span class="badge bg-{{ $color }} bg-opacity-10 text-{{ $color }} px-3 py-2 rounded-pill fw-semibold">
                                    {{ $roleLabels[$user->role] ?? strtoupper($user->role) }}
                                </span>
                            </td>
                            <td class="px-4 py-3">
                                @if($user->statut)
                                    <span class="badge bg-success bg-opacity-10 text-success px-3 py-2 rounded-pill fw-semibold">
                                        <i class="fa-solid fa-circle me-1" style="font-size: 8px;"></i> Actif
                                    </span>
                                @else
                                    <span class="badge bg-secondary bg-opacity-10 text-secondary px-3 py-2 rounded-pill fw-semibold">
                                        <i class="fa-solid fa-circle me-1" style="font-size: 8px;"></i> En congé
                                    </span>
                                @endif
                            </td>
                            <td class="px-4 py-3">
                                <div class="d-flex gap-2">
                                    <a href="{{ route('users.show', $user) }}" class="btn btn-sm btn-outline-info border-0" title="Voir">
                                        <i class="fa-regular fa-eye"></i>
                                    </a>
                                    <a href="{{ route('users.edit', $user) }}" class="btn btn-sm btn-outline-primary border-0" title="Modifier">
                                        <i class="fa-regular fa-pen-to-square"></i>
                                    </a>
                                    <button type="button" class="btn btn-sm btn-outline-danger border-0" title="Supprimer" onclick="openDeleteModal({{ $user->id }}, '{{ $user->name }}')">
                                        <i class="fa-regular fa-trash-can"></i>
                                    </button>
                                </div>
                            </td>
                        </tr>
                        @empty
                        <tr>
                            <td colspan="6" class="text-center py-5 text-muted">
                                <i class="fa-solid fa-users-slash fs-1 d-block mb-3"></i>
                                Aucun employé trouvé
                            </td>
                        </tr>
                        @endforelse
                    </tbody>
                </table>
            </div>
        </div>
        @if(method_exists($users, 'links'))
        <div class="card-footer bg-transparent border-0 pt-3 pb-4 px-4">
            {{ $users->links() }}
        </div>
        @endif
    </div>
</div>

<!-- Modal Ajouter -->
<div class="modal fade" id="addEmployeeModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title">Ajouter un employé</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form action="{{ route('users.store') }}" method="POST" id="addEmployeeForm">
                @csrf
                <div class="modal-body">
                    <div class="mb-3">
                        <label>Nom</label>
                        <input type="text" name="name" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label>Email</label>
                        <input type="email" name="email" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label>Mot de passe</label>
                        <input type="password" name="password" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label>Rôle</label>
                        <select name="role" class="form-select" required>
                            <option value="admin">Admin</option>
                            <option value="gerant">Gérant</option>
                            <option value="caissier">Caissier</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label>Statut</label>
                        <select name="statut" class="form-select">
                            <option value="1">Actif</option>
                            <option value="0">En congé</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                    <button type="submit" class="btn btn-primary" id="submitBtn">Créer</button>
                </div>
            </form>
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
                    @csrf
                    @method('DELETE')
                    <button type="submit" class="btn btn-danger">Supprimer</button>
                </form>
            </div>
        </div>
    </div>
</div>
@endsection

@push('styles')
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css">
@endpush

@push('scripts')
<script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>
<script>
    // Configuration de toastr
    toastr.options = {
        "closeButton": true,
        "progressBar": true,
        "positionClass": "toast-top-right",
        "showDuration": "300",
        "hideDuration": "1000",
        "timeOut": "5000",
        "extendedTimeOut": "1000"
    };

    // Fonction pour ouvrir le modal de suppression
    function openDeleteModal(userId, userName) {
        document.getElementById('deleteEmployeeName').textContent = userName;
        document.getElementById('deleteForm').action = '/users/' + userId;
        new bootstrap.Modal(document.getElementById('deleteModal')).show();
    }

    // Script pour le formulaire d'ajout
    document.addEventListener('DOMContentLoaded', function() {
        const form = document.getElementById('addEmployeeForm');
        if (!form) return;

        form.addEventListener('submit', function(e) {
            e.preventDefault();
            
            const submitBtn = document.getElementById('submitBtn');
            const originalText = submitBtn.innerHTML;
            
            // Désactiver le bouton
            submitBtn.disabled = true;
            submitBtn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Ajout...';
            
            const formData = new FormData(form);
            
            fetch(form.action, {
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
                    // Fermer le modal
                    const modal = bootstrap.Modal.getInstance(document.getElementById('addEmployeeModal'));
                    if (modal) {
                        modal.hide();
                    }
                    
                    // Réinitialiser le formulaire
                    form.reset();
                    
                    // Notification en haut à gauche
                    toastr.options.positionClass = "toast-top-left";
                    toastr.success(data.message, "Succès");
                    
                    // Recharger la page après un court délai
                    setTimeout(() => {
                        window.location.reload();
                    }, 1500);
                    
                } else {
                    toastr.error(data.message || 'Erreur lors de l\'ajout', 'Erreur');
                    submitBtn.disabled = false;
                    submitBtn.innerHTML = originalText;
                }
            })
            .catch(error => {
                console.error('Erreur:', error);
                toastr.error('Une erreur est survenue. Vérifiez la console.', 'Erreur');
                submitBtn.disabled = false;
                submitBtn.innerHTML = originalText;
            });
        });

        // Réinitialiser le formulaire à la fermeture du modal
        const modal = document.getElementById('addEmployeeModal');
        if (modal) {
            modal.addEventListener('hidden.bs.modal', function() {
                document.getElementById('addEmployeeForm').reset();
                const submitBtn = document.getElementById('submitBtn');
                if (submitBtn) {
                    submitBtn.disabled = false;
                    submitBtn.innerHTML = 'Créer';
                }
            });
        }
    });

    // Afficher la notification de succès si elle existe dans la session
    @if(session('success'))
    document.addEventListener('DOMContentLoaded', function() {
        if (typeof toastr !== 'undefined') {
            toastr.success("{{ session('success') }}", "Succès");
        }
    });
    @endif
</script>
@endpush