@extends('layouts.app')

@section('title', 'Dashboard')

@section('content')
<div class="mx-5">
<h2 class="card-body fw-bold">Dashboard</h2>
<h6 class="text-muted">Welcome back! Here's what's happening today.</h6>


<!-- Metrics Cards -->
<div class="row my-4 ">
  <div class="col-md-3  "><div class="card text-center"><div class="card-body d-flex">
    <div class="flex-fill me-3 cold-md-6">
       <h6 >Total Revenue</h6>
       <h4>${{ $stats['total_revenu'] }}</h4>
       <i class="fa-solid fa-dollar-sign text-success"></i>
    </div>
    
  </div>
  </div>
  
  </div>

  <div class="col-md-3"><div class="card text-center"><div class="card-body">
    <h6>Products in Stock </h6>
    <h4>{{ $stats['total_produits_stock'] }}</h4>
    <i class="fa-solid fa-box text-primary"></i>  <!-- Icône modifiée -->
  </div></div></div>

  <div class="col-md-3"><div class="card text-center"><div class="card-body">
    <h6>Active Employees</h6>
    <h4>{{ $stats['employes_actifs'] }}</h4>
    <i class="fa-solid fa-users text-info"></i>  <!-- Icône modifiée -->
  </div></div></div>

  <div class="col-md-3"><div class="card text-center"><div class="card-body">
    <h6>Categories</h6>
    <h4>{{ $stats['nombre_categories'] }}</h4>
    <i class="fa-solid fa-shield-halved text-warning"></i>  <!-- Icône modifiée -->
  </div></div></div>
</div>

<!-- Graphs -->
<div class="d-flex">
  <div class="flex-fill me-3 card"><canvas id="weeklySales"></canvas></div>
  <div class="col-md-6 me-3 card"><canvas id="storeTraffic"></canvas></div>
</div>

<!-- Transactions récentes -->
<div class="row mt-4 ">
  <div class="col-md-12 card">
    <h6>Recent Transactions</h6>
    <ul class="list-group">
      @foreach($stats['transactions_recentes'] as $t)
        <li class="list-group-item">
          Vente #{{ $t['id'] }} — Total: ${{ $t['total'] }}
          <small class="text-muted">({{ $t['created_at'] }})</small>
        </li>
      @endforeach
    </ul>
  </div>
</div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
  // Weekly Sales Chart (7 jours fixes)
  new Chart(document.getElementById('weeklySales'), {
    type: 'line',
    data: {
      labels: @json($stats['weekly_sales_labels']),
      datasets: [{
        label: 'Weekly Sales',
        data: @json($stats['weekly_sales_data']),
        borderColor: 'blue',
        backgroundColor: 'rgba(54, 162, 235, 0.2)',
        fill: true,
        tension: 0.3
      }]
    },
    options: {
      responsive: true,
      plugins: {
        title: { display: true, text: 'Weekly Sales (7 jours)' }
      }
    }
  });

  // Store Traffic Chart
new Chart(document.getElementById('storeTraffic'), {
    type: 'bar',
    data: {
        labels: {!! json_encode(array_column($stats['store_traffic'], 'hour')) !!},
        datasets: [{
            label: 'Store Traffic',
            data: {!! json_encode(array_column($stats['store_traffic'], 'value')) !!},
            backgroundColor: '#4CC9F0'
        }]
    },
    options: {
        responsive: true,
        scales: {
            y: { beginAtZero: true }
        },
        datasets: {
            bar: {
                barPercentage: 0.4,       // ← barre plus fine
                categoryPercentage: 0.6   // ← espace entre les barres
            }
        }
    }
  });
</script>
@endsection