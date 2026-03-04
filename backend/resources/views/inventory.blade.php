@extends('layouts.app')

@section('title', 'Inventory')

@section('content')
<h5>Inventory Overview</h5>

<!-- Metrics Cards -->
<div class="row my-4">
  <div class="col-md-3">
    <div class="card text-center">
      <div class="card-body">
        <h6>Total Products</h6>
        <h4>{{ $stats['total_produits'] }}</h4>
      </div>
    </div>
  </div>
  <div class="col-md-3">
    <div class="card text-center">
      <div class="card-body">
        <h6>Low Stock Items</h6>
        <h4>{{ $stats['produits_stock_baisse'] }}</h4>
      </div>
    </div>
  </div>
  <div class="col-md-3">
    <div class="card text-center">
      <div class="card-body">
        <h6>Out of Stock</h6>
        <h4>{{ $stats['produits_stock_fini'] }}</h4>
      </div>
    </div>
  </div>
  <div class="col-md-3">
    <div class="card text-center">
      <div class="card-body">
        <h6>Total Value</h6>
        <h4>${{ $stats['valeur_totale'] }}</h4>
      </div>
    </div>
  </div>
</div>

<!-- Search + Filter + Add Product -->
<div class="d-flex justify-content-between mb-3">
  <div class="d-flex w-75 gap-2">
    <input type="text" id="searchInput" class="form-control w-50" placeholder="Search products by name...">

    <select id="categoryFilter" class="form-select w-25">
      <option value="">All Categories</option>
      @foreach($categories as $cat)
        <option value="{{ $cat->id }}">{{ $cat->nom }}</option>
      @endforeach
    </select>
  </div>

  <a href="{{ route('produits.create') }}" class="btn btn-success">+ Add Product</a>
</div>

<!-- Product Table -->
<div id="inventoryTable">
  @include('partials.inventory_table', ['produits' => $produits])
</div>
@endsection

@push('scripts')
<script>
function loadInventory() {
    let query = document.getElementById('searchInput').value;
    let category = document.getElementById('categoryFilter').value;

    fetch("{{ route('inventory.search') }}?search=" + query + "&categorie_id=" + category)
        .then(response => response.text())
        .then(html => {
            document.getElementById('inventoryTable').innerHTML = html;
        })
        .catch(error => console.error('Erreur AJAX:', error));
}

document.getElementById('searchInput').addEventListener('keyup', loadInventory);
document.getElementById('categoryFilter').addEventListener('change', loadInventory);
</script>
@endpush