@forelse($produits as $p)
<tr>
    <td class="px-4 py-3 fw-semibold">SKU-{{ str_pad($p->id, 5, '0', STR_PAD_LEFT) }}</td>
    <td class="px-4 py-3">{{ $p->nom }}</td>
    <td class="px-4 py-3">{{ $p->categorie->nom ?? 'N/A' }}</td>
    <td class="px-4 py-3">{{ $p->stock }} units</td>
    <td class="px-4 py-3">${{ number_format($p->prix_vente, 2) }}</td>
    <td class="px-4 py-3">{{ $p->emplacement ?? 'A-' . str_pad($p->id, 2, '0', STR_PAD_LEFT) }}</td>
    <td class="px-4 py-3">
        @if($p->stock == 0)
            <span class="badge bg-danger bg-opacity-10 text-danger px-3 py-2 rounded-pill fw-semibold">OUT OF STOCK</span>
        @elseif($p->stock <= $p->seuil_alerte)
            <span class="badge bg-warning bg-opacity-10 text-warning px-3 py-2 rounded-pill fw-semibold">LOW STOCK</span>
        @else
            <span class="badge bg-success bg-opacity-10 text-success px-3 py-2 rounded-pill fw-semibold">IN STOCK</span>
        @endif
    </td>
    <td class="px-4 py-3">
        <div class="d-flex gap-2">
            <a href="{{ route('produits.edit', $p->id) }}" class="btn btn-sm btn-link p-0 text-secondary">
                <i class="fa-regular fa-pen-to-square"></i>
            </a>
            <button class="btn btn-sm btn-link p-0 text-secondary" onclick="deleteProduct({{ $p->id }})">
                <i class="fa-regular fa-trash-can"></i>
            </button>
        </div>
    </td>
</tr>
@empty
<tr>
    <td colspan="8" class="text-center py-5 text-muted">
        <i class="fa-solid fa-box-open fs-1 d-block mb-3"></i>
        No products found
    </td>
</tr>
@endforelse