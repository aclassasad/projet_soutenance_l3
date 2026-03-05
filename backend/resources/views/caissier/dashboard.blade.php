@extends('layouts.cashier')

@section('content')
<div class="container-fluid mt-4">

<!-- 🔖 Infos entreprise et caissier -->
    <div class="alert alert-info d-flex justify-content-between">
       <div class="alert alert-info d-flex justify-content-between">
    <div class="alert alert-info d-flex justify-content-between">
    <div>
        <strong>{{ $entreprise }}</strong><br>
       <p>Caissier : {{ $user->name ?? 'Non connecté' }}</p> 
        Date & Heure : {{ $dateHeure }}
    </div>
    <div>
        
    </div>
</div>

    <div class="row">
        <!-- 🔎 RECHERCHE PRODUIT -->
        <div class="col-md-5">
            <div class="card shadow">
                <div class="card-header bg-primary text-white">Recherche Produit</div>
                <div class="card-body">
                    <input type="text" id="search" class="form-control mb-3" placeholder="Nom ou code barre...">
                    <div id="resultats"></div>
                </div>
            </div>
        </div>

        <!-- 🛒 PANIER -->
        <div class="col-md-7">
            <div class="card shadow">
                <div class="card-header bg-success text-white">Panier</div>
                <div class="card-body">
                    <table class="table table-bordered">
                        <thead class="table-light">
                            <tr>
                                <th>Produit</th>
                                <th>Prix</th>
                                <th>Qté</th>
                                <th>Sous-total</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody id="panier"></tbody>
                    </table>
                    <div class="text-end">
                        <h4>Total : <span id="total">0</span> FCFA</h4>
                        <button class="btn btn-success mt-2" onclick="validerVente()">Valider la vente</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection

@section('scripts')
<script>
let panier = [];

// 🔎 Recherche dynamique
document.getElementById('search').addEventListener('keyup', function() {
    let query = this.value;
    if(query.length < 1) {
        document.getElementById('resultats').innerHTML = "";
        return;
    }

    fetch(`/caissier/recherche?q=${query}`)
        .then(response => response.json())
        .then(data => {
            console.log("Résultats reçus :", data);
            let html = "<ul class='list-group'>";
            if (data.length === 0) {
                html = `<li class="list-group-item text-danger">Aucun produit trouvé</li>`;
            } else {
                data.forEach(produit => {
                    html += `
                        <li class="list-group-item d-flex justify-content-between align-items-center">
                            <div>
                                <strong>${produit.nom}</strong><br>
                                Prix : ${produit.prix_vente} FCFA <br>
                                Stock : ${produit.stock}
                            </div>
                            <button class="btn btn-sm btn-primary"
                                    onclick='ajouterProduit(${JSON.stringify(produit)})'>Ajouter</button>
                        </li>
                    `;
                });
            }
            html += "</ul>";
            document.getElementById('resultats').innerHTML = html;
        })
        .catch(error => console.error("Erreur AJAX :", error));
});

// ➕ Ajouter au panier
function ajouterProduit(produit) {
    let exist = panier.find(p => p.id === produit.id);
    if (exist) {
        exist.quantite++;
    } else {
        panier.push({ id: produit.id, nom: produit.nom, prix: produit.prix_vente, quantite: 1 });
    }
    afficherPanier();
}

// 🛒 Affichage panier
function afficherPanier() {
    let html = "";
    let total = 0;
    panier.forEach((p, index) => {
        let sousTotal = p.prix * p.quantite;
        total += sousTotal;
        html += `
            <tr>
                <td>${p.nom}</td>
                <td>${p.prix}</td>
                <td><input type="number" min="1" value="${p.quantite}" onchange="changerQuantite(${index}, this.value)" class="form-control form-control-sm"></td>
                <td>${sousTotal}</td>
                <td><button class="btn btn-sm btn-danger" onclick="supprimerProduit(${index})">X</button></td>
            </tr>
        `;
    });
    document.getElementById("panier").innerHTML = html;
    document.getElementById("total").innerText = total;
}

// 🔄 Modifier quantité
function changerQuantite(index, quantite) {
    panier[index].quantite = parseInt(quantite);
    afficherPanier();
}

// ❌ Supprimer produit
function supprimerProduit(index) {
    panier.splice(index, 1);
    afficherPanier();
}

// ✅ Valider vente
function validerVente() {
    if(panier.length === 0){
        alert("Panier vide !");
        return;
    }

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
        console.log("Réponse serveur :", data); // ✅ debug
        if(data.success){
            alert("Vente enregistrée !");
            panier = [];
            afficherPanier();
            // ✅ Ouvrir le PDF automatiquement
            window.open(`/caissier/vente/${data.vente_id}/pdf`, '_blank');
        } else {
            alert("Erreur lors de l'enregistrement !");
        }
    })
    .catch(error => console.error("Erreur enregistrement :", error));
}
</script>
@endsection