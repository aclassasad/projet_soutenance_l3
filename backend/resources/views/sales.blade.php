@extends('layouts.app')

@section('title', 'Sales')

@section('content')
<h5>Sales Analytics</h5>

<!-- KPIs -->
<div class="row my-4">
  <div class="col-md-3"><div class="card text-center"><div class="card-body">
    <h6>Total Revenue</h6><h4>${{ $stats['total_revenu'] }}</h4>
  </div></div></div>
  <div class="col-md-3"><div class="card text-center"><div class="card-body">
    <h6>Total Orders</h6><h4>{{ $stats['total_commandes'] }}</h4>
  </div></div></div>
  <div class="col-md-3"><div class="card text-center"><div class="card-body">
    <h6>Avg. Order Value</h6><h4>${{ $stats['moyenne_commande'] }}</h4>
  </div></div></div>
  
</div>

<!-- Top Products -->
<h6>Top Selling Products</h6>
<table class="table table-striped">
  <thead>
    <tr>
      <th>Product</th>
      <th>Units Sold</th>
      <th>Revenue</th>
    </tr>
  </thead>
  <tbody>
    @foreach($topProducts as $prod)
      <tr>
        <td>{{ $prod->nom }}</td>
        <td>{{ $prod->lignes_vente_count }}</td>
        <td>${{ $prod->lignesVente->sum(fn($lv) => $lv->quantite * $lv->prix_unitaire) }}</td>
      </tr>
    @endforeach
  </tbody>
</table>

<!-- Revenue Trend Chart -->
<div class="mt-4">
  <h6>Revenue Trend</h6>
  <canvas id="revenueTrend"></canvas>
</div>

<!-- Sales by Category Chart -->
<div class="mt-4">
  <h6>Sales by Category</h6>
  <canvas id="salesByCategory"></canvas>
</div>

<script>
  new Chart(document.getElementById('revenueTrend'), {
    type: 'line',
    data: {
      labels: {!! json_encode($trend->pluck('mois')->toArray()) !!},
      datasets: [{
        label: 'Revenue Trend',
        data: {!! json_encode($trend->pluck('revenu')->toArray()) !!},
        borderColor: 'blue',
        fill: false
      }]
    }
  });

  new Chart(document.getElementById('salesByCategory'), {
    type: 'pie',
    data: {
labels: {!! json_encode($categories->pluck('nom')->toArray()) !!},
      datasets: [{
data: {!! json_encode($categories->pluck('revenu')->toArray()) !!},        backgroundColor: ['#0d6efd','#198754','#ffc107','#dc3545']
      }]
    }
  });
</script>
@endsection