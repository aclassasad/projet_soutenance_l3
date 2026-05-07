<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Reçu Vente #<?php echo e($vente->id); ?></title>
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
        <p><strong><?php echo e(config('app.name')); ?></strong></p>
    </div>

    <div class="info">
        <p><strong>Adresse :</strong> <?php echo e(config('app.address') ?? 'N/A'); ?></p>
        <p><strong>Date :</strong> <?php echo e($vente->date_vente); ?></p>
        <p><strong>Caissier :</strong> <?php echo e($vente->user->name ?? 'N/A'); ?></p>
        <p><strong>Numéro de vente :</strong> #<?php echo e($vente->id); ?></p>
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
            <?php $__currentLoopData = $vente->lignes; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $ligne): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                <tr>
                    <td><?php echo e($ligne->produit->nom ?? 'Produit supprimé'); ?></td>
                    <td><?php echo e(number_format($ligne->prix_unitaire, 2)); ?> FCFA</td>
                    <td><?php echo e($ligne->quantite); ?></td>
                    <td><?php echo e(number_format($ligne->sous_total, 2)); ?> FCFA</td>
                </tr>
            <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
        </tbody>
    </table>

    <div class="totals">
        <p><strong>Total :</strong> <?php echo e(number_format($vente->total, 2)); ?> FCFA</p>
        <p><strong>Taxe :</strong> <?php echo e(number_format($vente->taxe ?? 0, 2)); ?> FCFA</p>
        <p><strong>Total TTC :</strong> <?php echo e(number_format(($vente->total + ($vente->taxe ?? 0)), 2)); ?> FCFA</p>
    </div>

    <div class="footer">
        Merci pour votre achat ! <br>
        <small>Ce reçu est généré automatiquement par SecureStore.</small>
    </div>
</body>
</html><?php /**PATH D:\modif\projet_soutenance_l3\backend\resources\views/caissier/recu.blade.php ENDPATH**/ ?>