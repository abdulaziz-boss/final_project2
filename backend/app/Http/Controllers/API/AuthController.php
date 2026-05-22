<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;
use App\Models\Notification;
use App\Models\Organization;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Tymon\JWTAuth\Facades\JWTAuth;
use Tymon\JWTAuth\Exceptions\JWTException;
use Laravel\Socialite\Facades\Socialite;

class AuthController extends Controller
{
    /**
     * GOOGLE LOGIN
     */
    public function googleLogin(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'token' => 'required',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'errors' => $validator->errors()
            ], 422);
        }

        try {

            $googleUser = Socialite::driver('google')
                ->stateless()
                ->userFromToken($request->token);

            $user = User::where('email', $googleUser->getEmail())->first();

            $isNewUser = false;

            if (!$user) {

                $user = User::create([
                    'name'        => $googleUser->getName(),
                    'email'       => $googleUser->getEmail(),
                    'google_id'   => $googleUser->getId(),
                    'username'    => explode('@', $googleUser->getEmail())[0] . rand(10, 99),
                    'role'        => 'user',
                    'is_verified' => true,
                    'password'    => null,
                ]);

                $isNewUser = true;

            } else {

                $user->update([
                    'google_id' => $googleUser->getId()
                ]);
            }

            $token = JWTAuth::fromUser($user);

            return response()->json([
                'status' => 'success',
                'message' => 'Login Google berhasil',
                'is_new_user' => $isNewUser,
                'data' => [
                    'user' => $user->load('organization'),
                    'token' => $this->respondWithToken($token)
                ]
            ]);

        } catch (\Exception $e) {

            return response()->json([
                'status' => 'error',
                'message' => 'Gagal autentikasi Google',
                'error' => $e->getMessage()
            ], 401);
        }
    }

    /**
     * REGISTER
     */
    public function register(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255|unique:users',
            'email' => 'required|email|unique:users',
            'password' => 'required|string|min:6|confirmed',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'errors' => $validator->errors()
            ], 422);
        }

        $user = User::create([
            'name'        => $request->name,
            'username'    => explode('@', $request->email)[0] . rand(10, 99),
            'email'       => $request->email,
            'password'    => Hash::make($request->password),
            'role'        => 'user',
            'is_verified' => true,
        ]);

        return response()->json([
            'status' => 'success',
            'message' => 'Registrasi berhasil',
            'data' => $user
        ], 201);
    }

    /**
     * LOGIN
     */
    public function login(Request $request)
    {
        $credentials = $request->only('email', 'password');

        try {

            if (!$token = JWTAuth::attempt($credentials)) {

                return response()->json([
                    'status' => 'error',
                    'message' => 'Email atau password salah'
                ], 401);
            }

            $user = auth()->user();

        } catch (JWTException $e) {

            return response()->json([
                'status' => 'error',
                'message' => 'Gagal membuat token',
                'error' => $e->getMessage()
            ], 500);
        }

        return response()->json([
            'status' => 'success',
            'message' => 'Login berhasil',
            'data' => [
                'user' => $user->load('organization'),
                'token' => $this->respondWithToken($token)
            ]
        ]);
    }

    /**
     * REFRESH TOKEN
     */
    public function refresh()
    {
        try {

            $newToken = JWTAuth::refresh(JWTAuth::getToken());

            return response()->json([
                'status' => 'success',
                'data' => [
                    'access_token' => $newToken,
                    'token_type' => 'bearer',
                    'expires_in' => JWTAuth::factory()->getTTL() * 60,
                ]
            ]);

        } catch (\Exception $e) {

            return response()->json([
                'status' => 'error',
                'message' => 'Refresh token gagal',
                'error' => $e->getMessage()
            ], 401);
        }
    }

    /**
     * REQUEST UPGRADE
     */
    public function requestUpgrade(Request $request)
    {
        $user = auth()->user();

        if ($user->organization_id != null) {
            return response()->json([
                'status' => 'error',
                'message' => 'Anda sudah mengajukan upgrade'
            ], 400);
        }

        $validator = Validator::make($request->all(), [
            'nama_organisasi' => 'required|string|max:255',
            'deskripsi' => 'required|string',
            'lokasi' => 'nullable|string',
            'website' => 'nullable|url',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'errors' => $validator->errors()
            ], 422);
        }

        $organization = Organization::create([
            'nama_organisasi' => $request->nama_organisasi,
            'deskripsi' => $request->deskripsi,
            'lokasi' => $request->lokasi,
            'website' => $request->website,
            'is_verified' => false,
        ]);

        $user->update([
            'organization_id' => $organization->id
        ]);

        return response()->json([
            'status' => 'success',
            'message' => 'Permintaan upgrade berhasil dikirim',
            'data' => $user->load('organization')
        ]);
    }

    /**
     * GET PENDING ADMINS
     */
    public function getPendingAdmins()
    {
        $pendingUsers = User::with('organization')
            ->whereNotNull('organization_id')
            ->where('role', 'user')
            ->get();

        return response()->json([
            'success' => true,
            'count' => $pendingUsers->count(),
            'data' => $pendingUsers
        ]);
    }

    /**
     * APPROVE ADMIN
     */
    public function approveAdmin($id)
    {
        if (auth()->user()->role !== 'super_admin') {

            return response()->json([
                'message' => 'Akses ditolak'
            ], 403);
        }

        $user = User::find($id);

        if (!$user) {

            return response()->json([
                'message' => 'User tidak ditemukan'
            ], 404);
        }

        if ($user->organization_id === null) {

            return response()->json([
                'status' => 'error',
                'message' => 'User belum mengisi data organisasi'
            ], 400);
        }

        $user->update([
            'role' => 'admin',
            'is_verified' => true
        ]);

        Organization::where('id', $user->organization_id)
            ->update([
                'is_verified' => true
            ]);

        try {

            Notification::create([
                'user_id' => $user->id,
                'judul' => 'Upgrade Premium Berhasil',
                'isi' => 'Selamat! Akun Anda kini menjadi Admin.',
                'is_read' => false
            ]);

        } catch (\Exception $e) {}

        return response()->json([
            'status' => 'success',
            'message' => "User {$user->name} sekarang resmi menjadi Admin!"
        ]);
    }

    /**
     * GET NOTIFICATIONS
     */
    public function getNotifications()
    {
        $notifications = Notification::where('user_id', auth()->id())
            ->orderBy('created_at', 'desc')
            ->get();

        return response()->json([
            'status' => 'success',
            'data' => $notifications
        ]);
    }

    /**
     * LOGOUT
     */
    public function logout()
    {
        JWTAuth::invalidate(JWTAuth::getToken());

        return response()->json([
            'status' => 'success',
            'message' => 'Logout berhasil'
        ]);
    }

    /**
     * GET CURRENT USER
     */
    public function me()
    {
        return response()->json([
            'status' => 'success',
            'data' => auth()->user()->load('organization')
        ]);
    }

    /**
     * TOKEN RESPONSE
     */
    protected function respondWithToken($token)
    {
        return [
            'access_token' => $token,
            'token_type' => 'bearer',
            'expires_in' => JWTAuth::factory()->getTTL() * 60,
        ];
    }
}
