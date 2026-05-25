<?php

namespace App\Models;

use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Tymon\JWTAuth\Contracts\JWTSubject;
use Illuminate\Notifications\Notifiable;

class User extends Authenticatable implements JWTSubject
{
    use HasFactory, Notifiable;

    protected $fillable = [
        'name',
        'username',
        'email',
        'password',
        'role',
        'is_verified',
        'google_id',
        'foto_profil',
        'bio',
        'lokasi',
        'organization_id',
        'last_seen', // TAMBAH INI
    ];

    protected $casts = [
        'last_seen' => 'datetime', // TAMBAH INI
    ];

    // Otomatis tambahkan field foto_profil_url saat dikirim ke API
    protected $appends = ['foto_profil_url'];

    /**
     * Accessor untuk URL lengkap foto profil
     */
    public function getFotoProfilUrlAttribute()
    {
        if ($this->foto_profil) {

            // Jika foto berasal dari Google Auth
            if (filter_var($this->foto_profil, FILTER_VALIDATE_URL)) {
                return $this->foto_profil;
            }

            // Jika upload manual
            return url('storage/' . $this->foto_profil);
        }

        return url('assets/images/default-avatar.png');
    }

    /**
     * JWT
     */
    public function getJWTIdentifier()
    {
        return $this->getKey();
    }

    public function getJWTCustomClaims()
    {
        return [];
    }

    /**
     * RELATIONS
     */
    public function organization()
    {
        return $this->belongsTo(Organization::class);
    }

    public function applications()
    {
        return $this->hasMany(Application::class);
    }
}
