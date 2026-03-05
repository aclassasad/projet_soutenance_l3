@extends('layouts.cashier')

@section('content')
<div class="container mt-4">
    <h3>Historique des ventes</h3>
    <table class="table table-striped">
        <thead>
            <tr>
                <th>ID Vente</th>
                <th>Date</th>
                <th>Total</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
            @foreach($ventes as $vente)
            <tr>
                <td>{{ $vente->id }}</td>
                <td>{{ $vente->date_vente }}</td>
                <td>{{ $vente->total }} FCFA</td>
                <td>
                    <a href="{{ route('caissier.pdf', $vente->id) }}" target="_blank" class="btn btn-sm btn-primary">
                        Télécharger PDF
                    </a>
                </td>
            </tr>
            @endforeach
        </tbody>
    </table>
</div>
@endsection