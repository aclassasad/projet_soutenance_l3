<!DOCTYPE html>
<html lang="{{ app()->getLocale() }}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Connexion</title>
    <link rel="stylesheet" href="{{ asset('css/connexion.css') }}">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
</head>
<body>
    <div class="logo">
        <a href="{{ route('dashboard') }}"><img src="{{ asset('images/logo.jpeg') }}" alt="Logo" class="desktop"></a>
    </div>

    <div class="gauche">
        
        
            <div class="social-icons">
                <a href="#" class="social-icon"><i class="fab fa-facebook-f"></i></a>
                <a href="#" class="social-icon"><i class="fab fa-youtube"></i></a>
                <a href="#" class="social-icon"><i class="fab fa-instagram"></i></a>
                <a href="#" class="social-icon"><i class="fab fa-twitter"></i></a>
            </div>
        
    </div>

    <div class="droite">
        <a href="{{ route('dashboard') }}"><img src="{{ asset('images/logo-bp1.png') }}" alt="Logo" class="mobilel"></a>
        <div class="wow">
            <h2>CONNEXION</h2>
            <p class="ouais">Veuillez entrer vos identifiants afin accrder à votre dashboard.</p>

            <form method="POST" action="{{ route('login.post') }}">
                @csrf
                <label for="email">Email</label>
                <input type="email" id="email" name="email" placeholder="Entrer votre adresse email" required value="{{ old('email') }}">

                 <label for="password">Mot de passe</label>
                <div class="password-container">
                    <input type="password" id="password" name="password" placeholder="Entrer votre mot de passe" required>
                    <span class="toggle-password" onclick="togglePassword()">
                        <i class="fas fa-eye"></i>
                    </span>
                </div>

                @error('email')
                    <div class="text-danger small" style="color: red;">{{ $message }}</div>
                @enderror

                <a href="{{ route('password.request') }}" class="forgot-password">Mot de passe oublié ?</a>

                <button type="submit" class="connexion-button">Connexion</button>

            </form>
        </div>
    </div>
</body>

<script>
function togglePassword() {
    const passwordInput = document.getElementById("password");
    const icon = document.querySelector(".toggle-password i");
    
    if (passwordInput.type === "password") {
        passwordInput.type = "text";
        icon.classList.remove("fa-eye");
        icon.classList.add("fa-eye-slash");
    } else {
        passwordInput.type = "password";
        icon.classList.remove("fa-eye-slash");
        icon.classList.add("fa-eye");
    }
}
</script>

</html>