<?php

namespace App\Http\Controllers\SuperAdmin;

use App\Http\Controllers\Controller;
use App\Models\User;

class UserManagementController extends Controller
{
    /**
     * LIST USERS
     */
    public function index()
    {
        $users = User::latest()
            ->paginate(10);

        return view(
            'superadmin.users.index',
            compact('users')
        );
    }

    /**
     * TOGGLE STATUS
     */
    public function toggleStatus($id)
    {
        $user = User::findOrFail($id);

        $user->update([
            'is_active' => !$user->is_active
        ]);

        return back()->with(
            'success',
            'Status user berhasil diupdate'
        );
    }
}
