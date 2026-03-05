@extends('layouts.app')

@section('title', 'Employees')

@section('content')
<h5>Employee Management</h5>

<!-- Bouton Ajouter -->


<a href="{{ route('users.index') }}" class="btn btn-primary mb-3">
    👥 Gérer les employés
</a>

<!-- Stats -->
<div class="row my-4">
  <div class="col-md-3">
    <div class="card text-center">
      <div class="card-body">
        <h6>Total Employés</h6>
        <!-- ✅ admins exclus -->
        <h4>{{ $stats['total'] }}</h4>
      </div>
    </div>
  </div>
  <div class="col-md-3">
    <div class="card text-center">
      <div class="card-body">
        <h6>Active Today</h6>
        <h4>{{ $stats['actifs'] }}</h4>
      </div>
    </div>
  </div>
  <div class="col-md-3">
    <div class="card text-center">
      <div class="card-body">
        <h6>On Leave</h6>
        <h4>{{ $stats['conges'] }}</h4>
      </div>
    </div>
  </div>
</div>

<!-- Employee List -->
<div class="row">
  @foreach($employees as $emp)
    <div class="col-md-4">
      <div class="card mb-3"><div class="card-body">
        <h6>{{ $emp->name }}
          <span class="badge 
            @if($emp->role === 'admin') bg-danger 
            @elseif($emp->role === 'gerant') bg-warning 
            @else bg-info 
            @endif">
            {{ strtoupper($emp->role) }}
          </span>
        </h6>
        <p>Status: {{ $emp->statut == 1 ? 'Active' : 'On Leave' }}</p>
        <p>Email: {{ $emp->email }}</p>
      </div></div>
    </div>
  @endforeach
</div>

<!-- Employees by Role Chart -->
<div class="mt-4">
  <canvas id="employeeRoles"></canvas>
</div>

<script>
  new Chart(document.getElementById('employeeRoles'), {
    type: 'pie',
    data: {
      labels: {!! json_encode($roles->pluck('role')->toArray()) !!},
      datasets: [{
        data: {!! json_encode($roles->pluck('count')->toArray()) !!},
        backgroundColor: ['#0d6efd','#198754','#ffc107','#dc3545']
      }]
    }
  });
</script>
@endsection