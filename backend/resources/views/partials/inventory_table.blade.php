<div class="table-responsive">
  <table class="table table-striped">
    <thead>
      <tr>
        <th>ID</th>
        <th>Product Name</th>
        <th>Category</th>
        <th>Stock</th>
        <th>Price</th>
        <th>Supplier</th>
        <th>Status</th>
        <th>Action</th>
      </tr>
    </thead>
    <tbody>
      @forelse($produits as $p)
        <tr>
          <td>{{ $p->id }}</td>
          <td>{{ $p->nom }}</td>
          <td>{{ $p->categorie->nom ?? 'N/A' }}</td>
          <td>{{ $p->stock }}</td>
          <td>${{ $p->prix_vente }}</td>
          <td>{{ $p->fournisseur->nom ?? 'N/A' }}</td>
          <td>
            @if($p->stock == 0)
              <span class="badge bg-danger">OUT OF STOCK</span>
            @elseif($p->stock <= $p->seuil_alerte)
              <span class="badge bg-warning">LOW STOCK</span>
            @else
              <span class="badge bg-success">IN STOCK</span>
            @endif
          </td>
          <td>
            <a href="{{ route('produits.edit', $p->id) }}" class="btn btn-sm btn-secondary">Edit</a>
          </td>
        </tr>
      @empty
        <tr>
          <td colspan="8" class="text-center">No products found</td>
        </tr>
      @endforelse
    </tbody>
  </table>
</div>

{{ $produits->links() }}