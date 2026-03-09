<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Carbon\Carbon;
use App\Models\User;

class PasswordController extends Controller
{
    // Formulaire email
    public function showEmailForm()
    {
        return view('auth.passwords.email');
    }

    // Formulaire code + nouveau mot de passe
    public function showCodeForm()
    {
        return view('auth.passwords.code');
    }

    // Envoi du code et du lien
    public function sendCode(Request $request)
    {
        $request->validate(['email' => 'required|email']);
        $user = User::where('email', $request->email)->first();

        if (!$user) {
            return back()->withErrors([
                'email' => 'L’adresse email saisie ne correspond à aucun compte enregistré.'
            ]);
        }

        // Générer code à 6 chiffres
        $code = rand(100000, 999999);
        session([
            'reset_code' => $code,
            'reset_email' => $user->email,
            'reset_expires' => now()->addMinutes(10)
        ]);

        // Générer un token pour le lien direct
        $token = Str::random(60);
        DB::table('password_resets')->updateOrInsert(
            ['email' => $user->email],
            [
                'token' => $token,
                'created_at' => now(),
                'expires_at' => now()->addMinutes(10)
            ]
        );

        // Envoyer email avec code + lien
        Mail::raw(
            "Votre code de vérification est : $code\n\n" .
            "Ce code est valable pendant 10 minutes.\n\n" .
            "Vous pouvez également cliquer sur ce lien sécurisé pour définir directement un nouveau mot de passe : " .
            url("/password/reset/$token"),
            function ($message) use ($user) {
                $message->to($user->email)->subject('Réinitialisation du mot de passe');
            }
        );

        return redirect()->route('password.code')->with('status',
            'Un code de vérification à 6 chiffres vous a été envoyé par email. Veuillez le saisir pour continuer.'
        );
    }

    // Vérifier code et changer mot de passe
    public function verifyCodeAndReset(Request $request)
    {
        $request->validate([
            'code' => 'required|numeric',
            'password' => [
                'required',
                'string',
                'min:8',
                'confirmed',
                'regex:/^(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z\d]).+$/'
            ],
        ], [
            'password.min' => 'Le mot de passe doit contenir au moins 8 caractères.',
            'password.regex' => 'Le mot de passe doit inclure au moins une majuscule, un chiffre et un caractère spécial.',
            'password.confirmed' => 'Les deux mots de passe ne correspondent pas.'
        ]);

        // Vérifier expiration
        if (now()->greaterThan(session('reset_expires'))) {
            return back()->withErrors([
                'code' => 'Votre code de vérification a expiré. Veuillez recommencer la procédure pour recevoir un nouveau code.'
            ]);
        }

        // Vérifier correspondance du code
        if ($request->code != session('reset_code')) {
            return back()->withErrors([
                'code' => 'Le code saisi ne correspond pas à celui envoyé. Veuillez vérifier votre email et réessayer.'
            ]);
        }

        // Mise à jour du mot de passe
        $user = User::where('email', session('reset_email'))->first();
        $user->password = Hash::make($request->password);
        $user->save();

        session()->forget(['reset_code', 'reset_email', 'reset_expires']);

        return redirect()->route('login')->with('status',
            'Votre mot de passe a été mis à jour avec succès. Vous pouvez désormais vous connecter avec vos nouvelles informations.'
        );
    }

    // Formulaire via lien direct
    public function showResetForm($token)
    {
        return view('auth.passwords.reset', ['token' => $token]);
    }

    // Réinitialisation via lien direct
    public function resetWithToken(Request $request)
    {
        $request->validate([
            'token' => 'required',
            'email' => 'required|email',
            'password' => [
                'required',
                'string',
                'min:8',
                'confirmed',
                'regex:/^(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z\d]).+$/'
            ],
        ], [
            'password.min' => 'Le mot de passe doit contenir au moins 8 caractères.',
            'password.regex' => 'Le mot de passe doit inclure au moins une majuscule, un chiffre et un caractère spécial.',
            'password.confirmed' => 'Les deux mots de passe ne correspondent pas.'
        ]);

        $record = DB::table('password_resets')
            ->where('email', $request->email)
            ->where('token', $request->token)
            ->first();

        if (!$record) {
            return back()->withErrors([
                'email' => 'Ce lien de réinitialisation est invalide. Veuillez demander un nouveau lien.'
            ]);
        }

        if (Carbon::parse($record->expires_at)->isPast()) {
            return back()->withErrors([
                'email' => 'Ce lien de réinitialisation a expiré. Veuillez recommencer la procédure pour obtenir un nouveau lien.'
            ]);
        }

        $user = User::where('email', $request->email)->first();
        $user->password = Hash::make($request->password);
        $user->save();

        DB::table('password_resets')->where('email', $request->email)->delete();

        return redirect()->route('login')->with('status',
            'Votre mot de passe a été changé avec succès. Vous pouvez maintenant vous connecter.'
        );
    }
}