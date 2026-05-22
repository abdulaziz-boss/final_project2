<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;

/**
 * UserController handles user profile updates and other user-related actions.
 */
class UserController extends Controller
{
    /**
     * Update Profil dan Foto Profil User
     */
    public function updateProfile(Request $request)
    {
        $user = Auth::user();

        // Validasi input
        $validator = Validator::make($request->all(), [
            'name'        => 'required|string|max:255',
            'username'    => 'required|string|max:255|unique:users,username,' . $user->id,
            'email'       => 'required|email|unique:users,email,' . $user->id,
            'bio'         => 'nullable|string',
            'lokasi'      => 'nullable|string',
            'foto_profil' => 'nullable|image|mimes:jpeg,png,jpg|max:2048', // Max 2MB
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'errors' => $validator->errors()
            ], 422);
        }

        $data = $request->only(['name', 'username', 'email', 'bio', 'lokasi']);

        // Logika Upload Foto
        if ($request->hasFile('foto_profil')) {
            // Hapus foto lama di storage jika ada dan bukan URL Google
            if ($user->foto_profil && !filter_var($user->foto_profil, FILTER_VALIDATE_URL)) {
                Storage::disk('public')->delete($user->foto_profil);
            }

            // Simpan file baru ke folder 'profiles' di dalam storage/app/public
            $path = $request->file('foto_profil')->store('profiles', 'public');
            $data['foto_profil'] = $path;
        }

        // Update data user
        $user->update($data);

        return response()->json([
            'status' => 'success',
            'message' => 'Profil berhasil diperbarui',
            'data' => $user // Ini akan menyertakan foto_profil_url secara otomatis
        ]);
    }

    public function me()
    {
        $user = Auth::user()->load('organization');
        $user->followers_count = 0;
        $user->followings_count = 0;
        
        return response()->json([
            'status' => 'success',
            'data' => $user
        ]);
    }

    public function getUserProfile($id)
    {
        $user = \App\Models\User::with('organization')->find($id);

        if (!$user) {
            return response()->json(['status' => 'error', 'message' => 'User tidak ditemukan'], 404);
        }

        $user->followers_count = 0;
        $user->followings_count = 0;

        $opportunities = [];
        if ($user->role === 'admin') {
            $opportunities = \App\Models\Opportunity::where('created_by', $user->id)
                ->with(['creator', 'organization'])
                ->latest()
                ->get();
        }

        return response()->json([
            'status' => 'success',
            'data' => [
                'user' => $user,
                'opportunities' => $opportunities,
            ]
        ]);
    }

    public function toggleFollow($id)
    {
        return response()->json([
            'status' => 'success',
            'message' => 'Berhasil di-follow',
            'is_following' => true,
            'followers_count' => 1,
            'followings_count' => 0
        ]);
    }

    public function checkFollowStatus($id)
    {
        return response()->json([
            'status' => 'success',
            'is_following' => false,
            'followers_count' => 0,
            'followings_count' => 0
        ]);
    }

    /**
     * Cari Akun User Lain
     */
    public function search(Request $request)
    {
        $search = $request->query('search', '');
        
        $users = \App\Models\User::with('organization')
            ->where('id', '!=', Auth::id())
            ->where(function ($q) use ($search) {
                $q->where('name', 'like', '%' . $search . '%')
                  ->orWhere('username', 'like', '%' . $search . '%')
                  ->orWhere('email', 'like', '%' . $search . '%');
            })
            ->limit(20)
            ->get();

        return response()->json([
            'status' => 'success',
            'data' => $users
        ]);
    }
}