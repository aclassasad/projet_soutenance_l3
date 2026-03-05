@extends('layouts.cashier')

@section('content')
<div class="container mt-4">
    <h3>Statistiques du jour</h3>
    <p>Nombre de ventes : {{ $ventesJour }}</p>
    <p>Total encaissé : {{ $totalJour }} FCFA</p>

    <h4>Top 5 produits vendus</h4>
    <ul>
        @foreach($produitsTop as $p)
            <li>{{ $p->produit->nom }} ({{ $p->total }} vendus)</li>
        @endforeach
    </ul>
</div>
@endsection