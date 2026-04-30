<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
   public function up()
{
    Schema::create('equipements', function (Blueprint $table) {
        $table->id();
        $table->string('adresse_mac', 50)->unique();
        $table->boolean('etat')->default(1);    // 1 = actif, 0 = inactif
        $table->boolean('action')->default(0);  // 1 = action en cours, 0 = aucune
        $table->string('nom', 100);
        $table->text('description')->nullable();
        $table->timestamps();
    });
}


    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('equipements');
    }
};
