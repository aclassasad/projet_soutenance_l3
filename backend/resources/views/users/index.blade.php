@extends('layouts.app')

@section('title', 'Employés')

@section('content')
<div class="container mt-4">
    <h3>Liste des Employés</h3>


     <a href="{{ route('inventory') }}" class="btn btn-secondary mb-3">← Back to Employees</a>

    <!-- Bouton Ajouter -->
    <a href="{{ route('users.create') }}" class="btn btn-success mb-3">+ Ajouter un employé</a>

    @if(session('success'))
        <div class="alert alert-success">{{ session('success') }}</div>
    @endif

    <!-- Dashboard Statistiques -->
    <div class="row mb-4">
    
        <div class="col-md-3">
            <div class="card text-center">
                <div class="card-body">
                    <h6>Admins</h6>
                    <h4>{{ $stats['admins'] }}</h4>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card text-center">
                <div class="card-body">
                    <h6>Gérants</h6>
                    <h4>{{ $stats['gerants'] }}</h4>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card text-center">
                <div class="card-body">
                    <h6>Caissiers</h6>
                    <h4>{{ $stats['caissiers'] }}</h4>
                </div>
            </div>
        </div>
    </div>

    <!-- Tableau des employés -->
    <table class="table table-bordered">
        <thead>
            <tr>
                <th>ID</th>
                <th>Nom</th>
                <th>Email</th>
                <th>Rôle</th>
                <th>Statut</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            @foreach($users as $user)
            <tr>
                <td>{{ $user->id }}</td>
                <td>{{ $user->name }}</td>
                <td>{{ $user->email }}</td>
                <td>
                    <span class="badge 
                        @if($user->role === 'admin') bg-danger 
                        @elseif($user->role === 'gerant') bg-warning 
                        @else bg-info 
                        @endif">
                        {{ strtoupper($user->role) }}
                    </span>
                </td>
                <td>{{ $user->statut ? 'Actif' : 'En congé' }}</td>
                <td>
                    <div class="btn-group" role="group">
                        <a href="{{ route('users.show', $user) }}" class="btn btn-sm btn-outline-info" title="Voir">
                            <i class="bi bi-eye"></i>
                        </a>
                        <a href="{{ route('users.edit', $user) }}" class="btn btn-sm btn-outline-primary" title="Modifier">
                            <i class="bi bi-pencil"></i>
                        </a>
                        <form action="{{ route('users.destroy', $user) }}" method="POST" class="d-inline">
                            @csrf
                            @method('DELETE')
                            <button class="btn btn-sm btn-outline-danger" title="Supprimer" onclick="return confirm('Supprimer cet employé ?')">
                                <i class="bi bi-trash"></i>
                            </button>
                        </form>
                    </div>
                </td>
            </tr>
            @endforeach
        </tbody>
    </table>

    <!-- Graphique employés par rôle -->
    
</div>

<script>
  new Chart(document.getElementById('employeeRoles'), {
    type: 'pie',
    data: {
      labels: {!! json_encode($roles->pluck('role')->toArray()) !!},
      datasets: [{
        data: {!! json_encode($roles->pluck('count')->toArray()) !!},
        backgroundColor: ['#dc3545','#ffc107','#0d6efd'] // Admin, Gerant, Caissier
      }]
    }
  });
</script>
@endsection