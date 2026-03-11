<?php

namespace App\Http\Controllers;

use App\Models\Vente;
use App\Models\LigneVente;
use Illuminate\Http\Request;
use Barryvdh\DomPDF\Facade\Pdf;


class VenteController extends Controller
{
    // Afficher la liste des ventes
    public function index()
    {
        $ventes = Vente::with('lignes')->get();
        return view('caissier.historique', compact('ventes'));
    }

    // Formulaire de création
    public function create()
    {
        return view('ventes.create');
    }

    // Sauvegarder une nouvelle vente
    public function store(Request $request)
    {
        $vente = Vente::create([
            'date_vente' => now(),
            'total' => $request->total,
            'user_id' => $request->user_id,
        ]);

        foreach ($request->lignes as $ligne) {
            LigneVente::create([
                'vente_id' => $vente->id,
                'produit_id' => $ligne['produit_id'],
                'quantite' => $ligne['quantite'],
                'prix_unitaire' => $ligne['prix_unitaire'],
                'sous_total' => $ligne['quantite'] * $ligne['prix_unitaire'],
            ]);
        }

        // 🔔 Ajouter une notification en session
        session()->push('notifications', [
            'title' => 'Nouvelle vente',
            'message' => 'Une vente de ' . $vente->total . ' FCFA a été enregistrée.',
            'type' => 'info',
        ]);

        return redirect()->route('ventes.index')->with('success', 'Vente créée avec succès.');
    }

    // Afficher une vente
    public function show(Vente $vente)
{
    $vente->load('lignes.produit');
    $pdf = Pdf::loadView('caissier.recu', compact('vente'));
    return $pdf->stream('recu_vente_'.$vente->id.'.pdf');
}

    // Formulaire d’édition
    public function edit(Vente $vente)
    {
        $vente->load('lignes');
        return view('ventes.edit', compact('vente'));
    }

    // Mettre à jour une vente
    public function update(Request $request, Vente $vente)
    {
        $vente->update($request->all());

        // 🔔 Notification mise à jour
        session()->push('notifications', [
            'title' => 'Vente mise à jour',
            'message' => 'La vente #' . $vente->id . ' a été modifiée.',
            'type' => 'warning',
        ]);

        return redirect()->route('ventes.index')->with('success', 'Vente mise à jour.');
    }

    // Supprimer une vente
    public function destroy(Vente $vente)
    {
        $vente->delete();

        // 🔔 Notification suppression
        session()->push('notifications', [
            'title' => 'Vente supprimée',
            'message' => 'La vente #' . $vente->id . ' a été supprimée.',
            'type' => 'urgent',
        ]);

        return redirect()->route('ventes.index')->with('success', 'Vente supprimée.');
    }




// Afficher une vente en PDF (stream)
 
    // Télécharger une vente en PDF
    public function download($id)
    {
        $vente = Vente::with(['user','lignes.produit'])->findOrFail($id);

        $pdf = Pdf::loadView('caissier.recu', compact('vente'));
        return $pdf->download("recu_vente_{$vente->id}.pdf");
    }



}