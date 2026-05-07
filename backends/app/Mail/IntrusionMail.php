<?php
namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;

class IntrusionMail extends Mailable
{
    use Queueable, SerializesModels;

    public $owner;

    public function __construct($owner)
    {
        $this->owner = $owner;
    }

    public function build()
    {
        return $this->subject('🚨 Alerte Sécurité - Intrusion détectée')
                    ->view('emails.intrusion')
                    ->with(['owner' => $this->owner]);
                    
                       
    }
}
