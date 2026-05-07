<?php $__env->startSection('title', 'Inventory'); ?>

<?php $__env->startSection('content'); ?>
<div class="container-fluid px-3 px-md-4">
    <!-- Header avec titre et description -->
    <div class="mb-4">
        <h2 class="fw-bold mb-1">Inventory Management</h2>
        <p class="text-muted">Manage your store's product inventory</p>
    </div>

    <!-- Metrics Cards - Responsive -->
    <div class="row g-3 g-md-4 mb-4">
        <div class="col-12 col-sm-6 col-md-3">
            <div class="card border-0 shadow-sm h-100 hover-card">
                <div class="card-body d-flex flex-row flex-md-column flex-lg-row justify-content-between align-items-center p-3 p-md-4">
                    <div class="w-75 w-md-100 w-lg-75">
                        <h6 class="text-muted small mb-1 mb-md-2">Total Products</h6>
                        <h4 class="fw-bold mb-0 fs-5 fs-md-4"><?php echo e($stats['total_produits']); ?></h4>
                    </div>
                    <div class="bg-primary bg-opacity-10 p-2 p-md-3 rounded-circle ms-2 ms-md-0 ms-lg-2">
                        <i class="fa-solid fa-boxes text-primary fs-5 fs-md-4"></i>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="col-12 col-sm-6 col-md-3">
            <div class="card border-0 shadow-sm h-100 hover-card">
                <div class="card-body d-flex flex-row flex-md-column flex-lg-row justify-content-between align-items-center p-3 p-md-4">
                    <div class="w-75 w-md-100 w-lg-75">
                        <h6 class="text-muted small mb-1 mb-md-2">Low Stock Items</h6>
                        <h4 class="fw-bold mb-0 fs-5 fs-md-4"><?php echo e($stats['produits_stock_baisse']); ?></h4>
                    </div>
                    <div class="bg-warning bg-opacity-10 p-2 p-md-3 rounded-circle ms-2 ms-md-0 ms-lg-2">
                        <i class="fa-solid fa-exclamation-triangle text-warning fs-5 fs-md-4"></i>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="col-12 col-sm-6 col-md-3">
            <div class="card border-0 shadow-sm h-100 hover-card">
                <div class="card-body d-flex flex-row flex-md-column flex-lg-row justify-content-between align-items-center p-3 p-md-4">
                    <div class="w-75 w-md-100 w-lg-75">
                        <h6 class="text-muted small mb-1 mb-md-2">Out of Stock</h6>
                        <h4 class="fw-bold mb-0 fs-5 fs-md-4"><?php echo e($stats['produits_stock_fini']); ?></h4>
                    </div>
                    <div class="bg-danger bg-opacity-10 p-2 p-md-3 rounded-circle ms-2 ms-md-0 ms-lg-2">
                        <i class="fa-solid fa-times-circle text-danger fs-5 fs-md-4"></i>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="col-12 col-sm-6 col-md-3">
            <div class="card border-0 shadow-sm h-100 hover-card">
                <div class="card-body d-flex flex-row flex-md-column flex-lg-row justify-content-between align-items-center p-3 p-md-4">
                    <div class="w-75 w-md-100 w-lg-75">
                        <h6 class="text-muted small mb-1 mb-md-2">Total Value</h6>
                        <h4 class="fw-bold mb-0 fs-5 fs-md-4"><?php echo e(number_format($stats['valeur_totale'], 0, ',', ' ')); ?> <small class="fs-6">FCFA</small></h4>
                    </div>
                    <div class="bg-success bg-opacity-10 p-2 p-md-3 rounded-circle ms-2 ms-md-0 ms-lg-2">
                        <i class="fa-solid fa-wallet text-success fs-5 fs-md-4"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Search + Filter + Add Product - Responsive -->
    <div class="d-flex flex-column flex-md-row justify-content-between align-items-stretch align-items-md-center mb-3 gap-2">
        <div class="d-flex flex-column flex-sm-row w-100 w-md-75 gap-2">
            <div class="position-relative flex-grow-1">
                <i class="fa-solid fa-search position-absolute top-50 start-0 translate-middle-y ms-3 text-muted"></i>
                <input type="text" id="searchInput" class="form-control ps-5" style="height: 100%;" placeholder="Search by product name or SKU...">
            </div>
            <select id="categoryFilter" class="form-select w-100 w-sm-50 w-md-25">
                <option value="">All Categories</option>
                <?php $__currentLoopData = $categories; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $cat): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                    <option value="<?php echo e($cat->id); ?>"><?php echo e($cat->nom); ?></option>
                <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
            </select>
        </div>

        <!-- Menu Mon gestionnaire -->
        <div class="dropdown w-100 w-md-auto">
            <button class="btn btn-primary dropdown-toggle w-100 w-md-auto" type="button" id="gestionnaireMenu" data-bs-toggle="dropdown" aria-expanded="false">
                <i class="fa-solid fa-gear me-2"></i>Mon gestionnaire
            </button>
            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="gestionnaireMenu">
                <li><a class="dropdown-item" href="<?php echo e(route('produits.index')); ?>"><i class="fa-solid fa-box me-2"></i>Produits</a></li>
                <li><a class="dropdown-item" href="<?php echo e(route('categories.index')); ?>"><i class="fa-solid fa-tags me-2"></i>Catégories</a></li>
                <li><a class="dropdown-item" href="<?php echo e(route('fournisseurs.index')); ?>"><i class="fa-solid fa-truck me-2"></i>Fournisseurs</a></li>
            </ul>
        </div>
    </div>

    <!-- Product Table - Responsive -->
    <div class="card border-0 shadow-sm">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th class="px-2 px-md-4 py-3 text-muted fw-semibold small">SKU</th>
                            <th class="px-2 px-md-4 py-3 text-muted fw-semibold small">PRODUCT NAME</th>
                            <th class="px-2 px-md-4 py-3 text-muted fw-semibold small d-none d-md-table-cell">CATEGORY</th>
                            <th class="px-2 px-md-4 py-3 text-muted fw-semibold small text-end">STOCK</th>
                            <th class="px-2 px-md-4 py-3 text-muted fw-semibold small text-end">PRICE</th>
                            <th class="px-2 px-md-4 py-3 text-muted fw-semibold small d-none d-lg-table-cell">LOCATION</th>
                            <th class="px-2 px-md-4 py-3 text-muted fw-semibold small">STATUS</th>
                            <th class="px-2 px-md-4 py-3 text-muted fw-semibold small text-center">ACTIONS</th>
                        </tr>
                    </thead>
                    <tbody id="inventoryTable">
                        <?php echo $__env->make('partials.inventory_table', ['produits' => $produits], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Pagination -->
    <?php if(method_exists($produits, 'links')): ?>
    <div class="d-flex justify-content-end mt-3 px-3" id="paginationContainer">
        <?php echo e($produits->links()); ?>

    </div>
    <?php endif; ?>
</div>
<?php $__env->stopSection(); ?>

<?php $__env->startPush('scripts'); ?>
<script>
function loadInventory() {
    let query = document.getElementById('searchInput').value;
    let category = document.getElementById('categoryFilter').value;

    fetch("<?php echo e(route('inventory.search')); ?>?search=" + encodeURIComponent(query) + "&categorie_id=" + encodeURIComponent(category))
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
        fetch(`/produits/${id}`, {
            method: 'DELETE',
            headers: {
                'X-CSRF-TOKEN': '<?php echo e(csrf_token()); ?>',
                'Content-Type': 'application/json'
            }
        })
        .then(response => response.json())
        .then(data => {
            if(data.success) {
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
<?php $__env->stopPush(); ?>
<?php echo $__env->make('layouts.app', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH D:\modif\projet_soutenance_l3\backend\resources\views/inventory.blade.php ENDPATH**/ ?>