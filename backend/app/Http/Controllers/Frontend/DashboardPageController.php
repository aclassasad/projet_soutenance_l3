<?php

namespace App\Http\Controllers\Frontend;

use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\DB;

class DashboardPageController extends Controller
{
    public function index()
    {
        // Exemple : récupérer quelques stats depuis la base
        $totalProduits = DB::table('produits')->count();
        $totalVentes   = DB::table('ventes')->count();
        $totalEmployes = DB::table('employees')->count();

        return view('dashboard', [
            'totalProduits' => $totalProduits,
            'totalVentes'   => $totalVentes,
            'totalEmployes' => $totalEmployes,
        ]);
    }
}