<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Password;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Mail;
use App\Mail\ResetCodeMail;

class AuthController extends Controller
{
    // 🔹 Login utilisateur
    public function login(Request $request) {
    $user = User::where('email', $request->email)->first();

    if (!$user || !Hash::check($request->password, $user->password)) {
        return response()->json(['error' => 'Invalid credentials'], 401);
    }

    // ✅ Vérifier le rôle
    if ($user->role !== 'admin') {
        return response()->json(['error' => 'Access denied'], 403);
    }

    $token = $user->createToken('securestore')->plainTextToken;

    return response()->json([
        'user' => $user,
        'token' => $token,
    ]);
}

    // 🔹 Logout utilisateur
   public function logout(Request $request)
{
    try {
        if ($request->user() && $request->user()->currentAccessToken()) {
            $request->user()->currentAccessToken()->delete();
        }

        return response()->json([
            'message' => 'Déconnexion réussie'
        ], 200);
    } catch (\Exception $e) {
        return response()->json([
            'error' => 'Erreur lors de la déconnexion',
            'details' => $e->getMessage()
        ], 500);
    }
}

    // 🔹 Inscription utilisateur
    public function register(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|email|unique:users,email',
            'password' => 'required|string|min:6',
            'role' => 'required|string|in:admin,gerant,caissier',
        ]);

        $validated['password'] = Hash::make($validated['password']);
        $validated['statut'] = true;

        $user = User::create($validated);
        $token = $user->createToken('authToken')->plainTextToken;

        return response()->json([
            'user' => $user,
            'token' => $token,
        ], 201);
    }

    // 🔹 Demande de reset password (envoi email)
   public function forgotPassword(Request $request)
{
    $request->validate(['email' => 'required|email']);
    $user = User::where('email', $request->email)->first();

    if (!$user) {
        return response()->json(['error' => 'Utilisateur introuvable'], 404);
    }

    $code = rand(100000, 999999); // code à 6 chiffres

    // Sauvegarde en base (table password_resets)
    DB::table('password_resets')->updateOrInsert(
        ['email' => $user->email],
        ['token' => $code, 'created_at' => now()]
    );

    // Envoi par mail
    Mail::to($user->email)->send(new ResetCodeMail($code));

    return response()->json(['message' => 'Code envoyé par email'], 200);
}
    // 🔹 Réinitialisation du mot de passe
    public function resetPassword(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'token' => 'required|string',
            'password' => 'required|string|min:6|confirmed',
        ]);

        $status = Password::reset(
            $request->only('email', 'password', 'password_confirmation', 'token'),
            function ($user, $password) {
                $user->forceFill([
                    'password' => Hash::make($password),
                ])->save();
            }
        );

        if ($status === Password::PASSWORD_RESET) {
            return response()->json(['message' => 'Mot de passe réinitialisé avec succès'], 200);
        }

        return response()->json(['error' => 'Échec de la réinitialisation'], 500);
    }

    public function verifyResetCode(Request $request)
{
    $request->validate([
        'code' => 'required',
        'password' => 'required|string|min:6|confirmed',
    ]);

    $reset = DB::table('password_resets')
        ->where('token', $request->code)
        ->first();

    if (!$reset) {
        return response()->json(['error' => 'Code invalide'], 400);
    }

    $user = User::where('email', $reset->email)->first();
    $user->update(['password' => Hash::make($request->password)]);

    DB::table('password_resets')->where('email', $reset->email)->delete();

    return response()->json(['message' => 'Mot de passe changé avec succès'], 200);
}
}