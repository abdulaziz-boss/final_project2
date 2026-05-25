<?php

namespace App\Http\Controllers\SuperAdmin;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\Organization;
use App\Models\Opportunity;

class DashboardController extends Controller
{
    /**
     * DASHBOARD
     */
    public function index()
    {
        // total user biasa
        $totalUsers = User::where('role', 'user')->count();

        // total admin
        $totalAdmins = User::where('role', 'admin')->count();

        // total request admin pending
        $pendingRequests = User::where('role', 'user')
            ->whereNotNull('organization_id')
            ->count();

        // total organisasi
        $totalOrganizations = Organization::count();

        // total opportunity / kegiatan
        $totalOpportunities = Opportunity::count();

        // recent request admin
        $recentRequests = User::with('organization')
            ->where('role', 'user')
            ->whereNotNull('organization_id')
            ->latest()
            ->take(5)
            ->get();

        return view('superadmin.dashboard.index', compact(
            'totalUsers',
            'totalAdmins',
            'pendingRequests',
            'totalOrganizations',
            'totalOpportunities',
            'recentRequests'
        ));
    }
}
