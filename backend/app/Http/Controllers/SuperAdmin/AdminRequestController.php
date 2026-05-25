<?php

namespace App\Http\Controllers\SuperAdmin;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\Organization;
use App\Models\Notification;
use Illuminate\Http\Request;

class AdminRequestController extends Controller
{
    /**
     * LIST REQUEST ADMIN
     */
    public function index()
    {
        $requests = User::with('organization')
            ->whereNotNull('organization_id')
            ->where('role', 'user')
            ->latest()
            ->paginate(10);

        return view('superadmin.admin_requests.index', compact('requests'));
    }

    /**
     * APPROVE ADMIN
     */
    public function approve($id)
    {
        $user = User::findOrFail($id);

        // cek apakah sudah admin
        if ($user->role === 'admin') {

            return back()->with('error', 'User sudah menjadi admin');
        }

        // cek organization
        if ($user->organization_id === null) {

            return back()->with('error', 'User belum memiliki organisasi');
        }

        // update role user
        $user->update([
            'role' => 'admin',
            'is_verified' => true
        ]);

        // verifikasi organisasi
        Organization::where('id', $user->organization_id)
            ->update([
                'is_verified' => true
            ]);

        // notif
        try {

            Notification::create([
                'user_id' => $user->id,
                'judul' => 'Upgrade Admin Berhasil',
                'isi' => 'Selamat! Akun Anda sekarang menjadi Admin.',
                'is_read' => false
            ]);

        } catch (\Exception $e) {}

        return back()->with(
            'success',
            "{$user->name} berhasil dijadikan admin"
        );
    }

    /**
     * REJECT ADMIN
     */
    public function reject($id)
    {
        $user = User::findOrFail($id);

        // hapus organization kalau mau
        // Organization::where('id', $user->organization_id)->delete();

        $user->update([
            'organization_id' => null
        ]);

        return back()->with(
            'success',
            'Pengajuan admin berhasil ditolak'
        );
    }
}
