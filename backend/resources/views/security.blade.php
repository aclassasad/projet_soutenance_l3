@extends('layouts.app')

@section('title', 'Security')

@section('content')
<h5>Security Monitoring</h5>

<!-- Stats -->
<div class="row my-4">
  <div class="col-md-3"><div class="card text-center"><div class="card-body">
    <h6>Caméras connectées</h6><h4>{{ $stats['cameras_online'] }}</h4>
  </div></div></div>
  <div class="col-md-3"><div class="card text-center"><div class="card-body">
    <h6>Incidents actifs</h6><h4>{{ $stats['active_incidents'] }}</h4>
  </div></div></div>
  <div class="col-md-3"><div class="card text-center"><div class="card-body">
    <h6>Enregistrement</h6><h4>{{ $stats['recording'] }}</h4>
  </div></div></div>
  <div class="col-md-3"><div class="card text-center"><div class="card-body">
    <h6>État du système</h6><h4 class="{{ $stats['system_status_class'] }}">{{ $stats['system_status'] }}</h4>
  </div></div></div>
</div>

<!-- Camera Feed -->
<div class="card mb-4">
  <div class="card-header">Accès principal – Porte avant <span class="badge bg-danger">REC</span></div>
  <div class="card-body text-center">
    <div class="bg-dark text-white p-5">[Live Camera Feed Placeholder]</div>
    <div class="mt-2">
      <button class="btn btn-secondary btn-sm">Play</button>
      <button class="btn btn-secondary btn-sm">Pause</button>
      <button class="btn btn-secondary btn-sm">Fullscreen</button>
    </div>
  </div>
</div>

<!-- Recent Incidents -->
<div class="row mt-4">
  <div class="col-md-12">
    <h6>Derniers incidents</h6>
    <ul class="list-group">
      @foreach($incidents as $incident)
        <li class="list-group-item">
          {{ $incident['description'] }} <br>
          <small>Location: {{ $incident['location'] }} | Date: {{ $incident['date'] }}</small>
          <button class="btn btn-sm btn-danger float-end">Examiner</button>
        </li>
      @endforeach
    </ul>
  </div>
</div>

<!-- Incident Types Chart -->
<div class="mt-4">
  <h6>Vue d’ensemble des types d’incidents</h6>
  <canvas id="incidentTypes"></canvas>
</div>

<script>
  new Chart(document.getElementById('incidentTypes'), {
    type: 'bar',
    data: {
      labels: {!! json_encode(array_column($incidentStats, 'type')) !!},
      datasets: [{
        label: 'Incidents',
        data: {!! json_encode(array_column($incidentStats, 'count')) !!},
        backgroundColor: 'red'
      }]
    }
  });
</script>
@endsection