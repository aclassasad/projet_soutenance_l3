@extends('layouts.app')

@section('title', 'Inventory')

@section('content')
<div class="mx-4">
    <!-- Header avec titre et description comme sur la maquette -->
    <div class="mb-4">
        <h2 class="fw-bold mb-1">Inventory Management</h2>
        <p class="text-muted">Manage your store's product inventory</p>
    </div>

    <!-- Metrics Cards - Style maquette avec icônes -->
    <div class="row my-4">
        <div class="col-md-3">
            <div class="card">
                <div class="card-body d-flex justify-content-between align-items-center">
                    <div>
                        <h6 class="text-muted">Total Products</h6>
                        <h4 class="fw-bold">{{ $stats['total_produits'] }}</h4>
                    </div>
                    <div class="bg-primary bg-opacity-10 p-3 rounded">
                        <i class="fa-solid fa-boxes text-primary fs-3"></i>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card">
                <div class="card-body d-flex justify-content-between align-items-center">
                    <div>
                        <h6 class="text-muted">Low Stock Items</h6>
                        <h4 class="fw-bold">{{ $stats['produits_stock_baisse'] }}</h4>
                    </div>
                    <div class="bg-warning bg-opacity-10 p-3 rounded">
                        <i class="fa-solid fa-exclamation-triangle text-warning fs-3"></i>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card">
                <div class="card-body d-flex justify-content-between align-items-center">
                    <div>
                        <h6 class="text-muted">Out of Stock</h6>
                        <h4 class="fw-bold">{{ $stats['produits_stock_fini'] }}</h4>
                    </div>
                    <div class="bg-danger bg-opacity-10 p-3 rounded">
                        <i class="fa-solid fa-times-circle text-danger fs-3"></i>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card">
                <div class="card-body d-flex justify-content-between align-items-center">
                    <div>
                        <h6 class="text-muted">Total Value</h6>
                        <h4 class="fw-bold">${{ $stats['valeur_totale'] }}</h4>
                    </div>
                    <div class="bg-success bg-opacity-10 p-3 rounded">
                        <i class="fa-solid fa-dollar-sign text-success fs-3"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Search + Filter + Add Product inchangé -->
    <div class="d-flex justify-content-between mb-3">
        <div class="d-flex w-75 gap-2">
            <input type="text" id="searchInput" class="form-control w-50" placeholder="Search by product name or SKU...">

            <select id="categoryFilter" class="form-select w-25">
                <option value="">All Categories</option>
                @foreach($categories as $cat)
                    <option value="{{ $cat->id }}">{{ $cat->nom }}</option>
                @endforeach
            </select>
        </div>

        <!-- ✅ Nouveau bouton Mon gestionnaire -->
        <div class="dropdown">
            <button class="btn btn-primary dropdown-toggle" type="button" id="gestionnaireMenu" data-bs-toggle="dropdown" aria-expanded="false">
                Mon gestionnaire
            </button>
            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="gestionnaireMenu">
                <li><a class="dropdown-item" href="{{ route('produits.index') }}">Produits</a></li>
                <li><a class="dropdown-item" href="{{ route('categories.index') }}">Catégories</a></li>
                <li><a class="dropdown-item" href="{{ route('fournisseurs.index') }}">Fournisseurs</a></li>
            </ul>
        </div>
    </div>

    <!-- Product Table avec style maquette -->
    <div class="card">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead class="table-light">
                        <tr>
                            <th class="px-4 py-3">SKU</th>
                            <th class="px-4 py-3">PRODUCT NAME</th>
                            <th class="px-4 py-3">CATEGORY</th>
                            <th class="px-4 py-3">STOCK</th>
                            <th class="px-4 py-3">PRICE</th>
                            <th class="px-4 py-3">LOCATION</th>
                            <th class="px-4 py-3">STATUS</th>
                            <th class="px-4 py-3">ACTIONS</th>
                        </tr>
                    </thead>
                    <tbody id="inventoryTable">
                        @include('partials.inventory_table', ['produits' => $produits])
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Pagination -->
    @if(method_exists($produits, 'links'))
    <div class="d-flex justify-content-end mt-3 px-3" id="paginationContainer">
        {{ $produits->links() }}
    </div>
    @endif
</div>
@endsection

@push('scripts')
<script>
function loadInventory() {
    let query = document.getElementById('searchInput').value;
    let category = document.getElementById('categoryFilter').value;

    fetch("{{ route('inventory.search') }}?search=" + encodeURIComponent(query) + "&categorie_id=" + encodeURIComponent(category))
        .then(response => response.text())
        .then(html => {
            // Remplacer uniquement le contenu du tbody
            document.getElementById('inventoryTable').innerHTML = html;
            
            // Cacher la pagination pendant la recherche
            const pagination = document.getElementById('paginationContainer');
            if (pagination) {
                if (query.trim() !== '' || category !== '') {
                    pagination.style.display = 'none';
                } else {
                    pagination.style.display = 'flex';
                }
            }
        })
        .catch(error => console.error('Erreur AJAX:', error));
}

function deleteProduct(id) {
    if(confirm('Êtes-vous sûr de vouloir supprimer ce produit ?')) {
        // À implémenter avec une requête AJAX ou un formulaire
        console.log('Delete product ' + id);
        
        // Exemple avec fetch pour une suppression AJAX
        fetch(`/produits/${id}`, {
            method: 'DELETE',
            headers: {
                'X-CSRF-TOKEN': '{{ csrf_token() }}',
                'Content-Type': 'application/json'
            }
        })
        .then(response => response.json())
        .then(data => {
            if(data.success) {
                // Recharger la liste après suppression
                loadInventory();
            } else {
                alert('Erreur lors de la suppression');
            }
        })
        .catch(error => console.error('Erreur:', error));
    }
}

// Initialisation des événements
document.addEventListener('DOMContentLoaded', function() {
    const searchInput = document.getElementById('searchInput');
    const categoryFilter = document.getElementById('categoryFilter');
    
    if (searchInput) {
        searchInput.addEventListener('keyup', loadInventory);
    }
    
    if (categoryFilter) {
        categoryFilter.addEventListener('change', loadInventory);
    }
});
</script>
@endpush