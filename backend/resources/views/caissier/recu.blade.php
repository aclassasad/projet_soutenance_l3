<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Reçu Vente #{{ $vente->id }}</title>
    <style>
        body { 
            font-family: DejaVu Sans, sans-serif; 
            font-size: 12px; 
            margin: 20px;
        }
        h2, h3 { text-align: center; margin: 5px 0; }
        p { margin: 2px 0; }
        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        th, td { border: 1px solid #000; padding: 5px; text-align: left; }
        .footer { text-align: center; margin-top: 15px; font-size: 11px; }
    </style>
</head>
<body>
    <h2>CASH RECEIPT</h2>
    <p><strong>Shop Name :</strong> {{ config('app.name') }}</p>
    <p><strong>Adresse :</strong> {{ config('app.address') ?? 'N/A' }}</p>
    <p><strong>Date :</strong> {{ $vente->date_vente }}</p>
    <p><strong>Caissier :</strong> {{ $vente->user->name ?? 'N/A' }}</p>

    <table>
        <thead>
            <tr>
                <th>Produit</th>
                <th>Prix</th>
                <th>Qté</th>
                <th>Sous-total</th>
            </tr>
        </thead>
        <tbody>
            @foreach($vente->lignes as $ligne)
                <tr>
<td>{{ $ligne->produit->nom ?? 'Produit supprimé' }}</td>                    <td>{{ number_format($ligne->prix_unitaire, 2) }} FCFA</td>
                    <td>{{ $ligne->quantite }}</td>
                    <td>{{ number_format($ligne->sous_total, 2) }} FCFA</td>
                </tr>
            @endforeach
        </tbody>
    </table>

    <h3>Total : {{ number_format($vente->total, 2) }} FCFA</h3>
    <p><strong>Taxe :</strong> {{ number_format($vente->taxe ?? 0, 2) }} FCFA</p>

    <div class="footer">
        Merci pour votre achat ! <br>
        <small>Ce reçu est généré automatiquement par le système.</small>
    </div>
</body>
</html>