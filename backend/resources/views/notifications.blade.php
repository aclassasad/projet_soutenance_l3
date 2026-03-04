@extends('layouts.app')

@section('title', 'Notifications')

@section('content')
<h5>Notifications</h5>

@if(session('success'))
  <div class="alert alert-success">{{ session('success') }}</div>
@endif

<div class="row mt-4">
  <div class="col-md-12">
    <ul class="list-group">
      @forelse($notifications as $notif)
        <li class="list-group-item d-flex justify-content-between align-items-center">
          <div>
            <strong>{{ $notif['title'] }}</strong><br>
            <small class="text-muted">{{ $notif['message'] }}</small>
          </div>
          <span class="badge 
            @if($notif['type'] === 'urgent') bg-danger
            @elseif($notif['type'] === 'warning') bg-warning
            @else bg-info
            @endif">
            {{ strtoupper($notif['type']) }}
          </span>
        </li>
      @empty
        <li class="list-group-item text-muted">Aucune notification disponible</li>
      @endforelse
    </ul>

    <!-- Bouton pour effacer les notifications -->
    <form action="{{ route('notifications.clear') }}" method="POST" class="mt-3">
      @csrf
      <button type="submit" class="btn btn-outline-danger">Effacer les notifications</button>
    </form>
  </div>
</div>
@endsection