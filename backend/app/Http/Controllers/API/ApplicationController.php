<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Application;
use App\Models\Opportunity;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class ApplicationController extends Controller
{
    /**
     * USER APPLY
     */
    public function apply($opportunityId)
    {
        try {

            $userId = Auth::id();

            // cek sudah apply atau belum
            $exists = Application::where('user_id', $userId)
                ->where('opportunity_id', $opportunityId)
                ->exists();

            if ($exists) {
                return response()->json([
                    'success' => false,
                    'message' => 'Sudah daftar'
                ], 400);
            }

            $application = Application::create([
                'user_id' => $userId,
                'opportunity_id' => $opportunityId,
                'status' => 'pending',
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Berhasil daftar',
                'data' => $application
            ], 201);

        } catch (\Exception $e) {

            return response()->json([
                'success' => false,
                'message' => 'Gagal daftar',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * CEK STATUS APPLY USER
     */
    public function check($opportunityId)
    {
        try {

            $application = Application::where(
                    'user_id',
                    Auth::id()
                )
                ->where(
                    'opportunity_id',
                    $opportunityId
                )
                ->first();

            return response()->json([
                'success' => true,
                'data' => $application
            ]);

        } catch (\Exception $e) {

            return response()->json([
                'success' => false,
                'message' => 'Gagal cek status',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * ADMIN LIHAT PARTICIPANTS
     */
    public function participants($opportunityId)
    {
        try {

            $applications = Application::with('user')
                ->where('opportunity_id', $opportunityId)
                ->latest()
                ->get();

            return response()->json([
                'success' => true,
                'data' => $applications
            ]);

        } catch (\Exception $e) {

            return response()->json([
                'success' => false,
                'message' => 'Gagal ambil participant',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * ADMIN APPROVE / REJECT
     */
    public function updateStatus(
        Request $request,
        $id
    ) {

        try {

            $request->validate([
                'status' => 'required|in:accepted,rejected',
                'alasan' => 'nullable|string'
            ]);

            $application = Application::findOrFail($id);

            // hitung accepted
            $acceptedCount = Application::where(
                    'opportunity_id',
                    $application->opportunity_id
                )
                ->where('status', 'accepted')
                ->count();

            $opportunity = Opportunity::find(
                $application->opportunity_id
            );

            // cek kuota
            if (
                $request->status == 'accepted' &&
                $acceptedCount >= $opportunity->kuota
            ) {

                return response()->json([
                    'success' => false,
                    'message' => 'Kuota penuh'
                ], 400);
            }

            $application->update([
                'status' => $request->status,
                'alasan' => $request->alasan,
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Status berhasil diupdate',
                'data' => $application
            ]);

        } catch (\Exception $e) {

            return response()->json([
                'success' => false,
                'message' => 'Gagal update status',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function myApplications()
    {
        try {

            $applications = Application::where(
                    'user_id',
                    Auth::id()
                )
                ->get();

            return response()->json([
                'success' => true,
                'data' => $applications
            ]);

        } catch (\Exception $e) {

            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil application',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}
