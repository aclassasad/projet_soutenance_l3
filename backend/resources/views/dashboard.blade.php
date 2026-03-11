@extends('layouts.app')

@section('title', 'Dashboard')

@section('content')
<div class="mx-5">
    <h2 class="card-body fw-bold">Dashboard</h2>
    <h6 class="text-muted">Welcome back! Here's what's happening today.</h6>

    <!-- Metrics Cards -->
    <div class="row my-4">
        <div class="col-md-3">
           <a href="{{ route('sales') }}" style="text-decoration: none">
            <div class="card text-center">
                <div class="card-body d-flex justify-content-between align-items-center">
                    <div class="text-start">
                        <h6 class="text-muted">Total Revenue</h6>
                        <h4 class="fw-bold">${{ number_format($stats['total_revenu'] ?? 45231, 2) }}</h4>
                        <small class="text-success">+12.5%</small>
                    </div>
                    <div class="bg-success bg-opacity-10 p-3 rounded-circle">
                        <i class="fa-solid fa-dollar-sign text-success fs-3"></i>
                    </div>
                </div>
                </a>
            </div>
        </div>
          <div class="col-md-3">
            <a href="{{ route('categories.index') }}" style="text-decoration: none">
            <div class="card text-center">
                <div class="card-body d-flex justify-content-between align-items-center">
                    <div class="text-start">
                        <h6 class="text-muted">Categories</h6>
                        <h4 class="fw-bold">{{ $stats['nombre_categories'] ?? 5 }}</h4>
                        <small class="text-warning fw-bold">⚠️ Some low stock</small>
                    </div>
                    <div class="bg-warning bg-opacity-10 p-3 rounded-circle">
                        <i class="fa-solid fa-shield-halved text-warning fs-3"></i>
                    </div>
                </div>
            </div>
            </a>
        </div>

        <div class="col-md-3">
           <a href="{{ route('produits.index') }}" style="text-decoration: none">
            <div class="card text-center">
                <div class="card-body d-flex justify-content-between align-items-center">
                    <div class="text-start">
                        <h6 class="text-muted">Products in Stock</h6>
                        <h4 class="fw-bold">{{ number_format($stats['total_produits_stock'] ?? 2847) }}</h4>
                        <small class="text-danger">-3.2%</small>
                    </div>
                    <div class="bg-primary bg-opacity-10 p-3 rounded-circle">
                        <i class="fa-solid fa-box text-primary fs-3"></i>
                    </div>
                </div>
            </div>
            </a>
        </div>

        <div class="col-md-3">
           <a href="{{ route('employees') }}" style="text-decoration: none">
            <div class="card text-center">
                <div class="card-body d-flex justify-content-between align-items-center">
                    <div class="text-start">
                        <h6 class="text-muted">Active Employees</h6>
                        <h4 class="fw-bold">{{ $stats['employes_actifs'] ?? 24 }}</h4>
                        <small class="text-success">+2</small>
                    </div>
                    <div class="bg-info bg-opacity-10 p-3 rounded-circle">
                        <i class="fa-solid fa-users text-info fs-3"></i>
                    </div>
                </div>
            </div>
            </a>
        </div>

      
    </div>

    <!-- Graphs -->
    <div class="row g-4 mb-4">
        <div class="col-md-6">
            <div class="card">
                <div class="card-body">
                    <h6 class="fw-semibold mb-3">Weekly Sales</h6>
                    <div class="chart-container" style="position: relative; height: 300px; width: 100%;">
                        <canvas id="weeklySales"></canvas>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="card">
                <div class="card-body">
                    <h6 class="fw-semibold mb-3">Store Traffic Today</h6>
                    <div class="chart-container" style="position: relative; height: 300px; width: 100%;">
                        <canvas id="storeTraffic"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Recent Alerts & Activity -->
    <div class="row g-4">
        <div class="col-md-6">
            <div class="card">
                <div class="card-header bg-transparent border-0">
                    <h6 class="fw-semibold mb-0">Recent Alerts</h6>
                </div>
                <div class="card-body">
                    <ul class="list-group list-group-flush">
                        <li class="list-group-item d-flex align-items-center gap-3 px-0">
                            <i class="fa-solid fa-circle-exclamation text-danger"></i>
                            <div>
                                <p class="mb-0">Unauthorized access attempt at rear entrance</p>
                                <small class="text-muted">5 min ago</small>
                            </div>
                        </li>
                        <li class="list-group-item d-flex align-items-center gap-3 px-0">
                            <i class="fa-solid fa-circle-exclamation text-warning"></i>
                            <div>
                                <p class="mb-0">Low stock alert: Product SKU-12847</p>
                                <small class="text-muted">12 min ago</small>
                            </div>
                        </li>
                        <li class="list-group-item d-flex align-items-center gap-3 px-0">
                            <i class="fa-solid fa-circle-exclamation text-danger"></i>
                            <div>
                                <p class="mb-0">Camera 4 offline - Aisle 7</p>
                                <small class="text-muted">25 min ago</small>
                            </div>
                        </li>
                        <li class="list-group-item d-flex align-items-center gap-3 px-0">
                            <i class="fa-solid fa-circle-check text-success"></i>
                            <div>
                                <p class="mb-0">Daily backup completed successfully</p>
                                <small class="text-muted">1 hour ago</small>
                            </div>
                        </li>
                    </ul>
                </div>
            </div>
        </div>

        <div class="col-md-6">
            <div class="card">
                <div class="card-header bg-transparent border-0">
                    <h6 class="fw-semibold mb-0">Recent Activity</h6>
                </div>
                <div class="card-body">
                    <ul class="list-group list-group-flush">
                    @foreach($stats['transactions_recentes'] ?? [] as $t)
                    <li class="list-group-item d-flex align-items-center gap-3 px-0">
                        <i class="fa-solid fa-circle text-primary" style="font-size: 8px;"></i>
                        <div class="d-flex justify-content-between w-100">
                            <div>
                                <p class="mb-0">
                                    <span class="fw-semibold">Sale Transaction</span> • {{ $t->user->name }}
                                </p>
                                <small class="text-muted">${{ number_format($t->total, 2) }}</small>
                            </div>
                            <small class="text-muted">{{ $t->created_at->format('d/m/Y H:i') }}</small>
                        </div>
                        <button class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#venteModal{{ $t->id }}">
                            Voir détails
                        </button>
                    </li>
                    @endforeach
                    </ul>
                                            @foreach($stats['transactions_recentes'] ?? [] as $t)
                        <div class="modal " id="venteModal{{ $t->id }}" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog modal-lg">
                            <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">Détails de la vente #{{ $t->id }}</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            <div class="modal-body">
                                <p><strong>Caissier :</strong> {{ $t->user->name }}</p>
                                <p><strong>Date :</strong> {{ $t->created_at->format('d/m/Y H:i') }}</p>
                                <p><strong>Total :</strong> ${{ number_format($t->total, 2) }}</p>

                                <h6>Produits :</h6>
                                <ul>
                                @foreach($t->lignes as $ligne)
    <li>
        {{ $ligne->produit?->nom ?? 'Produit inconnu' }} — 
        {{ $ligne->quantite }} x {{ $ligne->prix_unitaire }} = {{ $ligne->sous_total }}
    </li>
@endforeach
                                </ul>
                            </div>
                            <div class="modal-footer">
                                <a href="{{ route('ventes.download', $t->id) }}" class="btn btn-success">
                                Télécharger PDF
                                </a>
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Fermer</button>
                            </div>
                            </div>
                        </div>
                        </div>
                        @endforeach
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function() {
    // Données de secours avec la syntaxe PHP correcte
    const weeklyLabels = {!! json_encode($stats['weekly_sales_labels'] ?? ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']) !!};
    const weeklyData = {!! json_encode($stats['weekly_sales_data'] ?? [8000, 6000, 4000, 2000, 8500, 9500, 7000]) !!};
    
    // Pour store traffic, on vérifie si les données existent
    let trafficLabels = [];
    let trafficData = [];
    
    @if(isset($stats['store_traffic']) && count($stats['store_traffic']) > 0)
        trafficLabels = {!! json_encode(array_column($stats['store_traffic'], 'hour')) !!};
        trafficData = {!! json_encode(array_column($stats['store_traffic'], 'value')) !!};
    @else
        trafficLabels = ['9AM', '11AM', '1PM', '3PM', '5PM', '7PM'];
        trafficData = [160, 120, 80, 40, 140, 90];
    @endif

    // Weekly Sales Chart
    new Chart(document.getElementById('weeklySales'), {
        type: 'line',
        data: {
            labels: weeklyLabels,
            datasets: [{
                label: 'Weekly Sales',
                data: weeklyData,
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
            maintainAspectRatio: true,
            aspectRatio: 2,
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

    // Store Traffic Chart
    new Chart(document.getElementById('storeTraffic'), {
        type: 'bar',
        data: {
            labels: trafficLabels,
            datasets: [{
                label: 'Store Traffic',
                data: trafficData,
                backgroundColor: '#4CC9F0',
                borderRadius: 6,
                barPercentage: 0.4,
                categoryPercentage: 0.6
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: true,
            aspectRatio: 2,
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
});
</script>

<style>
.chart-container {
    position: relative;
    height: 300px;
    width: 100%;
    margin: 0 auto;
}
</style>
@endsection