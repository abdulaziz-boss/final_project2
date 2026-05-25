<?php

namespace App\Http\Controllers\SuperAdmin;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;

class AdminManagementController extends Controller
{
    /**
     * LIST ADMIN
     */
    public function index()
    {
        $admins = User::with('organization')
            ->where('role', 'admin')
            ->latest()
            ->paginate(10);

        return view(
            'superadmin.admins.index',
            compact('admins')
        );
    }

    /**
     * HAPUS / TURUNKAN ADMIN
     */
    public function destroy($id)
    {
        $admin = User::findOrFail($id);

        // cegah hapus super admin
        if ($admin->role === 'super_admin') {

            return back()->with(
                'error',
                'Super admin tidak bisa dihapus'
            );
        }

        // pastikan role admin
        if ($admin->role !== 'admin') {

            return back()->with(
                'error',
                'User bukan admin'
            );
        }

        // turunkan jadi user biasa
        $admin->update([
            'role' => 'user'
        ]);

        return back()->with(
            'success',
            'Admin berhasil dihapus'
        );
    }
}
