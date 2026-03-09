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
            color: #333;
        }
        .header {
            text-align: center;
            margin-bottom: 15px;
        }
        .header h2 {
            margin: 0;
            font-size: 18px;
            text-transform: uppercase;
            border-bottom: 2px solid #000;
            display: inline-block;
            padding-bottom: 5px;
        }
        .info {
            margin-bottom: 10px;
        }
        .info p {
            margin: 2px 0;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }
        th {
            background: #f2f2f2;
            font-weight: bold;
        }
        th, td {
            border: 1px solid #000;
            padding: 6px;
            text-align: center;
        }
        .totals {
            margin-top: 15px;
            text-align: right;
        }
        .totals p {
            margin: 3px 0;
            font-size: 13px;
        }
        .footer {
            text-align: center;
            margin-top: 20px;
            font-size: 11px;
            border-top: 1px dashed #999;
            padding-top: 5px;
        }
    </style>
</head>
<body>
    <div class="header">
        <h2>Reçu de Vente</h2>
        <p><strong>{{ config('app.name') }}</strong></p>
    </div>

    <div class="info">
        <p><strong>Adresse :</strong> {{ config('app.address') ?? 'N/A' }}</p>
        <p><strong>Date :</strong> {{ $vente->date_vente }}</p>
        <p><strong>Caissier :</strong> {{ $vente->user->name ?? 'N/A' }}</p>
        <p><strong>Numéro de vente :</strong> #{{ $vente->id }}</p>
    </div>

    <table>
        <thead>
            <tr>
                <th>Produit</th>
                <th>Prix Unitaire</th>
                <th>Quantité</th>
                <th>Sous-total</th>
            </tr>
        </thead>
        <tbody>
            @foreach($vente->lignes as $ligne)
                <tr>
                    <td>{{ $ligne->produit->nom ?? 'Produit supprimé' }}</td>
                    <td>{{ number_format($ligne->prix_unitaire, 2) }} FCFA</td>
                    <td>{{ $ligne->quantite }}</td>
                    <td>{{ number_format($ligne->sous_total, 2) }} FCFA</td>
                </tr>
            @endforeach
        </tbody>
    </table>

    <div class="totals">
        <p><strong>Total :</strong> {{ number_format($vente->total, 2) }} FCFA</p>
        <p><strong>Taxe :</strong> {{ number_format($vente->taxe ?? 0, 2) }} FCFA</p>
        <p><strong>Total TTC :</strong> {{ number_format(($vente->total + ($vente->taxe ?? 0)), 2) }} FCFA</p>
    </div>

    <div class="footer">
        Merci pour votre achat ! <br>
        <small>Ce reçu est généré automatiquement par SecureStore.</small>
    </div>
</body>
</html>