@extends('layouts.app')

@section('title', 'Sales')

@section('content')
<div class="container-fluid px-3 px-md-4">
    <!-- Header -->
    <div class="mb-4">
        <h2 class="fw-bold mb-1">Sales Analytics</h2>
        <p class="text-muted">Track your store's sales performance</p>
    </div>

    <!-- KPIs - Responsive -->
    <div class="row g-3 g-md-4 mb-4">
        <div class="col-12 col-sm-6 col-md-3">
            <div class="card border-0 shadow-sm h-100 hover-card">
                <div class="card-body d-flex flex-row flex-md-column flex-lg-row justify-content-between align-items-center p-3 p-md-4">
                    <div class="w-75 w-md-100 w-lg-75">
                        <h6 class="text-muted small mb-1 mb-md-2">Total Revenue</h6>
                        <h4 class="fw-bold mb-1 fs-5 fs-md-4">{{ number_format($stats['total_revenu'] ?? 297000, 0) }} <small class="fs-6">FCFA</small></h4>
                        <span class="text-success small">
                            <i class="fa-solid fa-arrow-up me-1"></i>+15.3%
                        </span>
                    </div>
                    <!--<div class="bg-primary bg-opacity-10 p-2 p-md-3 rounded-circle ms-2 ms-md-0 ms-lg-2">
                        <i class="fa-solid fa-dollar-sign text-primary fs-5 fs-md-4"></i>
                    </div>-->
                    <div class="bg-success bg-opacity-10 p-2 p-md-3 rounded-circle ms-2 ms-md-0 ms-lg-2">
                        <i class="fa-solid fa-wallet text-success fs-5 fs-md-4"></i>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-12 col-sm-6 col-md-3">
            <div class="card border-0 shadow-sm h-100 hover-card">
                <div class="card-body d-flex flex-row flex-md-column flex-lg-row justify-content-between align-items-center p-3 p-md-4">
                    <div class="w-75 w-md-100 w-lg-75">
                        <h6 class="text-muted small mb-1 mb-md-2">Total Orders</h6>
                        <h4 class="fw-bold mb-1 fs-5 fs-md-4">{{ number_format($stats['total_commandes'] ?? 2220, 0) }}</h4>
                        <span class="text-success small">
                            <i class="fa-solid fa-arrow-up me-1"></i>+8.2%
                        </span>
                    </div>
                    <div class="bg-info bg-opacity-10 p-2 p-md-3 rounded-circle ms-2 ms-md-0 ms-lg-2">
                        <i class="fa-solid fa-cart-shopping text-info fs-5 fs-md-4"></i>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-12 col-sm-6 col-md-3">
            <div class="card border-0 shadow-sm h-100 hover-card">
                <div class="card-body d-flex flex-row flex-md-column flex-lg-row justify-content-between align-items-center p-3 p-md-4">
                    <div class="w-75 w-md-100 w-lg-75">
                        <h6 class="text-muted small mb-1 mb-md-2">Avg. Order Value</h6>
                        <h4 class="fw-bold mb-1 fs-5 fs-md-4">{{ number_format($stats['moyenne_commande'] ?? 133.78, 2) }} <small class="fs-6">FCFA</small></h4>
                        <span class="text-success small">
                            <i class="fa-solid fa-arrow-up me-1"></i>+6.5%
                        </span>
                    </div>
                    <div class="bg-success bg-opacity-10 p-2 p-md-3 rounded-circle ms-2 ms-md-0 ms-lg-2">
                        <i class="fa-solid fa-receipt text-success fs-5 fs-md-4"></i>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-12 col-sm-6 col-md-3">
            <div class="card border-0 shadow-sm h-100 hover-card">
                <div class="card-body d-flex flex-row flex-md-column flex-lg-row justify-content-between align-items-center p-3 p-md-4">
                    <div class="w-75 w-md-100 w-lg-75">
                        <h6 class="text-muted small mb-1 mb-md-2">Unique Customers</h6>
                        <h4 class="fw-bold mb-1 fs-5 fs-md-4">{{ number_format($stats['clients_uniques'] ?? 1847, 0) }}</h4>
                        <span class="text-success small">
                            <i class="fa-solid fa-arrow-up me-1"></i>+12.1%
                        </span>
                    </div>
                    <div class="bg-warning bg-opacity-10 p-2 p-md-3 rounded-circle ms-2 ms-md-0 ms-lg-2">
                        <i class="fa-solid fa-users text-warning fs-5 fs-md-4"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Charts Row - Responsive -->
    <div class="row g-3 g-md-4 mb-4">
        <!-- Revenue Trend Chart -->
        <div class="col-12 col-lg-7">
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-transparent border-0 pt-3 pt-md-4 px-3 px-md-4">
                    <h5 class="fw-semibold mb-0">Revenue Trend</h5>
                </div>
                <div class="card-body">
                    <div class="chart-container" style="position: relative; height: 250px; height-md: 300px; width: 100%;">
                        <canvas id="revenueTrend"></canvas>
                    </div>
                </div>
            </div>
        </div>

        <!-- Sales by Category Chart -->
        <div class="col-12 col-lg-5">
            <div class="card border-0 shadow-sm h-100">
                <div class="card-header bg-transparent border-0 pt-3 pt-md-4 px-3 px-md-4 d-flex justify-content-between align-items-center">
                    <h5 class="fw-semibold mb-0">Sales by Category</h5>
                    <button class="btn btn-sm btn-outline-secondary" type="button" data-bs-toggle="collapse" data-bs-target="#categoryLegend" aria-expanded="true">
                        <i class="fa-solid fa-chart-pie"></i>
                    </button>
                </div>
                <div class="card-body d-flex flex-column align-items-center justify-content-center">
                    <div style="width: 180px; width-md: 200px; height: 180px; height-md: 200px;">
                        <canvas id="salesByCategory"></canvas>
                    </div>
                </div>
                <div class="collapse" id="categoryLegend">
                    <div class="card-footer bg-transparent border-0 pb-3 pb-md-4 px-3 px-md-4">
                        @foreach($categories as $index => $cat)
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <div class="d-flex align-items-center">
                                <span class="d-inline-block rounded-circle me-2" style="width: 10px; width-md: 12px; height: 10px; height-md: 12px; background-color: {{ ['#4361EE', '#06B6D4', '#10B981', '#F59E0B'][$index % 4] }}"></span>
                                <span class="small">{{ $cat->nom }}</span>
                            </div>
                            <span class="fw-semibold small">{{ number_format(($cat->revenu / $categories->sum('revenu')) * 100, 1) }}%</span>
                        </div>
                        @endforeach
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Monthly Transactions & Sales by Hour - Responsive -->
    <div class="row g-3 g-md-4 mb-4">
        <!-- Monthly Transactions -->
        <div class="col-12 col-md-6">
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-transparent border-0 pt-3 pt-md-4 px-3 px-md-4">
                    <h5 class="fw-semibold mb-0">Monthly Transactions</h5>
                </div>
                <div class="card-body">
                    @php
                        $transactionsData = $transactions_mensuelles ?? [600, 450, 300, 150, 200, 350];
                        $maxValue = max($transactionsData);
                        $useLogScale = $maxValue > 1000;
                    @endphp
                    <div class="d-flex align-items-end justify-content-around" style="height: 160px; height-md: 180px; width: 100%;">
                        @foreach($transactionsData as $index => $value)
                            @php
                                if ($useLogScale && $value > 0) {
                                    $logValue = log($value + 1) * 20;
                                    $barHeight = min(140, $logValue);
                                } else {
                                    $barHeight = $maxValue > 0 ? ($value / $maxValue) * 140 : 0;
                                }
                                $barHeight = $value > 0 ? max(6, $barHeight) : 0;
                                $displayValue = $value >= 1000 ? round($value/1000, 1) . 'K' : $value;
                            @endphp
                            <div class="text-center" style="flex: 1; max-width: 40px; max-width-md: 50px;">
                                <div class="bg-primary rounded-3 mb-1 mx-auto" 
                                     style="width: 20px; width-md: 30px; height: {{ $barHeight }}px; background-color: #4361EE;"></div>
                                <span class="small d-block text-truncate" style="max-width: 40px; max-width-md: 50px; font-size: 9px; font-size-md: 11px;">
                                    {{ ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'][$index] }}
                                </span>
                                <span class="small text-muted d-block" style="font-size: 8px; font-size-md: 10px;">{{ $displayValue }}</span>
                            </div>
                        @endforeach
                    </div>
                </div>
            </div>
        </div>

        <!-- Sales by Hour -->
        <div class="col-12 col-md-6">
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-transparent border-0 pt-3 pt-md-4 px-3 px-md-4">
                    <h5 class="fw-semibold mb-0">Sales by Hour</h5>
                </div>
                <div class="card-body">
                    @php
                        $hourlyData = $ventes_par_heure ?? [60, 45, 30, 15, 40, 55];
                        $maxHourlyValue = max($hourlyData);
                    @endphp
                    <div class="d-flex align-items-end justify-content-around" style="height: 160px; height-md: 180px; width: 100%;">
                        @foreach($hourlyData as $index => $value)
                            @php
                                $barHeight = $maxHourlyValue > 0 ? ($value / $maxHourlyValue) * 140 : 0;
                                $barHeight = $value > 0 ? max(6, $barHeight) : 0;
                            @endphp
                            <div class="text-center" style="flex: 1; max-width: 40px; max-width-md: 50px;">
                                <div class="bg-info rounded-3 mb-1 mx-auto" 
                                     style="width: 20px; width-md: 30px; height: {{ $barHeight }}px; background-color: #06B6D4;"></div>
                                <span class="small d-block text-truncate" style="max-width: 40px; max-width-md: 50px; font-size: 9px; font-size-md: 11px;">
                                    {{ ['10AM', '12PM', '2PM', '4PM', '6PM', '8PM'][$index] }}
                                </span>
                                <span class="small text-muted d-block" style="font-size: 8px; font-size-md: 10px;">{{ $value }}</span>
                            </div>
                        @endforeach
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Top Selling Products - Responsive -->
    <div class="card border-0 shadow-sm">
        <div class="card-header bg-transparent border-0 pt-3 pt-md-4 px-3 px-md-4">
            <h5 class="fw-semibold mb-0">Top Selling Products</h5>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th class="px-2 px-md-4 py-3 text-muted fw-semibold small">RANK</th>
                            <th class="px-2 px-md-4 py-3 text-muted fw-semibold small">PRODUCT NAME</th>
                            <th class="px-2 px-md-4 py-3 text-muted fw-semibold small text-end">UNITS SOLD</th>
                            <th class="px-2 px-md-4 py-3 text-muted fw-semibold small text-end">REVENUE</th>
                            <th class="px-2 px-md-4 py-3 text-muted fw-semibold small">PERFORMANCE</th>
                        </tr>
                    </thead>
                    <tbody>
                        @foreach($topProducts as $index => $prod)
                        <tr>
                            <td class="px-2 px-md-4 py-3 fw-semibold">{{ $index + 1 }}</td>
                            <td class="px-2 px-md-4 py-3 small">{{ $prod->nom }}</td>
                            <td class="px-2 px-md-4 py-3 text-end small">{{ $prod->lignes_vente_count ?? $prod->total_quantity ?? 0 }} units</td>
                            <td class="px-2 px-md-4 py-3 fw-semibold text-end small">{{ number_format($prod->lignesVente->sum(fn($lv) => $lv->quantite * $lv->prix_unitaire) ?? $prod->total_revenue ?? 0, 0) }} FCFA</td>
                            <td class="px-2 px-md-4 py-3">
                                @php
                                    $maxRevenue = $topProducts->max(fn($p) => $p->lignesVente->sum(fn($lv) => $lv->quantite * $lv->prix_unitaire) ?? 0);
                                    $percentage = $maxRevenue > 0 ? (($prod->lignesVente->sum(fn($lv) => $lv->quantite * $lv->prix_unitaire) ?? 0) / $maxRevenue) * 100 : 0;
                                @endphp
                                <div class="d-flex align-items-center gap-2" style="min-width: 80px; min-width-md: 100px;">
                                    <div class="progress flex-grow-1" style="height: 6px; height-md: 8px;">
                                        <div class="progress-bar bg-success" style="width: {{ $percentage }}%"></div>
                                    </div>
                                    <span class="small text-muted" style="font-size: 10px; font-size-md: 12px;">{{ number_format($percentage, 0) }}%</span>
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
document.addEventListener('DOMContentLoaded', function() {
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
                pointRadius: window.innerWidth < 768 ? 3 : 4
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: true,
            aspectRatio: window.innerWidth < 768 ? 1.5 : 2,
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
                    },
                    ticks: {
                        font: {
                            size: window.innerWidth < 768 ? 10 : 12
                        }
                    }
                },
                x: {
                    grid: {
                        display: false
                    },
                    ticks: {
                        font: {
                            size: window.innerWidth < 768 ? 10 : 12
                        }
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
                            const total = context.dataset.data.reduce((a, b) => {
                                const numA = typeof a === 'number' ? a : parseFloat(a) || 0;
                                const numB = typeof b === 'number' ? b : parseFloat(b) || 0;
                                return numA + numB;
                            }, 0);
                            
                            const percentage = total > 0 ? ((value / total) * 100).toFixed(1) : '0.0';
                            return `${label}: ${percentage}%`;
                        }
                    }
                }
            },
            cutout: window.innerWidth < 768 ? '65%' : '70%'
        }
    });
});

// Ajuster les graphiques lors du redimensionnement
window.addEventListener('resize', function() {
    location.reload();
});
</script>

<style>
.chart-container {
    position: relative;
    height: 250px;
    width: 100%;
    margin: 0 auto;
}

@media (min-width: 768px) {
    .chart-container {
        height: 300px;
    }
}

/* Effet de survol pour les cartes */
.hover-card {
    transition: transform 0.2s, box-shadow 0.2s;
}

.hover-card:hover {
    transform: translateY(-4px);
    box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1) !important;
}

/* Ajustements responsifs généraux */
@media (max-width: 576px) {
    .card-body {
        padding: 1rem !important;
    }
    
    h4 {
        font-size: 1.1rem !important;
    }
    
    .fs-5 {
        font-size: 1rem !important;
    }
    
    .btn-sm {
        padding: 0.25rem 0.5rem;
        font-size: 0.75rem;
    }
}

/* Styles pour les icônes */
.rounded-circle {
    transition: transform 0.2s;
}

.hover-card:hover .rounded-circle {
    transform: scale(1.1);
}

/* Ajustement pour les petits écrans */
@media (max-width: 480px) {
    .table td, .table th {
        padding: 0.5rem !important;
        font-size: 0.75rem;
    }
    
    .progress {
        min-width: 50px;
    }
}
</style>
@endsection