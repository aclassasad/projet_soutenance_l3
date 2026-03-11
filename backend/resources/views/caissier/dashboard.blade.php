@extends('layouts.cashier')

@section('content')
<div class="container-fluid px-4 py-4">
    <!-- 🔖 Infos entreprise et caissier - Style maquette -->
    <div class="card border-0 shadow-sm mb-4">
        <div class="card-body">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h5 class="fw-bold mb-1">{{ $entreprise }}</h5>
                    <p class="text-muted mb-0">
                        <i class="fa-regular fa-user me-1"></i> Caissier : {{ $user->name ?? 'Non connecté' }}
                    </p>
                </div>
                <div class="text-end">
                    @php
                        $date = $dateHeure ?? now();
                    @endphp
                    <span class="badge bg-primary bg-opacity-10 text-primary px-3 py-2 rounded-pill">
                        <i class="fa-regular fa-calendar me-1"></i> {{ $date instanceof \Carbon\Carbon ? $date->format('d/m/Y') : now()->format('d/m/Y') }}
                    </span>
                    <span class="badge bg-info bg-opacity-10 text-info px-3 py-2 rounded-pill ms-2">
                        <i class="fa-regular fa-clock me-1"></i> {{ $date instanceof \Carbon\Carbon ? $date->format('H:i') : now()->format('H:i') }}
                    </span>
                </div>
            </div>
        </div>
    </div>

    <div class="row g-4">
        <!-- 🔎 RECHERCHE PRODUIT -->
        <div class="col-md-5">
            <div class="card border-0 shadow-sm h-100">
                <div class="card-header bg-transparent border-0 pt-4 px-4">
                    <div class="d-flex align-items-center">
                        <div class="bg-primary bg-opacity-10 rounded-3 p-2 me-3">
                            <i class="fa-solid fa-magnifying-glass text-primary fs-5"></i>
                        </div>
                        <h5 class="fw-semibold mb-0">Recherche Produit</h5>
                    </div>
                </div>
                <div class="card-body px-4">
                    <div class="search-container position-relative mb-4">
                        <i class="fa-solid fa-search position-absolute top-50 start-0 translate-middle-y ms-3 text-muted"></i>
                        <input type="text" id="search" class="form-control ps-5 py-2" placeholder="Nom du produit ou code barre...">
                    </div>
                    
                    <!-- Résultats de recherche -->
                    <div id="resultats" class="resultats-container" style="max-height: 400px; overflow-y: auto;"></div>
                    
                    <!-- Message d'aide -->
                    <div id="searchHelp" class="text-center text-muted py-4">
                        <i class="fa-solid fa-box-open fs-1 d-block mb-3 opacity-25"></i>
                        <p class="small">Commencez à taper pour rechercher un produit</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- 🛒 PANIER -->
        <div class="col-md-7">
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-transparent border-0 pt-4 px-4">
                    <div class="d-flex align-items-center justify-content-between">
                        <div class="d-flex align-items-center">
                            <div class="bg-success bg-opacity-10 rounded-3 p-2 me-3">
                                <i class="fa-solid fa-cart-shopping text-success fs-5"></i>
                            </div>
                            <h5 class="fw-semibold mb-0">Panier</h5>
                        </div>
                        <span class="badge bg-secondary bg-opacity-10 text-secondary px-3 py-2 rounded-pill" id="panierCount">
                            0 article(s)
                        </span>
                    </div>
                </div>
                <div class="card-body px-4">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th class="px-4 py-3">Produit</th>
                                    <th class="px-4 py-3 text-end">Prix</th>
                                    <th class="px-4 py-3 text-center">Qté</th>
                                    <th class="px-4 py-3 text-end">Sous-total</th>
                                    <th class="px-4 py-3 text-center">Action</th>
                                </tr>
                            </thead>
                            <tbody id="panier"></tbody>
                        </table>
                    </div>

                    <!-- Panier vide -->
                    <div class="text-center py-5" id="panierVide" style="display: none;">
                        <i class="fa-solid fa-basket-shopping fs-1 text-muted mb-3 opacity-25"></i>
                        <p class="text-muted">Votre panier est vide</p>
                        <p class="small text-muted">Ajoutez des produits depuis la recherche</p>
                    </div>

                    <!-- Résumé du panier -->
                    <div class="bg-light rounded-3 p-4 mt-4" id="panierResume" style="display: none;">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <span class="text-muted">Sous-total</span>
                            <span class="fw-semibold" id="sousTotal">0 FCFA</span>
                        </div>
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <!--<span class="text-muted">TVA (18%)</span>-->
                            <span class="fw-semibold" id="tva">0 FCFA</span>
                        </div>
                        <hr>
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h5 class="fw-bold mb-0">Total</h5>
                            <h4 class="fw-bold text-success mb-0" id="total">0 FCFA</h4>
                        </div>
                        
                        <div class="d-flex gap-2">
                            <button class="btn btn-outline-secondary flex-fill" onclick="viderPanier()">
                                <i class="fa-regular fa-trash-can me-2"></i>Vider
                            </button>
                            <button class="btn btn-success flex-fill" onclick="validerVente()" id="btnValider">
                                <i class="fa-regular fa-circle-check me-2"></i>Valider la vente
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
/* Styles pour les résultats de recherche */
.resultats-container .list-group-item {
    border: none;
    border-bottom: 1px solid rgba(0,0,0,0.05);
    padding: 15px 0;
    transition: background-color 0.2s;
}

.resultats-container .list-group-item:hover {
    background-color: rgba(67, 97, 238, 0.02);
}

.resultats-container .list-group-item:last-child {
    border-bottom: none;
}

.produit-info strong {
    font-size: 1rem;
    color: #1e293b;
}

.produit-details {
    display: flex;
    gap: 20px;
    margin-top: 5px;
}

.produit-details span {
    font-size: 0.85rem;
    color: #64748b;
}

.btn-ajouter {
    background: linear-gradient(135deg, #4361EE, #3A56D4);
    border: none;
    padding: 8px 20px;
    font-size: 0.9rem;
    transition: transform 0.2s;
}

.btn-ajouter:hover {
    transform: translateY(-2px);
}

/* Animation pour le panier */
@keyframes slideIn {
    from {
        opacity: 0;
        transform: translateX(20px);
    }
    to {
        opacity: 1;
        transform: translateX(0);
    }
}

#panier tr {
    animation: slideIn 0.3s ease;
}

/* Boutons simples - MOINS, PLUS, X */
.btn-simple {
    width: 32px;
    height: 32px;
    border-radius: 6px;
    border: 1px solid #e2e8f0;
    background-color: white;
    font-size: 1.2rem;
    font-weight: 600;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    transition: all 0.2s;
    margin: 0 2px;
}

.btn-simple.moins {
    color: #ef4444;
}

.btn-simple.plus {
    color: #10b981;
}

.btn-simple.x {
    color: #ef4444;
    width: 36px;
    background-color: #fee9e9;
    border-color: #fecaca;
}

.btn-simple:hover:not(:disabled) {
    transform: scale(1.1);
    background-color: #f8fafc;
}

.btn-simple.moins:hover:not(:disabled) {
    background-color: #ef4444;
    color: white;
    border-color: #ef4444;
}

.btn-simple.plus:hover:not(:disabled) {
    background-color: #10b981;
    color: white;
    border-color: #10b981;
}

.btn-simple.x:hover {
    background-color: #ef4444;
    color: white;
    border-color: #ef4444;
}

.btn-simple:disabled {
    opacity: 0.5;
    cursor: not-allowed;
}

.quantite-display {
    font-weight: 600;
    min-width: 30px;
    text-align: center;
}

/* Responsive */
@media (max-width: 768px) {
    .produit-details {
        flex-direction: column;
        gap: 5px;
    }
    
    .btn-ajouter {
        margin-top: 10px;
        width: 100%;
    }
}
</style>
@endsection

@section('scripts')
<script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>
<script>
// Configuration de toastr
toastr.options = {
    "closeButton": true,
    "progressBar": true,
    "positionClass": "toast-top-right",
    "showDuration": "300",
    "hideDuration": "1000",
    "timeOut": "3000"
};

let panier = [];

// Initialisation
document.addEventListener('DOMContentLoaded', function() {
    afficherPanier();
});

// 🔎 Recherche dynamique
document.getElementById('search').addEventListener('keyup', function() {
    let query = this.value.trim();
    let resultatsDiv = document.getElementById('resultats');
    let searchHelp = document.getElementById('searchHelp');
    
    if(query.length < 2) {
        resultatsDiv.innerHTML = "";
        if(searchHelp) searchHelp.style.display = 'block';
        return;
    }
    
    if(searchHelp) searchHelp.style.display = 'none';

    fetch(`/caissier/recherche?q=${encodeURIComponent(query)}`)
        .then(response => response.json())
        .then(data => {
            let html = '<div class="list-group list-group-flush">';
            
            if (data.length === 0) {
                html = `
                    <div class="text-center py-4">
                        <i class="fa-solid fa-face-frown fs-1 text-muted mb-3 opacity-25"></i>
                        <p class="text-muted">Aucun produit trouvé</p>
                        <p class="small text-muted">Essayez avec d'autres mots-clés</p>
                    </div>
                `;
            } else {
                data.forEach(produit => {
                    let stockClass = produit.stock > 10 ? 'text-success' : (produit.stock > 0 ? 'text-warning' : 'text-danger');
                    html += `
                        <div class="list-group-item d-flex justify-content-between align-items-start">
                            <div class="produit-info">
                                <strong>${produit.nom}</strong>
                                <div class="produit-details">
                                    <span><i class="fa-regular fa-tag me-1"></i> ${produit.prix_vente} FCFA</span>
                                    <span class="${stockClass}"><i class="fa-regular fa-box me-1"></i> Stock: ${produit.stock}</span>
                                    ${produit.code_barre ? `<span><i class="fa-regular fa-barcode me-1"></i> ${produit.code_barre}</span>` : ''}
                                </div>
                            </div>
                            <button class="btn btn-sm btn-primary btn-ajouter"
                                    onclick='ajouterProduit(${JSON.stringify(produit)})'>
                                <i class="fa-regular fa-plus me-1"></i>Ajouter
                            </button>
                        </div>
                    `;
                });
            }
            html += "</div>";
            resultatsDiv.innerHTML = html;
        })
        .catch(error => {
            console.error("Erreur AJAX :", error);
        });
});

// ➕ Ajouter au panier
function ajouterProduit(produit) {
    if(produit.stock <= 0) {
        toastr.error('Ce produit est en rupture de stock');
        return;
    }
    
    let exist = panier.find(p => p.id === produit.id);
    if (exist) {
        if(exist.quantite >= produit.stock) {
            toastr.warning('Stock insuffisant');
            return;
        }
        exist.quantite++;
    } else {
        panier.push({ 
            id: produit.id, 
            nom: produit.nom, 
            prix: parseFloat(produit.prix_vente), 
            quantite: 1,
            stock_max: produit.stock
        });
    }
    afficherPanier();
    toastr.success('Produit ajouté au panier');
}

// 🛒 Affichage panier
function afficherPanier() {
    let html = "";
    let total = 0;
    let panierVide = document.getElementById('panierVide');
    let panierResume = document.getElementById('panierResume');
    let panierCount = document.getElementById('panierCount');
    
    if(panier.length === 0) {
        if(panierVide) panierVide.style.display = 'block';
        if(panierResume) panierResume.style.display = 'none';
        if(panierCount) panierCount.textContent = '0 article(s)';
        document.getElementById("panier").innerHTML = "";
        return;
    }
    
    if(panierVide) panierVide.style.display = 'none';
    if(panierResume) panierResume.style.display = 'block';
    if(panierCount) panierCount.textContent = panier.length + ' article(s)';
    
    panier.sort((a, b) => a.nom.localeCompare(b.nom));
    
    panier.forEach((p, index) => {
        let sousTotal = p.prix * p.quantite;
        total += sousTotal;
        
        let stockWarning = p.quantite >= p.stock_max ? 
            '<small class="text-danger d-block">Stock max</small>' : '';
            
        html += `
            <tr>
                <td>
                    <div class="fw-medium">${p.nom}</div>
                    ${stockWarning}
                </td>
                <td class="text-end">${p.prix.toLocaleString()} FCFA</td>
                <td class="text-center">
                    <div class="d-flex align-items-center justify-content-center">
                        <button class="btn-simple moins" onclick="changerQuantite(${index}, ${p.quantite - 1})" 
                                ${p.quantite <= 1 ? 'disabled' : ''}>-</button>
                        <span class="quantite-display mx-1">${p.quantite}</span>
                        <button class="btn-simple plus" onclick="changerQuantite(${index}, ${p.quantite + 1})"
                                ${p.quantite >= p.stock_max ? 'disabled' : ''}>+</button>
                    </div>
                </td>
                <td class="text-end fw-semibold">${sousTotal.toLocaleString()} FCFA</td>
                <td class="text-center">
                    <button class="btn-simple x" onclick="supprimerProduit(${index})">×</button>
                </td>
            </tr>
        `;
    });
    
    let tva = total * 0.18;
    let totalTTC = total ;
    
    document.getElementById("panier").innerHTML = html;
    document.getElementById("sousTotal").innerText = total.toLocaleString() + " FCFA";
    document.getElementById("tva").innerText = tva.toLocaleString() + " FCFA";
    document.getElementById("total").innerText = totalTTC.toLocaleString() + " FCFA";
}

// 🔄 Modifier quantité
function changerQuantite(index, quantite) {
    if(quantite < 1) {
        supprimerProduit(index);
        return;
    }
    
    if(quantite > panier[index].stock_max) {
        toastr.warning('Stock insuffisant');
        return;
    }
    
    panier[index].quantite = quantite;
    afficherPanier();
}

// ❌ Supprimer produit
function supprimerProduit(index) {
    const produit = panier[index];
    panier.splice(index, 1);
    afficherPanier();
    toastr.info(`${produit.nom} retiré`);
}

// 🗑️ Vider le panier
function viderPanier() {
    if(panier.length === 0) return;
    
    if(confirm('Vider le panier ?')) {
        panier = [];
        afficherPanier();
        toastr.info('Panier vidé');
    }
}

// ✅ Valider vente - AVEC REDIRECTION FORCÉE
function validerVente() {
    if(panier.length === 0){
        toastr.warning('Panier vide !');
        return;
    }

    // Vérifier les stocks
    for(let item of panier) {
        if(item.quantite > item.stock_max) {
            toastr.error(`Stock insuffisant pour ${item.nom}`);
            return;
        }
    }

    const btnValider = document.getElementById('btnValider');
    const texteOriginal = btnValider.innerHTML;
    
    // Désactiver le bouton
    btnValider.disabled = true;
    btnValider.innerHTML = '<i class="fa-solid fa-spinner fa-spin me-2"></i>Traitement...';

    fetch('/caissier/vente', {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
            "X-CSRF-TOKEN": "{{ csrf_token() }}"
        },
        body: JSON.stringify({ lignes: panier })
    })
    .then(response => response.json())
    .then(data => {
        if(data.success){
            // Ouvrir le PDF
            if(data.vente_id) {
                window.open(`/caissier/ventes/${data.vente_id}/pdf`, '_blank');
            }
            
            // SOLUTION: Redirection vers la même page avec un paramètre pour forcer le rechargement
            window.location.href = window.location.pathname + '?reload=' + Date.now();
            
        } else {
            toastr.error(data.message || 'Erreur');
            btnValider.disabled = false;
            btnValider.innerHTML = texteOriginal;
        }
    })
    .catch(error => {
        console.error("Erreur:", error);
        toastr.error('Erreur de connexion');
        btnValider.disabled = false;
        btnValider.innerHTML = texteOriginal;
    });
}
</script>
@endsection