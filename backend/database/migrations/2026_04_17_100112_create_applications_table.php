<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('applications', function (Blueprint $table) {

            $table->id();

            $table->foreignId('user_id')
                ->constrained()
                ->onDelete('cascade');

            $table->foreignId('opportunity_id')
                ->constrained()
                ->onDelete('cascade');

            $table->enum('status', [
                'pending',
                'accepted',
                'rejected'
            ])->default('pending');

            // alasan reject / catatan admin
            $table->text('alasan')->nullable();

            $table->timestamps();

            // cegah double apply
            $table->unique([
                'user_id',
                'opportunity_id'
            ]);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('applications');
    }
};
