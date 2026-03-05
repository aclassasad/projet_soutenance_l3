@extends('layouts.cashier')

@section('content')
<div class="container mt-4">
    <h3>Produits en alerte stock</h3>
    <table class="table table-bordered">
        <thead>
            <tr>
                <th>Nom</th>
                <th>Stock</th>
                <th>Seuil alerte</th>
            </tr>
        </thead>
        <tbody>
            @foreach($produits as $p)
            <tr>
                <td>{{ $p->nom }}</td>
                <td>{{ $p->stock }}</td>
                <td>{{ $p->seuil_alerte }}</td>
            </tr>
            @endforeach
        </tbody>
    </table>
</div>
@endsection