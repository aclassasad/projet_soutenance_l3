<?php

namespace App\Http\Controllers;

use App\Models\Produit;
use App\Models\Vente;
use App\Models\LigneVente;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Barryvdh\DomPDF\Facade\Pdf;
use Carbon\Carbon;


class CaissierController extends Controller
{
    // Afficher dashboard (Point de Vente)
 

public function dashboard()
{
    $user = auth()->user();
    $entreprise = config('app.name');

    // Date et heure du Bénin avec jour en français
    Carbon::setLocale('fr');
    $dateHeure = Carbon::now('Africa/Porto-Novo')->translatedFormat('l d/m/Y H:i:s');

    return view('caissier.dashboard', compact('user', 'entreprise', 'dateHeure'));
}
    // Recherche produit AJAX
    public function recherche(Request $request)
    {
        $query = $request->q;

        $produits = Produit::where('nom', 'like', "%{$query}%")
            ->where('stock', '>', 0)
            ->get();

        return response()->json($produits);
    }

    // Enregistrer la vente
    public function store(Request $request)
    {
        $request->validate([
            'lignes' => 'required|array|min:1'
        ]);

        $vente = null;

        DB::transaction(function () use ($request, &$vente) {
            $totalGeneral = 0;

            // ⚠️ Ici on force user_id = 1 pour tester sans connexion
            $vente = Vente::create([
                'date_vente' => now(),
                'user_id' => 1,
                'total' => 0
            ]);

            foreach ($request->lignes as $ligne) {
                if (!isset($ligne['id']) || !isset($ligne['quantite'])) {
                    throw new \Exception("Format de ligne invalide");
                }

                $produit = Produit::findOrFail($ligne['id']);

                if ($produit->stock < $ligne['quantite']) {
                    throw new \Exception("Stock insuffisant pour ".$produit->nom);
                }

                $sousTotal = $produit->prix_vente * $ligne['quantite'];

                LigneVente::create([
                    'vente_id' => $vente->id,
                    'produit_id' => $produit->id,
                    'quantite' => $ligne['quantite'],
                    'prix_unitaire' => $produit->prix_vente,
                    'sous_total' => $sousTotal,
                ]);

                $produit->decrement('stock', $ligne['quantite']);
                $totalGeneral += $sousTotal;
            }

            $vente->update([
                'total' => $totalGeneral
            ]);
        });

        return response()->json(['success' => true, 'vente_id' => $vente->id]);
    }

    // Générer PDF
    public function pdf($id)
    {
        $vente = Vente::with('lignes.produit', 'user')->findOrFail($id);

        $pdf = Pdf::loadView('caissier.recu', compact('vente'));
        return $pdf->stream("recu_vente_{$vente->id}.pdf");
    }

    // Historique des ventes
    public function index()
    {
        $ventes = Vente::orderBy('date_vente', 'desc')->get();
        return view('caissier.historique', compact('ventes'));
    }

    // Produits en alerte stock
    public function stock()
    {
        $produits = Produit::whereColumn('stock', '<=', 'seuil_alerte')->get();
        return view('caissier.stock', compact('produits'));
    }

    // Statistiques rapides
    public function stats()
    {
        $ventesJour = Vente::whereDate('date_vente', today())->count();
        $totalJour = Vente::whereDate('date_vente', today())->sum('total');

        $produitsTop = LigneVente::select('produit_id', DB::raw('SUM(quantite) as total'))
            ->groupBy('produit_id')
            ->orderByDesc('total')
            ->take(5)
            ->with('produit')
            ->get();

        return view('caissier.stats', compact('ventesJour', 'totalJour', 'produitsTop'));
    }
}