@extends('layouts.app')

@section('title', 'Settings')

@section('content')
<h5>Settings</h5>

@if(session('success'))
  <div class="alert alert-success">{{ session('success') }}</div>
@endif

<form method="POST" action="{{ route('settings.update') }}">
  @csrf
  <div class="mb-3">
    <label class="form-label">Language</label>
    <select class="form-select" name="language" id="languageSelect">
      <option value="en" @if($settings['language'] === 'en') selected @endif>English</option>
      <option value="fr" @if($settings['language'] === 'fr') selected @endif>Français</option>
    </select>
  </div>
  <div class="mb-3">
    <label class="form-label">Theme</label>
    <select class="form-select" name="theme" id="themeSelect">
      <option value="light" @if($settings['theme'] === 'light') selected @endif>Light</option>
      <option value="dark" @if($settings['theme'] === 'dark') selected @endif>Dark</option>
    </select>
  </div>
  <button type="submit" class="btn btn-primary">Save Changes</button>
</form>

<script>
  // Changement immédiat du thème
  document.getElementById('themeSelect').addEventListener('change', function() {
    document.body.className = this.value;
  });

  // Changement immédiat de la langue
  document.getElementById('languageSelect').addEventListener('change', function() {
    document.documentElement.lang = this.value;
  });
</script>
@endsection