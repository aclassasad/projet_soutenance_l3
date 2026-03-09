<?php

namespace App\Mail;

use App\Models\User;
use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;

class UserCreatedMail extends Mailable
{
    use Queueable, SerializesModels;

    public $user;
    public $password;

    /**
     * Crée une nouvelle instance du Mailable.
     */
    public function __construct(User $user, $password)
    {
        $this->user = $user;
        $this->password = $password;
    }

    /**
     * Construction du message.
     */
    public function build()
    {
        return $this->subject('Bienvenue dans l\'application')
                    ->from('no-reply@tonapp.com', 'Ton Application') // optionnel
                    ->replyTo('support@tonapp.com', 'Support')       // optionnel
                    ->view('emails.user_created')
                    ->with([
                        'user' => $this->user,
                        'password' => $this->password,
                    ]);
    }
}