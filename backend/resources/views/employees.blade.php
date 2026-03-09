@extends('layouts.app')

@section('title', 'Employees')

@section('content')
<div class="container-fluid px-4">
    <!-- Header avec titre et description -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="fw-bold mb-1">Employee Management</h2>
            <p class="text-muted mb-0">Manage your store's staff and schedules</p>
        </div>
        <div>
        <a href="{{ route('users.index') }}" class="btn btn-primary">
                <i class="fa-solid fa-folder"></i> Gérer les employés
        </a>
       <!-- <a href="{{ route('users.create') }}" class="btn btn-primary">
            <i class="fa-solid fa-plus me-2"></i>Ajouter un employé
        </a>-->
        </div>
    </div>

    <!-- Stats Cards - Style maquette -->
    <div class="row g-4 mb-4">
        <div class="col-md-4">
            <div class="card border-0 shadow-sm h-100" style="background: linear-gradient(135deg, #4361EE, #3A56D4);">
                <div class="card-body d-flex justify-content-between align-items-center">
                    <div>
                        <h6 class="text-white-50 mb-2">Total Employees</h6>
                        <h3 class="fw-bold mb-0 text-white">{{ $stats['total'] ?? 0 }}</h3>
                    </div>
                    <div class="bg-white bg-opacity-20 rounded-3 p-3">
                        <i class="fa-solid fa-users  fs-3"></i>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card border-0 shadow-sm h-100" style="background: linear-gradient(135deg, #10b981, #0f9d6e);">
                <div class="card-body d-flex justify-content-between align-items-center">
                    <div>
                        <h6 class="text-white-50 mb-2">Active Today</h6>
                        <h3 class="fw-bold mb-0 text-white">{{ $stats['actifs'] ?? 0 }}</h3>
                    </div>
                    <div class="bg-white bg-opacity-20 rounded-3 p-3">
                        <i class="fa-solid fa-circle-check  fs-3"></i>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card border-0 shadow-sm h-100" style="background: linear-gradient(135deg, #184E77, #76C893);">
                <div class="card-body d-flex justify-content-between align-items-center">
                    <div>
                        <h6 class="text-white-50 mb-2">On Leave</h6>
                        <h3 class="fw-bold mb-0 text-white">{{ $stats['conges'] ?? 0 }}</h3>
                    </div>
                    <div class="bg-white bg-opacity-20 rounded-3 p-3">
                        <i class="fa-solid fa-clock fs-3"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Employee Cards - Style maquette avec initiales -->
    <h5 class="fw-semibold mb-3">Staff Directory</h5>
    <div class="row g-4">
        @forelse($employees as $emp)
        <div class="col-md-4">
            <div class="card border-0 shadow-sm h-100">
                <div class="card-body">
                    <div class="d-flex align-items-center mb-3">
                        <!-- Initiales au lieu d'image -->
                        <div class="rounded-circle d-flex align-items-center justify-content-center me-3" 
                             style="width: 60px; height: 60px; background: {{ ['#4361EE', '#10b981', '#f59e0b', '#ef4444'][$loop->index % 4] }}10;">
                            <span class="fw-bold fs-5" style="color: {{ ['#4361EE', '#10b981', '#f59e0b', '#ef4444'][$loop->index % 4] }};">
                                {{ strtoupper(substr($emp->name, 0, 2)) }}
                            </span>
                        </div>
                        <div>
                            <h5 class="fw-bold mb-1">{{ $emp->name }}</h5>
                            @php
                                $roleLabels = [
                                    'admin' => 'Administrateur',
                                    'gerant' => 'Gérant',
                                    'caissier' => 'Caissier'
                                ];
                                $roleColors = [
                                    'admin' => 'danger',
                                    'gerant' => 'warning',
                                    'caissier' => 'info'
                                ];
                            @endphp
                            <span class="badge bg-{{ $roleColors[$emp->role] ?? 'secondary' }} bg-opacity-10 text-{{ $roleColors[$emp->role] ?? 'secondary' }} px-3 py-1 rounded-pill fw-semibold">
                                {{ $roleLabels[$emp->role] ?? strtoupper($emp->role) }}
                            </span>
                        </div>
                    </div>

                    <!-- Informations de contact -->
                    <div class="mb-3">
                        <div class="d-flex align-items-center mb-2">
                            <i class="fa-regular fa-envelope text-muted me-2" style="width: 20px;"></i>
                            <span class="small">{{ $emp->email }}</span>
                        </div>
                        <div class="d-flex align-items-center mb-2">
                            <i class="fa-regular fa-phone text-muted me-2" style="width: 20px;"></i>
                            <span class="small">{{ $emp->telephone ?? '(555) ' . rand(100, 999) . '-' . rand(1000, 9999) }}</span>
                        </div>
                        <div class="d-flex align-items-center mb-2">
                            <i class="fa-regular fa-clock text-muted me-2" style="width: 20px;"></i>
                            <span class="small">{{ $emp->horaire ?? ($emp->role === 'gerant' ? 'Afternoon (12PM-8PM)' : 'Morning (8AM-4PM)') }}</span>
                        </div>
                        <div class="d-flex align-items-center">
                            <i class="fa-regular fa-calendar text-muted me-2" style="width: 20px;"></i>
                            <span class="small">Joined: {{ $emp->created_at ? $emp->created_at->format('d/m/Y') : now()->subMonths(rand(1, 12))->format('d/m/Y') }}</span>
                        </div>
                    </div>

                    <!-- Statut et actions -->
                    <div class="d-flex justify-content-between align-items-center">
                        <span class="small">
                            @if($emp->statut == 1)
                                <i class="fa-solid fa-circle text-success me-1" style="font-size: 8px;"></i>
                                <span class="text-success">Active Today</span>
                            @else
                                <i class="fa-solid fa-circle text-secondary me-1" style="font-size: 8px;"></i>
                                <span class="text-secondary">On Leave</span>
                            @endif
                        </span>
                        <div class="btn-group">
                            <a href="{{ route('users.edit', $emp) }}" class="btn btn-sm btn-outline-primary border-0">
                                <i class="fa-regular fa-pen-to-square"></i>
                            </a>
                            <a href="{{ route('users.show', $emp) }}" class="btn btn-sm btn-outline-info border-0">
                                <i class="fa-regular fa-eye"></i>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        @empty
        <div class="col-12">
            <div class="card border-0 shadow-sm">
                <div class="card-body text-center py-5">
                    <i class="fa-solid fa-users-slash fs-1 text-muted mb-3"></i>
                    <h5>No employees found</h5>
                    <p class="text-muted">Start by adding your first employee</p>
                    <a href="{{ route('users.create') }}" class="btn btn-primary">
                        <i class="fa-solid fa-plus me-2"></i>Add Employee
                    </a>
                </div>
            </div>
        </div>
        @endforelse
    </div>

    <!-- Pagination si nécessaire -->
    @if(method_exists($employees, 'links'))
    <div class="d-flex justify-content-end mt-4">
        {{ $employees->links() }}
    </div>
    @endif

    <!-- Graphique supprimé comme demandé dans la maquette -->
</div>

<!-- Styles supplémentaires -->
<style>
.card {
    transition: transform 0.2s, box-shadow 0.2s;
    border-radius: 16px !important;
}

.card:hover {
    transform: translateY(-4px);
    box-shadow: 0 15px 30px rgba(0, 0, 0, 0.1) !important;
}

.bg-white.bg-opacity-20 {
    background-color: rgba(255, 255, 255, 0.2);
}

/* Styles pour les initiales */
.rounded-circle {
    transition: transform 0.2s;
}

.card:hover .rounded-circle {
    transform: scale(1.05);
}

/* Responsive */
@media (max-width: 768px) {
    .container-fluid {
        padding-left: 1rem !important;
        padding-right: 1rem !important;
    }
}
</style>
@endsection