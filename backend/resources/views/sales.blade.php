@extends('layouts.app')

@section('title', 'Sales')

@section('content')
<div class="container-fluid px-4">
    <!-- Header -->
    <div class="mb-4">
        <h2 class="fw-bold mb-1">Sales Analytics</h2>
        <p class="text-muted">Track your store's sales performance</p>
    </div>

    <!-- KPIs - Style maquette -->
    <div class="row g-4 mb-4">
        <div class="col-md-3">
            <div class="card border-0 shadow-sm h-100">
                <div class="card-body d-flex justify-content-between align-items-center">
                    <div>
                        <h6 class="text-muted mb-2">Total Revenue</h6>
                        <h3 class="fw-bold mb-1">${{ number_format($stats['total_revenu'] ?? 297000, 0) }}</h3>
                        <span class="text-success small">+15.3%</span>
                    </div>
                    <div class="bg-primary bg-opacity-10 rounded-3 p-3">
                        <i class="fa-solid fa-dollar-sign text-primary fs-3"></i>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card border-0 shadow-sm h-100">
                <div class="card-body d-flex justify-content-between align-items-center">
                    <div>
                        <h6 class="text-muted mb-2">Total Orders</h6>
                        <h3 class="fw-bold mb-1">{{ number_format($stats['total_commandes'] ?? 2220, 0) }}</h3>
                        <span class="text-success small">+8.2%</span>
                    </div>
                    <div class="bg-info bg-opacity-10 rounded-3 p-3">
                        <i class="fa-solid fa-cart-shopping text-info fs-3"></i>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card border-0 shadow-sm h-100">
                <div class="card-body d-flex justify-content-between align-items-center">
                    <div>
                        <h6 class="text-muted mb-2">Avg. Order Value</h6>
                        <h3 class="fw-bold mb-1">${{ number_format($stats['moyenne_commande'] ?? 133.78, 2) }}</h3>
                        <span class="text-success small">+6.5%</span>
                    </div>
                    <div class="bg-success bg-opacity-10 rounded-3 p-3">
                        <i class="fa-solid fa-receipt text-success fs-3"></i>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card border-0 shadow-sm h-100">
                <div class="card-body d-flex justify-content-between align-items-center">
                    <div>
                        <h6 class="text-muted mb-2">Unique Customers</h6>
                        <h3 class="fw-bold mb-1">{{ number_format($stats['clients_uniques'] ?? 1847, 0) }}</h3>
                        <span class="text-success small">+12.1%</span>
                    </div>
                    <div class="bg-warning bg-opacity-10 rounded-3 p-3">
                        <i class="fa-solid fa-users text-warning fs-3"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Charts Row - Style maquette 6 & 7 -->
    <div class="row g-4 mb-4">
        <!-- Revenue Trend Chart -->
        <div class="col-md-7">
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-transparent border-0 pt-4 px-4">
                    <h5 class="fw-semibold mb-0">Revenue Trend</h5>
                </div>
                <div class="card-body">
                    <canvas id="revenueTrend" style="height: 300px;"></canvas>
                </div>
            </div>
        </div>

        <!-- Sales by Category Chart 1-->
<div class="col-md-5">
    <div class="card border-0 shadow-sm h-100">
        <div class="card-header bg-transparent border-0 pt-4 px-4 d-flex justify-content-between align-items-center">
            <h5 class="fw-semibold mb-0">Sales by Category</h5>
            <button class="btn btn-sm btn-outline-secondary" type="button" data-bs-toggle="collapse" data-bs-target="#categoryLegend" aria-expanded="true">
                <i class="fa-solid fa-chart-pie"></i>
            </button>
        </div>
        <div class="card-body d-flex align-items-center justify-content-center">
            <div style="width: 200px; height: 200px;">
                <canvas id="salesByCategory"></canvas>
            </div>
        </div>
        <div class="collapse " id="categoryLegend">
            <div class="card-footer bg-transparent border-0 pb-4 px-4">
                @foreach($categories as $index => $cat)
                <div class="d-flex justify-content-between align-items-center mb-2">
                    <div class="d-flex align-items-center">
                        <span class="d-inline-block rounded-circle me-2" style="width: 12px; height: 12px; background-color: {{ ['#4361EE', '#06B6D4', '#10B981', '#F59E0B'][$index % 4] }}"></span>
                        <span>{{ $cat->nom }}</span>
                    </div>
                    <span class="fw-semibold">{{ number_format(($cat->revenu / $categories->sum('revenu')) * 100, 1) }}%</span>
                </div>
                @endforeach
            </div>
        </div>
    </div>
</div>

    <!-- Monthly Transactions & Sales by Hour (Version compacte) -->
<div class="row g-4 mb-4">
    <!-- Monthly Transactions -->
    <div class="col-md-6">
        <div class="card border-0 shadow-sm">
            <div class="card-header bg-transparent border-0 pt-4 px-4">
                <h5 class="fw-semibold mb-0">Monthly Transactions</h5>
            </div>
            <div class="card-body">
                @php
                    $transactionsData = $transactions_mensuelles ?? [600, 450, 300, 150, 200, 350];
                    $maxValue = max($transactionsData);
                    // Échelle logarithmique pour les très grandes valeurs
                    $useLogScale = $maxValue > 1000;
                @endphp
                <div class="d-flex align-items-end justify-content-around" style="height: 180px; width: 100%;">
                    @foreach($transactionsData as $index => $value)
                        @php
                            if ($useLogScale && $value > 0) {
                                // Échelle logarithmique pour éviter les débordements
                                $logValue = log($value + 1) * 20;
                                $barHeight = min(160, $logValue);
                            } else {
                                $barHeight = $maxValue > 0 ? ($value / $maxValue) * 160 : 0;
                            }
                            $barHeight = $value > 0 ? max(8, $barHeight) : 0;
                            
                            // Formater la valeur pour l'affichage (K pour milliers)
                            $displayValue = $value >= 1000 ? round($value/1000, 1) . 'K' : $value;
                        @endphp
                        <div class="text-center" style="flex: 1; max-width: 50px;">
                            <div class="bg-primary rounded-3 mb-1 mx-auto" 
                                 style="width: 30px; height: {{ $barHeight }}px; background-color: #4361EE;"></div>
                            <span class="small d-block text-truncate" style="max-width: 50px; font-size: 11px;">
                                {{ ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'][$index] }}
                            </span>
                            <span class="small text-muted d-block" style="font-size: 10px;">{{ $displayValue }}</span>
                        </div>
                    @endforeach
                </div>
            </div>
        </div>
    </div>

    <!-- Sales by Hour -->
    <div class="col-md-6">
        <div class="card border-0 shadow-sm">
            <div class="card-header bg-transparent border-0 pt-4 px-4">
                <h5 class="fw-semibold mb-0">Sales by Hour</h5>
            </div>
            <div class="card-body">
                @php
                    $hourlyData = $ventes_par_heure ?? [60, 45, 30, 15, 40, 55];
                    $maxHourlyValue = max($hourlyData);
                @endphp
                <div class="d-flex align-items-end justify-content-around" style="height: 180px; width: 100%;">
                    @foreach($hourlyData as $index => $value)
                        @php
                            $barHeight = $maxHourlyValue > 0 ? ($value / $maxHourlyValue) * 160 : 0;
                            $barHeight = $value > 0 ? max(8, $barHeight) : 0;
                        @endphp
                        <div class="text-center" style="flex: 1; max-width: 50px;">
                            <div class="bg-info rounded-3 mb-1 mx-auto" 
                                 style="width: 30px; height: {{ $barHeight }}px; background-color: #06B6D4;"></div>
                            <span class="small d-block text-truncate" style="max-width: 50px; font-size: 11px;">
                                {{ ['10AM', '12PM', '2PM', '4PM', '6PM', '8PM'][$index] }}
                            </span>
                            <span class="small text-muted d-block" style="font-size: 10px;">{{ $value }}</span>
                        </div>
                    @endforeach
                </div>
            </div>
        </div>
    </div>
</div>

    <!-- Top Selling Products -->
    <div class="card border-0 shadow-sm">
        <div class="card-header bg-transparent border-0 pt-4 px-4">
            <h5 class="fw-semibold mb-0">Top Selling Products</h5>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th class="px-4 py-3 text-muted fw-semibold">RANK</th>
                            <th class="px-4 py-3 text-muted fw-semibold">PRODUCT NAME</th>
                            <th class="px-4 py-3 text-muted fw-semibold">UNITS SOLD</th>
                            <th class="px-4 py-3 text-muted fw-semibold">REVENUE</th>
                            <th class="px-4 py-3 text-muted fw-semibold">PERFORMANCE</th>
                        </tr>
                    </thead>
                    <tbody>
                        @foreach($topProducts as $index => $prod)
                        <tr>
                            <td class="px-4 py-3 fw-semibold">{{ $index + 1 }}</td>
                            <td class="px-4 py-3">{{ $prod->nom }}</td>
                            <td class="px-4 py-3">{{ $prod->lignes_vente_count ?? $prod->total_quantity ?? 0 }} units</td>
                            <td class="px-4 py-3 fw-semibold">${{ number_format($prod->lignesVente->sum(fn($lv) => $lv->quantite * $lv->prix_unitaire) ?? $prod->total_revenue ?? 0, 0) }}</td>
                            <td class="px-4 py-3">
                                @php
                                    $maxRevenue = $topProducts->max(fn($p) => $p->lignesVente->sum(fn($lv) => $lv->quantite * $lv->prix_unitaire) ?? 0);
                                    $percentage = $maxRevenue > 0 ? (($prod->lignesVente->sum(fn($lv) => $lv->quantite * $lv->prix_unitaire) ?? 0) / $maxRevenue) * 100 : 0;
                                @endphp
                                <div class="d-flex align-items-center gap-2">
                                    <div class="progress flex-grow-1" style="height: 8px;">
                                        <div class="progress-bar bg-success" style="width: {{ $percentage }}%"></div>
                                    </div>
                                    <span class="small text-muted">{{ number_format($percentage, 0) }}%</span>
                                </div>
                            </td>
                        </tr>
                        @endforeach
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
  // Revenue Trend Chart
  new Chart(document.getElementById('revenueTrend'), {
    type: 'line',
    data: {
      labels: {!! json_encode($trend->pluck('mois')->toArray() ?? ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun']) !!},
      datasets: [{
        label: 'Revenue',
        data: {!! json_encode($trend->pluck('revenu')->toArray() ?? [80000, 60000, 40000, 20000, 50000, 70000]) !!},
        borderColor: '#4361EE',
        backgroundColor: 'rgba(67, 97, 238, 0.1)',
        borderWidth: 2,
        fill: true,
        tension: 0.4,
        pointBackgroundColor: '#4361EE',
        pointBorderColor: '#fff',
        pointBorderWidth: 2,
        pointRadius: 4
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: {
          display: false
        }
      },
      scales: {
        y: {
          beginAtZero: true,
          grid: {
            color: 'rgba(0, 0, 0, 0.05)'
          }
        },
        x: {
          grid: {
            display: false
          }
        }
      }
    }
  });

  // Sales by Category Chart
new Chart(document.getElementById('salesByCategory'), {
    type: 'doughnut',
    data: {
        labels: {!! json_encode($categories->pluck('nom')->toArray() ?? ['Electronics', 'Utilities', 'Grocery', 'Other']) !!},
        datasets: [{
            data: {!! json_encode($categories->pluck('revenu')->toArray() ?? [33, 26, 14, 9]) !!},
            backgroundColor: ['#4361EE', '#06B6D4', '#10B981', '#F59E0B'],
            borderWidth: 0
        }]
    },
    options: {
        responsive: true,
        maintainAspectRatio: true,
        plugins: {
            legend: {
                display: false
            },
            tooltip: {
                callbacks: {
                    label: function(context) {
                        const label = context.label || '';
                        const value = context.raw || 0;
                        // Vérifier que les données sont valides
                        const total = context.dataset.data.reduce((a, b) => {
                            // S'assurer que a et b sont des nombres
                            const numA = typeof a === 'number' ? a : parseFloat(a) || 0;
                            const numB = typeof b === 'number' ? b : parseFloat(b) || 0;
                            return numA + numB;
                        }, 0);
                        
                        // Éviter la division par zéro
                        const percentage = total > 0 ? ((value / total) * 100).toFixed(1) : '0.0';
                        return `${label}: ${percentage}%`;
                    }
                }
            }
        },
        cutout: '70%'
    }
});
</script>
@endsection